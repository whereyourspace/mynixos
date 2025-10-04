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
          displayManagers = mkOption {
            type = listOf (enum [ "sddm" "lightdm" "startx" ]);
            default = [ ];
            description = ''
              The display managers used.
            '';
          };
          desktopManagers = mkOption {
            type = listOf (enum [ "plasma6" ]);
            default = [ ];
            description = ''
              The desktop managers used.
            '';
          };
          windowManagers = mkOption {
            type = listOf (enum [ "i3" ]);
            default = [ ];
            description = ''
              The window managers used.
            '';
          };
        };
      });
      default = null;
      description = ''
        The desktop environment configuration.
      '';
    };
    
  };

  # TODO implement automatic selection of the necessary drivers and packages
  config = mkIf (custom.enable && custom.video.enable) {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # xorg.xf86videovmware
      ];
    };

    # TODO move GPU configuration to corresponding module
    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nixpkgs.config = {
      allowUnfree = true;
    };
    services = with custom.desktopEnvironment; mkIf (custom.desktopEnvironment != null) {
      xserver = mkIf enable {
        enable = true;
        xkb = {
          layout = "us,ru";
          options = "grp:win_space_toggle";
        };
        windowManager = {
          i3.enable = builtins.elem "i3" windowManagers;
        };
        videoDrivers = [ "nvidia" ];
        displayManager = mkIf (displayManagers != [ ]) {
          sessionCommands = "xrandr --output eDP-1-1 --auto --output HDMI-1-1 --primary --auto --right-of eDP-1-1";
          lightdm.enable = builtins.elem "lightdm" displayManagers;
          startx.enable = builtins.elem "startx" displayManagers;
        };
      };
      desktopManager = mkIf (desktopManagers != [ ]) {
        plasma6.enable = builtins.elem "plasma6" desktopManagers;
      };
      displayManager = mkIf (displayManagers != [ ]) {
        sddm.enable = builtins.elem "sddm" displayManagers;
      };
    };
    environment = with pkgs; with custom.desktopEnvironment; {
      systemPackages = mkIf (builtins.elem "plasma6" desktopManagers) [
        libsForQt5.qtstyleplugin-kvantum
      ];
      sessionVariables = mkIf enable {
        LD_LIBRARY_PATH = [
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
  };
}
