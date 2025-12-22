{ ... }:

{
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  # };
  # environment.systemPackages = with pkgs; [ podman-compose ];

  # virtualisation.docker = {
  #   enable = true;
  #   storageDriver = "btrfs";
  #   # rootless = {
  #   #   enable = true;
  #   #   setSocketVariable = true;
  #   # };
  # };
  # users.extraGroups.docker.members = [ "wietse" ];
}
