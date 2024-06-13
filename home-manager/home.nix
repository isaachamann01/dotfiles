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
     swww
     wofi
     rofi
  ];


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
	font-size: 20px;
	font-family: monospace;
}

window#waybar {
	background: #292b2e;
	color: #fdf6e3;
}

#custom-right-arrow-dark,
#custom-left-arrow-dark {
	color: #1a1a1a;
}
#custom-right-arrow-light,
#custom-left-arrow-light {
	color: #292b2e;
	background: #1a1a1a;
}

#workspaces,
#clock.1,
#clock.2,
#clock.3,
#pulseaudio,
#memory,
#cpu,
#battery,
#disk,
#tray {
	background: #1a1a1a;
}

#workspaces button {
	padding: 0 2px;
	color: #fdf6e3;
}
#workspaces button.focused {
	color: #268bd2;
}
#workspaces button:hover {
	box-shadow: inherit;
	text-shadow: inherit;
}
#workspaces button:hover {
	background: #1a1a1a;
	border: #1a1a1a;
	padding: 0 3px;
}

#pulseaudio {
	color: #268bd2;
}
#memory {
	color: #2aa198;
}
#cpu {
	color: #6c71c4;
}
#battery {
	color: #859900;
}
#disk {
	color: #b58900;
}

#clock,
#pulseaudio,
#memory,
#cpu,
#battery,
#disk {
	padding: 0 10px;
}
      '';
      settings = [{
	"layer" = "top";
	"position"= "bottom";

	"modules-left" = [
		"sway/workspaces"
		"custom/right-arrow-dark"
	];

	"modules-center"= [
		"custom/left-arrow-dark"
		"clock#1"
		"custom/left-arrow-light"
		"custom/left-arrow-dark"
		"clock#2"
		"custom/right-arrow-dark"
		"custom/right-arrow-light"
		"clock#3"
		"custom/right-arrow-dark
	];

	"modules-right"= [
		"custom/left-arrow-dark"
		"pulseaudio"
		"custom/left-arrow-light"
		"custom/left-arrow-dark"
		"memory"
		"custom/left-arrow-light"
		"custom/left-arrow-dark"
		"cpu"
		"custom/left-arrow-light"
		"custom/left-arrow-dark"
		"battery"
		"custom/left-arrow-light"
		"custom/left-arrow-dark"
		"disk"
		"custom/left-arrow-light"
		"custom/left-arrow-dark"
		"tray"
	];

	"custom/left-arrow-dark"= {
		"format"= "";
		"tooltip"= false;
	};

	"custom/left-arrow-light"= {
		"format"= "";
		"tooltip"= false;
	};

	"custom/right-arrow-dark"= {
		"format"= "";
		"tooltip"= false;
	};

	"custom/right-arrow-light"= {
		"format"= "";
		"tooltip"= false;
	};

	"sway/workspaces"= {
		"disable-scroll"= true;
		"format"= "{name}";
	};

	"clock#1"= {
		"format"= "{=%a}";
		"tooltip"= false;
	};

	"clock#2"= {
		"format"= "{=%H=%M}";
		"tooltip"= false;
	};

	"clock#3"= {
		"format"= "{=%m-%d}";
		"tooltip"= false;
	};

	"pulseaudio"= {
		"format"= "{icon} {volume=2}%"
		"format-bluetooth"= "{icon}  {volume}%"
		"format-muted"= "MUTE"
		"format-icons"= {
			"headphones"= ""
			"default"= [
				"",
				""
			]
		};

		"scroll-step"= 5
		"on-click"= "pamixer -t"
		"on-click-right"= "pavucontrol
	};

	"memory"= {
		"interval"= 5
		"format"= "Mem {}%"
	};

	"cpu"= {
		"interval"= 5,
		"format"= "CPU {usage=2}%"
	};

	"battery"= {
		"states"= {
			"good"= 95
			"warning"= 30
			"critical"= 15
		};

		"format"= "{icon} {capacity}%"
		"format-icons"= [
			"",
			"",
			"",
			"",
			""
		];
	};
	"disk"= {
		"interval"= 5
		"format"= "Disk {percentage_used=2}%"
		"path"= "/"
	};
	"tray"= {
		"icon-size"= 20
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
