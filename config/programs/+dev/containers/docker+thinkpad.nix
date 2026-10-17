{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ docker-compose ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.extraGroups.docker.members = [ "wietse" ];
}
