{ ... }:

{
  # karabiner-elements via nix-darwin is broken
  # fix: https://github.com/nix-darwin/nix-darwin/pull/1595
  # services.karabiner-elements = {
  #   enable = true;
  # };

  homebrew.casks = [ "karabiner-elements" ];
}
