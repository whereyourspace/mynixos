{ pkgs, config, lib, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf types;
  inherit (config) custom;
in
{
  imports = [    
  ];

  options = {
    custom.video.enable = mkEnableOption "video support";
    custom.desktopEnvironment = with types; mkOption {
      type = nullOr (submodule {
        options = {
          enable = mkEnableOption "desktop environment";
          displayManager = mkOption {
            type = nullOr (submodule {
              options = {
                use = mkOption {
                  type = enum [ ];                 
                  description = "Display manager to use";
                };
                theme = mkOption {
                  type = enum [ ];
                  description = "Display manager theme to use";
                };
              };
            });
            default = null;
            description = ''
              The display manager selection.
            '';
          };
          desktopManager = mkOption {
            type = nullOr (submodule {
              options = {
                use = mkOption {
                  type = enum [ ];
                  description = ''
                    The desktop manager to use
                  '';
                };
                theme = mkOption {
                  type = enum [ ];
                  description = ''
                    Desktop manager theme to use
                  '';
                };
              };
            });
            default = null;
            description = ''
              The desktop manager selection.
            '';
          };
          windowManager = mkOption {
            type = nullOr (submodule {
              options = {
                use = mkOption {
                  type = enum [ ];
                  description = ''
                    The window manager to use
                  '';
                };
                theme = mkOption {
                  type = enum [ ];
                  description = ''
                    Window manager theme to use
                  '';
                };
              };
            });
            default = null;
            description = ''
              The window manager selection.
            '';
          };
        };
      });
    };
    
  };

  # TODO implement automatic selection of the necessary drivers and packages
  config = mkIf (custom.enable && custom.desktopEnvironment.enable) {
    hardware.graphics = mkIf custom.video.enable {
      enable = true;
      extraPackages = with pkgs; [
        xorg.xf86videovmware
      ];
    };
    services.xserver.videoDrivers = mkIf custom.video.enable [ "vmware" ];
  };
}
