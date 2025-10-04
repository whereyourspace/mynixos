{ config, pkgs, lib, username ? "user", ... }@args:
{
  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "obsidian" ];
  home = {
    stateVersion = "24.11";
    username = username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      obsidian
      neofetch
      feh
      ranger
      lxappearance
      rxvt-unicode-unwrapped
      font-awesome
      font-awesome_5
      nerd-fonts.fira-code
      appimage-run
    ];
  };
  fonts = {
    fontconfig.enable = true;
  };
  xsession.windowManager.i3 = let 
    mod = "Mod4"; 

    normal_border   = 6;
    floating_border = 4;

    browser   = "firefox";
    terminal  = "urxvt";
    open_in_term = "${terminal} -e"; 
    launcher  = "${pkgs.rofi}/bin/rofi -show drun";

    resize_mode = "Resize container";
    launch_mode = "Launch: [f]irefox [r]anger [v]im [h]elix";
    rgaps_mode  = "Change gaps";
  in 
  {
    enable  = true;
    package = pkgs.i3-gaps;
    config  = {
      fonts = {
        names = [ "FiraCode NerdFont" ];
        style = "Regular";
        size  = "14px";
      };

      #fonts = [
      #  "Fira Code NerdFont 14px"
      #];

      window = {
        titlebar        = false;
        border          = normal_border;
        hideEdgeBorders = "none";

        commands = [
          {
            command   = "border none";

            criteria = {
              class = "firefox";
            };
          }
        ];
      };

      floating = {
        modifier  = "${mod}";
        border    = floating_border;
      };

      focus = {
        wrapping      = "yes";
        followMouse   = true;
        newWindow     = "smart";
        mouseWarping  = true;
      };

      gaps = {
        inner = 5;
        outer = 5;
      };

      workspaceLayout           = "default";
      workspaceAutoBackAndForth = false;

      colors = {
        focused = let 
          back = "#15181b"; 
          text = "#74a479"; 
        in 
        {
          border      = "${back}";
          background  = "${back}";
          text        = "${text}";
          indicator   = "${back}";
          childBorder = "${back}";
        };
        focusedInactive = let
          back = "#272d31";
          text = "#afc1c4";
        in
        {
          border      = "${back}";
          background  = "${back}";
          text        = "${text}";
          indicator   = "${back}";
          childBorder = "${back}";
        };
        unfocused = let
          back = "#333a3f";
          text = "#afc1c4";
        in
        {
          border      = "${back}";
          background  = "${back}";
          text        = "${text}";
          indicator   = "${back}";
          childBorder = "${back}";
        };
      };

      keybindings = let
        mkAltMod  = mod: if mod == "Mod1" then "${mod}+Mod4" else "${mod}+Mod1";
        mod_shift = "${mod}+Shift";
        mod_alt   = mkAltMod mod;
      in
      {
        "${mod}+1"  = "workspace number 1";
        "${mod}+2"  = "workspace number 2";
        "${mod}+3"  = "workspace number 3";
        "${mod}+4"  = "workspace number 4";
        "${mod}+5"  = "workspace number 5";
        "${mod}+6"  = "workspace number 6";
        "${mod}+7"  = "workspace number 7";
        "${mod}+8"  = "workspace number 8";
        "${mod}+9"  = "workspace number 9";
        "${mod}+0"  = "workspace number 10";

        "${mod_shift}+1"  = "move container to workspace number 1";
        "${mod_shift}+2"  = "move container to workspace number 2";
        "${mod_shift}+3"  = "move container to workspace number 3";
        "${mod_shift}+4"  = "move container to workspace number 4";
        "${mod_shift}+5"  = "move container to workspace number 5";
        "${mod_shift}+6"  = "move container to workspace number 6";
        "${mod_shift}+7"  = "move container to workspace number 7";
        "${mod_shift}+8"  = "move container to workspace number 8";
        "${mod_shift}+9"  = "move container to workspace number 9";
        "${mod_shift}+0"  = "move container to workspace number 10";

        "${mod}+h"  = "focus left";
        "${mod}+l"  = "focus right";
        "${mod}+k"  = "focus up";
        "${mod}+j"  = "focus down";

        "${mod_shift}+h"  = "move left";
        "${mod_shift}+l"  = "move right";
        "${mod_shift}+k"  = "move up";
        "${mod_shift}+j"  = "move down";

        "${mod_shift}+c"  = "reload";
        "${mod_shift}+q"  = "kill";
        "${mod_shift}+r"  = "restart";
        "${mod_shift}+e"  = "exit";

        "${mod}+a"      = "focus parent";
        "${mod}+z"      = "focus child";
        "${mod}+space"  = "focus mode_toggle";

        "${mod_alt}+h"  = "split h";
        "${mod_alt}+v"  = "split v";

        "${mod}+w"  = "layout tabbed";
        "${mod}+e"  = "layout toggle split";
        "${mod}+s"  = "layout stacking";

        "${mod_shift}+Tab"  = "move scratchpad";
        "${mod}+Tab"        = "scratchpad show";

        "${mod}+f"            = "fullscreen toggle";
        "${mod_shift}+space"  = "floating toggle";

        "${mod}+b"        = "border normal ${toString floating_border}";
        "${mod_shift}+b"  = "border pixel ${toString normal_border}"; 

        "${mod}+Return" = "exec ${terminal}";
        "${mod}+d"      = "exec ${launcher}";

        "${mod}+r"  = "mode ${resize_mode}";
        "${mod}+o"  = "mode ${launch_mode}";
        "${mod}+g"  = "mode ${rgaps_mode}";
      };

      modes = {
        "${launch_mode}" = {
          "f" = "exec firefox";
          "v" = "exec ${open_in_term} vim";
          "r" = "exec ${open_in_term} ranger";
          "h" = "exec ${open_in_term} hx";

          "Escape" = "mode default";
          "Return" = "mode default";
          "c"      = "mode default";
        };

        "${resize_mode}" = let 
          size = "10px";
        in
        {
          "h" = "resize shrink width ${size}";
          "l" = "resize grow width ${size}";
          "k" = "resize shrink height ${size}";
          "j" = "resize grow height ${size}";

          "Escape"  = "mode default";
          "Return"  = "mode default";
          "c"       = "mode default"; 
        };

        "${rgaps_mode}" = let 
          size = "10";
        in
        {
          "o" = "gaps vertical current toggle 70;" + 
                "gaps horizontal current toggle 100";
          "k" = "gaps outer current plus ${size}";
          "j" = "gaps outer current minus ${size}";
          "h" = "gaps inner current plus ${size}";
          "l" = "gaps inner current minus ${size}";

          "Return"  = "mode default";
          "Escape"  = "mode default";
          "c"       = "mode default";
        };
      };

      bars = [];
    };

    extraConfig = ''
      title_align center
      force_display_urgency_hint 1000 ms
      exec --no-startup-id systemctl start --user polybar
    '';
  };

  services = {
    picom = {
      enable = true;
    };

    polybar = {
      enable = true;
      package = pkgs.polybar.override { 
        i3Support = true; 
        pulseSupport = true; 
        githubSupport = true; 
      };
      script = "polybar main &";
      config = {
        "global/wm" = {
          margin-top    = 10;
          margin-bottom = 10;
        }; 
        "bar/main" = {
          #;override-redirect = true;
          #;wm-restack = i3;
          
          monitor = "\${env:MONITOR:}";
          
          width   = "100%";
          height  = 40;
          bottom  = true;
          
          font-0  = "Font Awesome 6 Free:style=Solid:size=14;3";
          font-1  = "Font Awesome 6 Free:style=Solid:size=8;3";
          font-2  = "Font Awesome 6 Brands:style=Solid:size=14;3";
          font-3  = "FiraCode Nerd Font:style=Regular:size=12;2";
          font-4  = "DejaVu Sans:style=Regular:size=14;2";
          
          line-size   = 30;
          line-color  = "#FF0000";
          
          #;background = #333a3f;
          #;background = #CF15181b;
          background = "#15181b";
          foreground = "#afc1c4";
          dim-value = "1.0";
          
          border-top-size   = 5;
          border-left-size  = 5;
          border-right-size = 5;
          border-bottom-size  = 5;
          border-color = "#00000000";
          
          #;separator = "%{T2}»%{T-}";
          #;separator-padding = 2;
          
          #;fixed-center = true;
          
          #;radius-top    = "1.0";
          #;radius-bottom = "1.0";
          
          radius = 10;
          
          padding-left  = 2;
          padding-right = 2;
          module-margin = 3;
          
          modules-center  = "workspaces";
          modules-right   = "audio cpu memory temperature wired wireless battery date";
          
          enable-ipc = true;
        }; 
        "module/workspaces" = {
          type = "internal/i3";
          
          pin-workspaces = true;
          show-urgent = true;
          
          enable-scroll = false;
          enable-click  = false;
          
          #ws-icon-0 = "terminals-0;";
          #ws-icon-1 = "terminals-1;";
          #ws-icon-2 = "code-0;";
          #ws-icon-3 = "code-1;";
          #ws-icon-4 = "graphics-0;";
          #ws-icon-5 = "graphics-1;";
          #ws-icon-6 = "web-0;";
          #ws-icon-7 = "web-1;";
          #ws-icon-default = "";
          
          ws-icon-0 = "terminals-0;";
          ws-icon-1 = "terminals-1;";
          ws-icon-2 = "code-0;";
          ws-icon-3 = "code-1;";
          ws-icon-4 = "graphics-0;";
          ws-icon-5 = "graphics-1;";
          ws-icon-6 = "web-0;";
          ws-icon-7 = "web-1;";
          ws-icon-default = "";
          
          format = "<label-state>";
          
          #;label-focused   = "";
          label-focused = "%icon%";
          label-focused-padding = 1;
          label-focused-foreground = "#74a479";
          label-unfocused = "%icon%";
          label-unfocused-padding = 1;
          label-visible   = "%icon%";
          label-visible-padding = 1;
          label-urgent    = "%icon%";
          label-urgent-padding = 1;
        }; 
        "module/battery" = {
          type = "internal/battery";
          
          full-at = 100;
          low-at  = 5;
          
          poll-interval = 5;
          
          format-charging     = "%{T1}<animation-charging>%{T-} %{T4}<label-charging>%{T-}";
          format-discharging  = "%{T1}<ramp-capacity>%{T-} %{T4}<label-discharging>%{T-}";
          format-full         = "%{T1}<ramp-capacity>%{T-} %{T4}<label-full>%{T-}";
          format-low          = "%{T1}<ramp-capacity>%{T-} %{T4}<label-low>%{T-}";
          
          label-charging    = "%percentage%%";
          label-discharging = "%percentage%%";
          label-full        = "%percentage%%";
          label-low         = "%percentage%%";
          
          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";
          
          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-framerate = 500;
        }; 
        "module/cpu" = {
          type = "internal/cpu";
          
          interval = "0.5";
          warn-percentage = 90;
          
          format = "<label> <ramp-load>";
          format-warn = "<label-warn> <ramp-load>";
          
          label       = "";
          label-warn  = "";
          
          ramp-load-0 = "▁";
          ramp-load-1 = "▂";
          ramp-load-2 = "▃";
          ramp-load-3 = "▄";
          ramp-load-4 = "▅";
          ramp-load-5 = "▆";
          ramp-load-6 = "▇";
          ramp-load-7 = "█";
        }; 
        "module/memory" = {
          type = "internal/memory";
          
          interval = 2;
          warn-percentage = 95;
          
          format = "<label> <ramp-used>";
          format-warn = "<label-warn> <ramp-used>";
          
          label       = "";
          label-warn  = "";
          
          ramp-used-0 = "▁";
          ramp-used-1 = "▂";
          ramp-used-2 = "▃";
          ramp-used-3 = "▄";
          ramp-used-4 = "▅";
          ramp-used-5 = "▆";
          ramp-used-6 = "▇";
          ramp-used-7 = "█";
        }; 
        "module/temperature" = {
          type = "internal/temperature";
          
          interval = "0.5";
          thermal-zone = "Processor";
          
          base-temperature = 20;
          warn-temperature = 60;
          
          format = "<label> <ramp>";
          format-warn = "<label-warn> <ramp>";
          
          label = "";
          label-warn = "";
          
          ramp-0 = "▁"; 
          ramp-1 = "▂";
          ramp-2 = "▃";
          ramp-3 = "▄";
          ramp-4 = "▅";
          ramp-5 = "▆";
          ramp-6 = "▇";
          ramp-7 = "█";
        };
          
        "network-base" = {
          interval = 2;
          ping-interval = 2;
          
          format-connected = "<label-connected>";
          format-disconnected = "<label-disconnected>";
          
          label-connected = " %{T4}%ifname%%{T-}    %{T4}%downspeed%%{T-}    %{T4}%upspeed%%{T-})";
          label-disconnected = " %{T4}none%{T-}";
        };
          
        "module/wired" = {
          type = "internal/network";
          "inherit" = "network-base";
          interface-type = "wired";
        };
          
        "module/wireless" = {
          type = "internal/network";
          "inherit" = "network-base";
          interface-type = "wireless";
        };
          
        "module/audio" = {
          type = "internal/pulseaudio";
          
          interval = 5;
          
          reverse-scroll = false;
          
          format-volume = "<label-volume> <bar-volume>";
          format-muted = "<label-muted> <bar-volume>";
          
          label-volume = "";
          label-muted = "";
          bar-volume-format = "%{T4}%fill%%indicator%%empty%%{T-}";
          bar-volume-width = 10;
          
          bar-volume-fill = "━";
          bar-volume-indicator = "⊸";
          bar-volume-empty = " ";
        }; 
        "module/date" = {
          type = "internal/date";
          
          interval = "1.0";
          
          date = "%Y-%m-%d";
          time = "%H:%M";
          
          format = "<label>";
          
          label = " %{T4}%time%%{T-}";
        };
      };
    }; 
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      bashrcExtra = ''
        if [ -f ~/.bashrc.extra ]; then
          source ~/.bashrc.extra
        fi
      '';
    };
    rofi = {
      enable = true;

      extraConfig = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        modes = map mkLiteral [ "drun" ];
        show  = "drun";
      };

      font  = "FiraCode NerdFont Regular 14px";
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in 
      {
        window = {
          children = map mkLiteral [ "mainbox" ];
        };

        mainbox = {
          orientation = mkLiteral "vertical";

          children = map mkLiteral [
            "inputbar"
            "listview"
            "mode-switcher"
          ];
        };

        inputbar = {
          orientation = mkLiteral "horizontal";

          children = map mkLiteral [
            "textbox-prompt"
            "entry"
            "case-indicator"
            "num-filtered-rows"
            "num-rows"
          ];
        };

        textbox-prompt = {
          str = mkLiteral ''var(prompt, "Follow me...:")'';
        };

        entry = {
          placeholder = mkLiteral ''var(placeholder, "Type to input")'';
        };

        element = {
          orientation = mkLiteral "horizontal";

          children = map mkLiteral [
            "element-prefix"
            "element-text"
          ];
        };

        "*" = {
          border-color      = mkLiteral "#333A3F";
          background-color  = mkLiteral "#15181B";
          selected-color    = mkLiteral "#74a479";
          transparent-color = mkLiteral "rgba(0,0,0,0)";
          placeholder-color = mkLiteral "#333A3F";
          foreground-normal-color = mkLiteral "#C7CCD1";

          prompt      = "Fly";
          placeholder = "Follow me...";
        };

        window = {
          width = mkLiteral "600px";

          border        = mkLiteral "4px solid";
          border-color  = mkLiteral "@border-color";

          location  = mkLiteral "center";
          anchor    = mkLiteral "center";

          background-color = mkLiteral "@border-color";
        };

        case-indicator = {
          enabled = true;
        };

        entry = {
          text-color        = mkLiteral "@foreground-normal-color";
          placeholder-color = mkLiteral "@placeholder-color";
        };

        num-rows = {
          text-color = mkLiteral "@foreground-normal-color";
        };

        num-filtered-rows = {
          text-color = mkLiteral "@foreground-normal-color";
        };

        mode-switcher = {
          orientation = mkLiteral "horizontal";
          enabled = false;
        };

        inputbar = {
          spacing = mkLiteral "10px";
          padding = mkLiteral "32px 64px";
        };

        listview = {
          scrollbar = false;

          lines   = 5;
          columns = 2;
          fixed-columns = false;

          layout  = mkLiteral "vertical";
          flow    = mkLiteral "horizontal";

          padding = mkLiteral "16px 32px 32px";
        };

        textbox-prompt = {
          text-color = mkLiteral "@foreground-normal-color";
        };

        element = {
          margin  = mkLiteral "6px";
          spacing = mkLiteral "6px";
        };

        element-text = {
          expand = true;

          text-color = mkLiteral "@foreground-normal-color";
        };

        element-prefix = {
          expand = false;

          width   = mkLiteral "6px";
          padding = mkLiteral "6px";

          background-color = mkLiteral "transparent";
        };

        "element-prefix selected.active" = {
          border = mkLiteral "2px";

          border-color      = mkLiteral "@selected-color";
          background-color  = mkLiteral "@selected-color";
        };

        "element-prefix selected.normal" = {
          border = mkLiteral "2px";

          border-color      = mkLiteral "@selected-color";
          background-color  = mkLiteral "@selected-color";
        };

        "element-prefix selected.urgent" = {
          border = mkLiteral "2px";

          border-color      = mkLiteral "@selected-color";
          background-color  = mkLiteral "@selected-color";
        };
      };
    };
    firefox = {
      enable = true;
    };
    helix = {
      enable        = true;      
      extraPackages = with pkgs; [ xsel ]; # copy to system clipboard
    };
    vim = {
      enable = true;
      settings = {
        expandtab   = true;
        shiftwidth  = 2;
        tabstop     = 2;
        number      = true;
      };
    }; 
  };

  xresources = {
    properties = let rxvt = "URxvt"; in {
        "${rxvt}*depth"       = 32;
        "${rxvt}.background"  = "[95]#1c2023";
        "${rxvt}.foreground"  = "#c7ccd1";
        "${rxvt}.cursorColor" = "#c7ccd1";

        "${rxvt}.geometry"        = "400x400";
        "${rxvt}.internalBorder"  = 4;
        "${rxvt}.externalBorder"  = 2;
        
        "${rxvt}.font"      = "xft:FiraCode Nerd Font:size=12:style=Regular";
        "${rxvt}.boldFont"  = "xft:FiraCode Nerd Font:size=12:style=Bold";

        # black
        "${rxvt}.color0"  = "#1c2023";
        "${rxvt}.color8"  = "#747c84";

        # red
        "${rxvt}.color1"  = "#c7ae95";
        "${rxvt}.color9"  = "#c7ae95";

        # green
        "${rxvt}.color2"  = "#95c7ae";
        "${rxvt}.color10" = "#95c7ae";

        # yellow 
        "${rxvt}.color3"  = "#aec795";
        "${rxvt}.color11" = "#aec795";

        # blue
        "${rxvt}.color4"  = "#ae95c7";
        "${rxvt}.color12" = "#ae95c7";

        # magenta
        "${rxvt}.color5"  = "#c795ae";
        "${rxvt}.color13" = "#c795ae";

        # cyan
        "${rxvt}.color6"  = "#95aec7";
        "${rxvt}.color14" = "#95aec7";

        # white
        "${rxvt}.color7"  = "#c7ccd1";
        "${rxvt}.color15" = "#f3f4f5";

        "${rxvt}.scrollBar" = false;
        "${rxvt}.scrollTtyKeypress" = true;
        "${rxvt}.scrollTtyOutput" = false;
        "${rxvt}.scrollWithBuffer" = true;
    };
  };
}

