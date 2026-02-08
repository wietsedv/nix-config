{ config, ... }:

{
  homebrew.casks = [
    "android-studio"
    "temurin@17"
  ];

  environment.variables.ANDROID_HOME = "/Users/wietse/Library/Android/sdk";

  environment.systemPath = [ "${config.environment.variables.ANDROID_HOME}/platform-tools" ];
}
