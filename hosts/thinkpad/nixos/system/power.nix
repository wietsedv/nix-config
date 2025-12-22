{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    # powertop.enable = true;
  };

  # services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  # services.auto-cpufreq = {
  #   enable = true;
  #   settings = {
  #     charger = {
  #        governor = "performance";
  #        energy_performance_preference = "performance";
  #        energy_perf_bias = "performance";
  #        platform_profile = "performance";
  #        # scaling_min_freq = ;
  #        # scaling_max_freq = ;
  #        turbo = "auto";
  #     };
  #     battery = {
  #        governor = "powersave";
  #        energy_performance_preference = "power";
  #        energy_perf_bias = "power";
  #        platform_profile = "low-power";
  #        # scaling_min_freq = ;
  #        # scaling_max_freq = ;
  #        turbo = "auto";
  #     };
  #   };
  # };

  # services.thinkfan = {
  #   enable = true;
  # };
}
