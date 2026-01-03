{ ... }:

{
  environment.enableAllTerminfo = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.wietse = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhes3Z5KWSyQHeIEaD2AflsGJUpVz2V+oYxnUUhUX4B wietse@macbook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID24ZEx0xymC8s74V+nvlnx+MotMC1GV0wKajtxGA5Wt wietse@thinkpad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMZ1taXgwWZU1+rAiLOHzVXyWkWLkzUZgMHxy9tMDdI wietse@terra"
    ];
  };

  programs.ssh.knownHosts = {
    "github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };
}
