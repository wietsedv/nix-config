{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
  ];

  services.upower.enable = true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        energy_perf_bias = "performance";
        platform_profile = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        energy_performance_preference = "balance_power";
        energy_perf_bias = "balance_power";
        platform_profile = "low-power";
        turbo = "auto";
      };
    };
  };
}
