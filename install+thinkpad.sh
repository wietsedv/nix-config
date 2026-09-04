#!/usr/bin/env bash
# Fresh NixOS install for the `thinkpad` host: LUKS2 + btrfs subvolumes + lanzaboote.
#
# Run as root from a NixOS installer ISO (booted in UEFI mode):
#
#   ./install.sh /dev/nvme0n1
#
# It wipes the given disk, sets up encryption and the btrfs subvolume layout,
# generates the hardware/filesystem modules for this machine, creates the Secure
# Boot keys that lanzaboote signs with, and runs nixos-install from this flake.
set -euo pipefail

HOST="${HOST:-thinkpad}"
LUKS_NAME="${LUKS_NAME:-cryptroot}"
ESP_SIZE="${ESP_SIZE:-4GiB}"  # lanzaboote stores a full UKI per generation
SWAP_SIZE_GB="${SWAP_SIZE_GB:-64}"
MNT="${MNT:-/mnt}"
FLAKE_REPO="${FLAKE_REPO:-https://github.com/wietsedv/nix-config.git}"

NIX_FLAGS=(--extra-experimental-features "nix-command flakes")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat >&2 <<EOF
usage: $(basename "$0") [-y] <disk>

  <disk>  whole-disk device to erase, e.g. /dev/nvme0n1
  -y      do not ask for confirmation before erasing the disk

environment overrides:
  HOST=$HOST  LUKS_NAME=$LUKS_NAME  ESP_SIZE=$ESP_SIZE
  SWAP_SIZE_GB=$SWAP_SIZE_GB  MNT=$MNT  FLAKE_REPO=$FLAKE_REPO
EOF
  exit 1
}

ASSUME_YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    -y | --yes) ASSUME_YES=1; shift ;;
    -h | --help) usage ;;
    -*) die "unknown option: $1" ;;
    *) break ;;
  esac
done
[ $# -eq 1 ] || usage
DISK="$1"

# Re-exec inside a nix shell if the installer lacks any of the tools we need.
if [ -z "${INSTALL_SH_WRAPPED:-}" ]; then
  missing=()
  for tool in sgdisk cryptsetup mkfs.btrfs mkfs.vfat blkid partprobe git sbctl \
    nixos-install nixos-generate-config nixos-enter; do
    command -v "$tool" >/dev/null || missing+=("$tool")
  done
  if [ ${#missing[@]} -gt 0 ]; then
    log "missing tools (${missing[*]}), re-executing inside nix shell"
    export INSTALL_SH_WRAPPED=1
    args=()
    [ "$ASSUME_YES" -eq 1 ] && args+=(-y)
    exec nix "${NIX_FLAGS[@]}" shell \
      nixpkgs#gptfdisk nixpkgs#cryptsetup nixpkgs#btrfs-progs nixpkgs#dosfstools \
      nixpkgs#parted nixpkgs#util-linux nixpkgs#git nixpkgs#sbctl \
      nixpkgs#nixos-install-tools \
      --command "${BASH_SOURCE[0]}" "${args[@]}" "$DISK"
  fi
fi

# --- preflight -----------------------------------------------------------------

[ "$(id -u)" -eq 0 ] || die "run as root"
[ -d /sys/firmware/efi ] || die "not booted in UEFI mode; Secure Boot needs an EFI install"
[ -b "$DISK" ] || die "$DISK is not a block device"

if [ -d "$SCRIPT_DIR/.git" ] && [ -f "$SCRIPT_DIR/flake.nix" ]; then
  FLAKE_SRC="$SCRIPT_DIR"
else
  FLAKE_SRC=""
fi

# Partition device names: /dev/nvme0n1 -> p1, /dev/sda -> 1.
case "$DISK" in
  *[0-9]) PART_PREFIX="${DISK}p" ;;
  *) PART_PREFIX="$DISK" ;;
esac
ESP_PART="${PART_PREFIX}1"
LUKS_PART="${PART_PREFIX}2"

log "install plan"
cat <<EOF
  host              $HOST
  disk              $DISK  ($(lsblk -ndo SIZE,MODEL "$DISK" | tr -s ' '))
  ESP               $ESP_PART  vfat, $ESP_SIZE, mounted at /boot
  LUKS2 container   $LUKS_PART -> /dev/mapper/$LUKS_NAME
  btrfs subvolumes  root -> /, home -> /home, nix -> /nix, var/log -> /var/log,
                    swap -> /swap (${SWAP_SIZE_GB}G swapfile), pool -> /btr_pool
  bootloader        lanzaboote (Secure Boot keys in /var/lib/sbctl)
  flake             ${FLAKE_SRC:-$FLAKE_REPO}
EOF
lsblk "$DISK"

if [ "$ASSUME_YES" -ne 1 ]; then
  printf '\nThis ERASES ALL DATA on %s. Type YES to continue: ' "$DISK"
  read -r reply
  [ "$reply" = "YES" ] || die "aborted"
fi

# --- partition -----------------------------------------------------------------

log "partitioning $DISK"
swapoff -a || true
umount -R "$MNT" 2>/dev/null || true
cryptsetup close "$LUKS_NAME" 2>/dev/null || true

wipefs -af "$DISK"
sgdisk --zap-all "$DISK"
sgdisk \
  -n "1:0:+$ESP_SIZE" -t 1:ef00 -c 1:ESP \
  -n "2:0:0" -t 2:8309 -c 2:"$LUKS_NAME" \
  "$DISK"
partprobe "$DISK"
udevadm settle
[ -b "$ESP_PART" ] && [ -b "$LUKS_PART" ] || die "expected partitions $ESP_PART and $LUKS_PART"

log "creating ESP filesystem on $ESP_PART"
mkfs.vfat -F 32 -n BOOT "$ESP_PART"

# --- encrypt -------------------------------------------------------------------

log "creating LUKS2 container on $LUKS_PART (you will be asked for a passphrase)"
cryptsetup luksFormat --type luks2 --label "$LUKS_NAME" "$LUKS_PART"

log "opening LUKS container as /dev/mapper/$LUKS_NAME"
cryptsetup open "$LUKS_PART" "$LUKS_NAME"

# --- btrfs ---------------------------------------------------------------------

log "creating btrfs filesystem and subvolumes"
mkfs.btrfs -f -L nixos "/dev/mapper/$LUKS_NAME"

mkdir -p "$MNT"
mount "/dev/mapper/$LUKS_NAME" "$MNT"
btrfs subvolume create "$MNT/root"
btrfs subvolume create "$MNT/home"
btrfs subvolume create "$MNT/nix"
mkdir -p "$MNT/var"
btrfs subvolume create "$MNT/var/log"
btrfs subvolume create "$MNT/swap"
chattr +C "$MNT/swap"  # no CoW for the swapfile NixOS creates on first boot
umount "$MNT"

log "mounting target filesystems"
BTRFS_OPTS="noatime,compress=zstd"
mount -o "subvol=root,$BTRFS_OPTS" "/dev/mapper/$LUKS_NAME" "$MNT"
mkdir -p "$MNT"/{home,nix,var/log,swap,btr_pool,boot}
mount -o "subvol=home,$BTRFS_OPTS" "/dev/mapper/$LUKS_NAME" "$MNT/home"
mount -o "subvol=nix,$BTRFS_OPTS" "/dev/mapper/$LUKS_NAME" "$MNT/nix"
mount -o "subvol=var/log,$BTRFS_OPTS" "/dev/mapper/$LUKS_NAME" "$MNT/var/log"
mount -o "subvol=swap,noatime,compress=no" "/dev/mapper/$LUKS_NAME" "$MNT/swap"
mount -o "subvolid=5,$BTRFS_OPTS" "/dev/mapper/$LUKS_NAME" "$MNT/btr_pool"
mount -o "fmask=0077,dmask=0077" "$ESP_PART" "$MNT/boot"
findmnt -R "$MNT"

# --- secure boot keys ----------------------------------------------------------

# lanzaboote signs the bootloader during nixos-install, so the keys that
# boot.lanzaboote.pkiBundle points at have to exist before the install runs.
# autoGenerateKeys/autoEnrollKeys then take over on first boot.
log "creating Secure Boot keys in $MNT/var/lib/sbctl"
mkdir -p "$MNT/var/lib/sbctl"
SBCTL_CONF="$(mktemp)"
cat >"$SBCTL_CONF" <<EOF
keydir: $MNT/var/lib/sbctl/keys
guid: $MNT/var/lib/sbctl/GUID
EOF
# --disable-landlock in case the sandbox rejects the relocated keydir
sbctl --config "$SBCTL_CONF" create-keys ||
  sbctl --config "$SBCTL_CONF" --disable-landlock create-keys
rm -f "$SBCTL_CONF"

# --- flake ---------------------------------------------------------------------

FLAKE_DIR="$MNT/etc/nixos"
if [ -n "$FLAKE_SRC" ]; then
  log "copying flake from $FLAKE_SRC to $FLAKE_DIR"
  mkdir -p "$FLAKE_DIR"
  cp -a "$FLAKE_SRC/." "$FLAKE_DIR/"
else
  log "cloning $FLAKE_REPO to $FLAKE_DIR"
  mkdir -p "$(dirname "$FLAKE_DIR")"
  git clone "$FLAKE_REPO" "$FLAKE_DIR"
fi
git config --global --add safe.directory "$FLAKE_DIR"

# --- generate hardware + filesystem modules ------------------------------------

log "generating hardware and filesystem modules for $HOST"
LUKS_UUID="$(blkid -s UUID -o value "$LUKS_PART")"
ESP_UUID="$(blkid -s UUID -o value "$ESP_PART")"

GEN_DIR="$(mktemp -d)"
nixos-generate-config --root "$MNT" --no-filesystems --dir "$GEN_DIR"
install -Dm644 "$GEN_DIR/hardware-configuration.nix" \
  "$FLAKE_DIR/config/system/+nixos/hardware/+$HOST.nix"
rm -rf "$GEN_DIR"

cat >"$FLAKE_DIR/config/system/+nixos/filesystems/filesystems+$HOST.nix" <<EOF
# Generated by install.sh on $(date -I). LUKS + btrfs subvolume layout.
{ ... }:

let
  device = "/dev/mapper/$LUKS_NAME";
  btrfsOptions = [
    "noatime"
    "compress=zstd"
  ];
in
{
  boot.initrd.luks.devices."$LUKS_NAME".device = "/dev/disk/by-uuid/$LUKS_UUID";

  fileSystems = {
    "/" = {
      inherit device;
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=root" ];
    };

    "/home" = {
      inherit device;
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=home" ];
    };

    "/nix" = {
      inherit device;
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=nix" ];
    };

    "/var/log" = {
      inherit device;
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=var/log" ];
    };

    "/swap" = {
      inherit device;
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=no"
        "subvol=swap"
      ];
    };

    "/btr_pool" = {
      inherit device;
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvolid=5" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/$ESP_UUID";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = $SWAP_SIZE_GB * 1024;
    }
  ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };
}
EOF

# Nix only sees tracked/staged files inside a git tree, so stage the generated
# modules before evaluating or installing.
git -C "$FLAKE_DIR" add -A

log "checking that $HOST enables lanzaboote"
if [ "$(nix "${NIX_FLAGS[@]}" eval --json \
  "$FLAKE_DIR#nixosConfigurations.$HOST.config.boot.lanzaboote.enable" 2>/dev/null)" != "true" ]; then
  warn "boot.lanzaboote.enable is not true for $HOST; enable it in"
  warn "config/system/+nixos/bootloader/+$HOST.nix before installing, or continue"
  warn "with the plain systemd-boot setup that is configured now."
  if [ "$ASSUME_YES" -ne 1 ]; then
    printf 'Continue anyway? [y/N] '
    read -r reply
    [ "$reply" = "y" ] || die "aborted"
  fi
fi

# --- install -------------------------------------------------------------------

log "running nixos-install (this builds the whole system)"
nixos-install --root "$MNT" --flake "$FLAKE_DIR#$HOST"

log "set a password for wietse"
nixos-enter --root "$MNT" -c 'passwd wietse'

cat <<EOF

$(printf '\033[1;32mInstall complete.\033[0m')

Next steps:

1.  Commit the generated modules (they are staged in $FLAKE_DIR):
      config/system/+nixos/hardware/+$HOST.nix
      config/system/+nixos/filesystems/filesystems+$HOST.nix

2.  Put the firmware in Secure Boot Setup Mode before the first boot:
      BIOS -> Security -> Secure Boot -> enable, then "Reset to Setup Mode".
      Do NOT use "Clear All Secure Boot Keys" (it drops the dbx).

3.  Reboot. On first boot lanzaboote enrolls the keys from /var/lib/sbctl via
    systemd-boot and Secure Boot becomes active on the boot after that.
    Verify with:
      bootctl status        # Secure Boot: enabled (user)
      sbctl verify

4.  Optional: bind the LUKS volume to the TPM once Secure Boot is on:
      systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 $LUKS_PART
EOF
