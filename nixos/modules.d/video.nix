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
                  type = enum [ "sddm" "lightdm" ];                 
                  description = "Display manager to use";
                  default = "lightdm";
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
                  type = enum [ "i3" ];
                  description = ''
                    The window manager to use
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
    assertions = with custom.desktopEnvironment; [
      {
        #assertion = (windowManager != null) && (desktopManager != null);
        assertion = (windowManager != null) || (desktopManager != null);
        message = "Specify one of custom.desktopEnvironment.windowManager or custom.desktopEnvironment.desktopManager";
      }
    ];
    hardware.graphics = mkIf custom.video.enable {
      enable = true;
      extraPackages = with pkgs; [
        xorg.xf86videovmware
      ];
    };
    services = mkIf custom.video.enable {
      xserver = {
        enable = true;
        windowManager.i3.enable = (custom.desktopEnvironment.windowManager.use == "i3");
        videoDrivers = [ "vmware" ];
        displayManager = mkIf (custom.desktopEnvironment.displayManager != null) {
          lightdm.enable = custom.desktopEnvironment.displayManager.use == "lightdm";
        };
      };
      displayManager =
      let
        sessionPrefix = "none";
        sessionSuffix = if custom.desktopEnvironment.windowManager != null then custom.desktopEnvironment.windowManager.use else custom.desktopEnvironment.desktopManager.use;
      in
        {
          sddm.enable = if custom.desktopEnvironment.displayManager != null then custom.desktopEnvironment.displayManager.use == "sddm" else false;
          defaultSession = "${sessionPrefix}+${sessionSuffix}";
        };
    };
    environment.sessionVariables = rec {
      LD_LIBRARY_PATH = with pkgs; [
        (
          lib.makeLibraryPath [
            libxkbcommon
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
          ]
        )
      ];
    };
  };
}
