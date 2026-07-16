{ ... }:

{
  users.users.ci = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMrPHSQ4iIuVM9+/CaINd0U6rbJlzezGaVhOmZYH50Y ci@github-actions"
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
