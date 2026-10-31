{ ... }:

{
  networking.firewall.interfaces."lan0".allowedTCPPorts = [ 445 ];
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 445 ];

  services.samba = {
    enable = true;
    nmbd.enable = false;
    settings = {
      global = {
        "server min protocol" = "SMB3";
        "server smb encrypt" = "required";
        "security" = "user";
        "map to guest" = "never";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };
      wietse = {
        path = "/home/wietse";
        "valid users" = "wietse";
        "read only" = "no";
        browseable = "yes";
        "veto files" = "/.ssh/.gnupg/";
      };
    };
  };
}
