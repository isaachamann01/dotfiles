# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  # This makes vscode run on wayland at startup rather than some other buggy crap.
#  (final: prev: {
#  vscode = prev.vscode.overrideAttrs (oldAttrs: {
#    postInstall = (oldAttrs.postInstall or "") + ''
#      substituteInPlace $out/share/applications/vscode.desktop \
#        --replace "/bin/code %U" "/bin/code %U --disable-smooth-scrolling"
#    '';
#  });
#})

  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };



  home.packages = with pkgs; [
     vscode
     dolphin
     brave
     kitty
     waybar
     hyprpaper
     wofi
     rofi
     pamixer
     nerdfonts
     #python3
     spotify
     gobject-introspection
     playerctl
     #python311Packages.gi
     gtk4
     gst_all_1.gstreamer
     mysql
    (python3.withPackages (p: with p; [
      #pygobject3
      #gst-python
      tensorflow
      python-binance
      #mysql-connector
      pandas
      numpy
      datetime
    ]))
    steam
    pavucontrol
    blueman
  ];

  # PYTHON CONFIG



  home = {
    username = "isaac";
    homeDirectory = "/home/isaac";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  #----------------------------------------------------------------------------------
    #- Hyprland Config
  #----------------------------------------------------------------------------------

  # HOME STUFF
  home = {
    sessionVariables = {
    EDITOR = "lvim";
    BROWSER = "librewolf";
    TERMINAL = "kitty";
    GBM_BACKEND= "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME= "nvidia";
    LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
    __GL_VRR_ALLOWED="1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    };
  };
  
  #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    nvidiaPatches = true;
    extraConfig = ''

    # Monitor
    # monitor=DP-1,1920x1080@165,auto,1


    # Fix slow startup
    #exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    #exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 

    # Autostart

    exec-once = hyprctl setcursor Bibata-Modern-Classic 24
    exec-once = dunst
    exec-once = hyprpaper

    #source = /home/enzo/.config/hypr/colors
    exec = pkill waybar & sleep 0.5 && waybar
    # exec-once = swww init & sleep 0.5 && exec wallpaper_random
    # exec-once = wallpaper_random

    # Set en layout at startup
    
    # Input config
    input {
        kb_layout = us,fr
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        touchpad {
            natural_scroll = false
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {

        gaps_in = 5
        gaps_out = 20
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = dwindle
    }

    decoration {

        rounding = 10
        #blur = true
        #blur_size = 3
        #blur_passes = 1
        #blur_new_optimizations = true

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = yes

        bezier = ease,0.4,0.02,0.21,1

        animation = windows, 1, 3.5, ease, slide
        animation = windowsOut, 1, 3.5, ease, slide
        animation = border, 1, 6, default
        animation = fade, 1, 3, ease
        animation = workspaces, 1, 3.5, ease
    }

    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    master {
        new_is_master = yes
    }

    gestures {
        workspace_swipe = false
    }

    # Example windowrule v1
    # windowrule = float, ^(kitty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

    windowrule=float,^(kitty)$
    windowrule=float,^(pavucontrol)$
    windowrule=center,^(kitty)$
    windowrule=float,^(blueman-manager)$
    windowrule=size 600 500,^(kitty)$
    windowrule=size 934 525,^(mpv)$
    windowrule=float,^(mpv)$
    windowrule=center,^(mpv)$
    #windowrule=pin,^(firefox)$

    $mainMod = SUPER
    bind = $mainMod, G, fullscreen,

    #bind = $mainMod, RETURN, exec, cool-retro-term-zsh
    bind = $mainMod, RETURN, exec, kitty
    bind = $mainMod, B, exec, opera --no-sandbox
    bind = $mainMod, L, exec, firefox 
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, F, exec, nautilus
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, w, exec, wofi --show drun
    bind = $mainMod, R, exec, rofiWindow
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # Switch Keyboard Layouts
    #bind = $mainMod, SPACE, exec, hyprctl switchxkblayout teclado-gamer-husky-blizzard next

    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = SHIFT, Print, exec, grim -g "$(slurp)"

    # Functional keybinds
    bind =,XF86AudioMicMute,exec,pamixer --default-source -t
    bind =,XF86MonBrightnessDown,exec,light -U 20
    bind =,XF86MonBrightnessUp,exec,light -A 20
    bind =,XF86AudioMute,exec,pamixer -t
    bind =,XF86AudioLowerVolume,exec,pamixer -d 10
    bind =,XF86AudioRaiseVolume,exec,pamixer -i 10
    bind =,XF86AudioPlay,exec,playerctl play-pause
    bind =,XF86AudioPause,exec,playerctl play-pause

    # to switch between windows in a floating workspace
    bind = SUPER,Tab,cyclenext,
    bind = SUPER,Tab,bringactivetotop,

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    bindm = ALT, mouse:272, resizewindow
        '';
  };

    home.file.".config/hypr/colors".text = ''
    $background = rgba(1d192bee)
    $foreground = rgba(c3dde7ee)
    $color0 = rgba(1d192bee)
    $color1 = rgba(465EA7ee)
    $color2 = rgba(5A89B6ee)
    $color3 = rgba(6296CAee)
    $color4 = rgba(73B3D4ee)
    $color5 = rgba(7BC7DDee)
    $color6 = rgba(9CB4E3ee)
    $color7 = rgba(c3dde7ee)
    $color8 = rgba(889aa1ee)
    $color9 = rgba(465EA7ee)
    $color10 = rgba(5A89B6ee)
    $color11 = rgba(6296CAee)
    $color12 = rgba(73B3D4ee)
    $color13 = rgba(7BC7DDee)
    $color14 = rgba(9CB4E3ee)
    $color15 = rgba(c3dde7ee)
    '';

  #------------------------------------------------------------------------------------------
    # Waybar
  #------------------------------------------------------------------------------------------

   programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
* {
  /* `otf-font-awesome` is required to be installed for icons */
  font-family: "Noto Sans CJK KR Regular";
  font-size: 13px;
  min-height: 0;
}

window#waybar {
  background: transparent;
  /*    background-color: rgba(43, 48, 59, 0.5); */
  /*    border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
  color: #ffffff;
  transition-property: background-color;
  transition-duration: .5s;
}

window#waybar.hidden {
  opacity: 0.2;
}

#waybar.empty #window {
  background-color: transparent;
}

#workspaces {
}

#window {
  margin: 2;
  padding-left: 8;
  padding-right: 8;
  background-color: rgba(0,0,0,0.3);
  font-size:14px;
  font-weight: bold;
}

button {
  /* Use box-shadow instead of border so the text isn't offset */
  box-shadow: inset 0 -3px transparent;
  /* Avoid rounded borders under each button name */
  border: none;
  border-radius: 0;
}

/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
button:hover {
  background: inherit;
  border-top: 2px solid #c9545d;
}

#workspaces button {
  padding: 0 4px;
  /*    background-color: rgba(0,0,0,0.3); */
}

#workspaces button:hover {
}

#workspaces button.focused {
  /*    box-shadow: inset 0 -2px #c9545d; */
  background-color: rgba(0,0,0,0.3);
  color:#c9545d;
  border-top: 2px solid #c9545d;
}

#workspaces button.urgent {
  background-color: #eb4d4b;
}

#mode {
  background-color: #64727D;
  border-bottom: 3px solid #ffffff;
}

#bluetooth,
#bluetooth.disabled,
#bluetooth.off,
#bluetooth.on,
#bluetooth.connected,
#bluetooth.discoverable,
#bluetooth.discovering,
#bluetooth.pairable,
#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#mpd {
  margin: 2px;
  padding-left: 4px;
  padding-right: 4px;
  background-color: rgba(0,0,0,0.3);
  color: #ffffff;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
  margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
  margin-right: 0;
}

#clock {
  font-size:14px;
  font-weight: bold;
}

#battery icon {
  color: red;
}

#battery.charging, #battery.plugged {
  color: #ffffff;
  background-color: #26A65B;
}

@keyframes blink {
  to {
    background-color: #ffffff;
    color: #000000;
  }
}

#battery.warning:not(.charging) {
  background-color: #f53c3c;
  color: #ffffff;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

#battery.critical:not(.charging) {
  background-color: #f53c3c;
  color: #ffffff;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

label:focus {
  background-color: #000000;
}

#network.disconnected {
  background-color: #f53c3c;
}

#temperature.critical {
  background-color: #eb4d4b;
}

#idle_inhibitor.activated {
  background-color: #ecf0f1;
  color: #2d3436;
}

#tray > .passive {
  -gtk-icon-effect: dim;
}

#tray > .needs-attention {
  -gtk-icon-effect: highlight;
  background-color: #eb4d4b;
}

.custom-spotify {
    padding: 0 10px;
    margin: 0 4px;
    background-color: #1DB954;
    color: black;
}

'';
settings = [{
        
	  "layer" = "top"; 
    "position"= "bottom"; 
    "height"= 24; 
    "width" = 1280; 
    "spacing" = 4; 
    "modules-left" = ["bluetooth" "custom/media"];
    "modules-center" = ["hyprland/window"];
    "modules-right" = ["idle_inhibitor" "temperature" "cpu" "memory" "network" "pulseaudio" "backlight" "keyboard-state" "tray" "clock"];
    
    "bluetooth" = {
      "format" = " {status}";
      "format-connected" = " {device_alias}";
      "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
      # "format-device-preference" = [ "device1", "device2" ], // preference list deciding the displayed device
      "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
      "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
      "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
      "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
      "on-click" = "blueman";
    };

    "keyboard-state" = {
        "numlock" = true;
        "capslock" = true;
        "format" = "{name} {icon}";
        "format-icons" = {
            "locked" = "";
            "unlocked" = "";
        };
    };
    #"sway/mode" = {
    #    "format" = "<span style=\"italic\">{}</span>"
    #};
    #"sway/scratchpad" = {
    #    "format" = "{icon} {count}";
    #    "show-empty" = false;
    #    "format-icons" = ["" ""];
    #    "tooltip" = true;
    #    "tooltip-format" = "{app} = {title}";
    #};
    
    "idle_inhibitor" = {
        "format" = "{icon}";
        "format-icons" = {
            "activated" = "";
            "deactivated" = "";
        };
    };
    "tray" = {

        "spacing" = 10;
    };
    "clock" = {

        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";

        "format" = "{:L%Y-%m-%d<small>[%a]</small> <tt><small>%p</small></tt>%I:%M}";

    };
    "cpu" = {
        "format" = " {usage}%";
    };
    "memory" = {
        "format" = " {}%";
    };
    "temperature" = {
        "thermal-zone" = 2;
        "hwmon-path" = "/sys/class/hwmon/hwmon1/temp1_input";
        "critical-threshold" = 80;
        "format-critical" = "{icon} {temperatureC}°C";
        "format" = "{icon} {temperatureC}°C";
        "format-icons" = ["" "" ""];
    };

   
    "network" = {
        "format-wifi" = "{essid} ({signalStrength}%) ";
        "format-ethernet" = " {ifname}";
        "tooltip-format" = " {ifname} via {gwaddr}";
        "format-linked" = " {ifname} (No IP)";
        "format-disconnected" = "Disconnected ⚠ {ifname}";
        "format-alt" = " {ifname} = {ipaddr}/{cidr}";
    };
    "pulseaudio" = {
        "scroll-step" = 5; 
        "format" = "{icon} {volume}% {format_source}";
        "format-bluetooth" = " {icon} {volume}% {format_source}";
        "format-bluetooth-muted" = "  {icon} {format_source}";
        "format-muted" = "  {format_source}";
        "format-source" = " {volume}%";
        "format-source-muted" = "";
        "format-icons" = {
            "default" = ["" "" ""];
        };
        "on-click" = "pavucontrol";
        "on-click-right" = "foot -a pw-top pw-top";
    };
    "custom/media" = {
        "format" = "{icon} {}";
        "return-type" = "json";
        "max-length" = 40;
        "format-icons" = {
            "spotify" = "";
            "default" = "🎜";
        };
        "escape" = true;
        "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; 
    };
  
}];
};

  #---------------------------------------------------------------------------------------------------------
  #- DUNST
  #---------------------------------------------------------------------------------------------------------

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        rounded = "yes";
        origin = "top-right";
        monitor = "0";
        alignment = "left";
        vertical_alignment = "center";
        width = "400";
        height = "400";
        scale = 0;
        gap_size = 0;
        progress_bar = true;
        transparency = 0;
        text_icon_padding = 0;
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        corner_radius = 10;
        follow = "mouse";
        font = "Source Sans Pro 10";
        format = "<b>%s</b>\\n%b"; #format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\n%b"
        frame_color = "#232323";
        frame_width = 1;
        offset = "15x15";
        horizontal_padding = 10;
        icon_position = "left";
        indicate_hidden = "yes";
        min_icon_size = 0;
        max_icon_size = 64;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
        padding = 10;
        plain_text = "no";
        separator_height = 2;
        show_indicators = "yes";
        shrink = "no";
        word_wrap = "yes";
        browser = "/usr/bin/env librewolf -new-tab";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_critical = {
        background = "#d64e4e";
        foreground = "#f0e0e0";
      };
      urgency_low = {
        background = "#232323";
        foreground = "#2596be";
      };
      urgency_normal = {
        background = "#1e1e2a";
        foreground = "#2596be";
      };
    };
  };

 programs.vscode = {
  	enable = true;
	enableUpdateCheck = false;
	enableExtensionUpdateCheck = false;
	mutableExtensionsDir = false;

	userSettings = {
		"window.titleBarStyle"="custom";
	};
  };

}
