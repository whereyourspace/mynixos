{ config, lib, pkgs, inputs, outputs, ... }:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (config) custom;
in
{
  imports = [
  ];

  options = {
    custom.steam.enable = mkEnableOption "enable Steam installation";
  };

  config = mkIf custom.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
