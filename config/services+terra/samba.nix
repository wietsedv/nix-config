{ ... }:

{
  networking.firewall.interfaces."lan0" = {
    allowedTCPPorts = [
      139
      445
    ];
    allowedUDPPorts = [
      137
      138
      5353
    ];
  };

  services = {
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      extraServiceFiles = {
        smb = ''
          <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
            <name replace-wildcards="yes">%h</name>
            <service>
              <type>_smb._tcp</type>
              <port>445</port>
            </service>
          </service-group>
        '';
      };
    };
    samba = {
      enable = true;
      settings = {
        global = {
          "fruit:aapl" = "yes";
          "fruit:copyfile" = "yes";
        };
        media = {
          path = "/data/media";
          writeable = true;
        };
        tmp = {
          path = "/data/tmp";
          writeable = true;
        };
        public = {
          path = "/data/public";
          writeable = true;
          public = true;
        };
      };
    };
  };
}
