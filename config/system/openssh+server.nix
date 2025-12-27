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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMZ1taXgwWZU1+rAiLOHzVXyWkWLkzUZgMHxy9tMDdI wietse@terra"
    ];
  };
}
