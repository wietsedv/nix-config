{ lib, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    group = "media";
    forceEncodingConfig = true;

    hardwareAcceleration = {
      enable = true;
      type = "qsv";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      enableHardwareEncoding = true;
      enableIntelLowPowerEncoding = true;
      enableToneMapping = true;

      hardwareEncodingCodecs = {
        hevc = true;
      };

      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        hevc10bit = true;
        vp8 = true;
        vp9 = true;
        av1 = true;
        mpeg2 = true;
        vc1 = true;
      };
    };
  };

  systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "002";

  users.users.jellyfin.extraGroups = [
    "video"
    "render"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API (iHD) userspace
      vpl-gpu-rt # oneVPL (QSV) runtime
      intel-compute-runtime # OpenCL, required for HDR tone mapping
    ];
  };

  custom.web-apps.jellyfin.port = 8096;
}
