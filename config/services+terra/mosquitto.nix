{ ... }:

{
  networking.firewall.interfaces."lan0".allowedTCPPorts = [ 1883 ];

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };
}
