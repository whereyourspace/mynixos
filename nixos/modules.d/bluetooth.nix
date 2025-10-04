{ config, lib, pkgs, inputs, outputs, ... }:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (config) custom;
in
{
  imports = [
  ];

  options = {
    custom.bluetooth.enable = mkEnableOption "bluetooth support";
  };

  config = mkIf custom.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
