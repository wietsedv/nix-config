{ config, ... }:

{
  homebrew.casks = [
    "android-studio"
  ];

  environment.variables.ANDROID_HOME = "/Users/wietse/Library/Android/sdk";
  environment.variables.JAVA_HOME = "/Applications/Android Studio.app/Contents/jbr/Contents/Home";

  environment.systemPath = [ "${config.environment.variables.ANDROID_HOME}/platform-tools" ];
}
