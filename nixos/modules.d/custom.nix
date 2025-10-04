# this is a root file used to simple include all necessary files
{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./users.nix
    ./sound.nix
    ./video.nix
    ./console.nix
    ./network.nix
    ./bluetooth.nix
    ./steam.nix
  ];

  options = {
    custom.enable = mkEnableOption "custom settings";
  };

  config = {
  };
}
