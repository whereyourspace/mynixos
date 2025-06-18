{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config) custom;
in
{
  imports = [ ];

  options = {
    custom.audio.enable = mkEnableOption "audio support";
  };

  config = mkIf custom.enable {
    services.pipewire = mkIf custom.audio.enable {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      audio.enable = true;
      wireplumber.enable = true;
    };
  };
}
