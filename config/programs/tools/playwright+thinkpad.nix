{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.playwright-test
  ];

  environment.variables = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
  };
}
