{ ... }:

{
  users.users.ci = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILOlNqKQeELW25vzw/64496jsxvuNMm2hTl/DJ6kSDxp ci@github-actions"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "ci" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
