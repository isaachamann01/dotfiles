# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "isaac";
in

{

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
        user = "greeter";
      };
    };
  };
  
  services.blueman.enable = true;

  #home-manager = {
  #  extraSpecialArgs = {inherit inputs;};
  #  users = {
  #    "isaac" = import ./home.nix;
  #  };
  #};

  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  #nixpkgs = {
    # You can add overlays here
    #overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    #];
    # Configure your nixpkgs instance
    #config = {
      # Disable if you don't want unfree packages
      #allowUnfree = true;
    #};
  #};


    nix.settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";

    };


  # SYSTEM BOOT
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # HOSTNAME AND NETWORKING
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # TIMEZONE AND LOCAL
  time.timeZone = "Australia/Adelaide";
  i18n.defaultLocale = "en_US.UTF-8";

  # XSERVER  
  services.xserver = {
	#enable = true;
	#displayManager.sddm.enable = true;
	#desktopManager.gnome.enable = true;
  videoDrivers = ["nvidia"];
  };

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };
 
  # OPENGL
  hardware.opengl = {
 	enable = true;
	driSupport = true;
	driSupport32Bit = true;
  };

  # NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };  

  # SOUND
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # USERS - Just Isaac for now.
   users.users.isaac = {
     isNormalUser = true;
     initialPassword = "Awesomenes02!";
     extraGroups = [ "wheel" "seat" "input" ]; # Enable ‘sudo’ for the user.
   };


  # PACKAGES
	nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
     vim
     git
     waybar
     xwayland
     hyprland
     xdg-desktop-portal-gtk
     xdg-desktop-portal-hyprland
     mako
     meson
     wayland-protocols
     wayland-utils
     wl-clipboard
     wlroots
     kitty
   ];

  # WAYBAR FIX
  nixpkgs.overlays = [
    (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
    })
 ];

 environment.variables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  EDITOR = "lvim";
  BROWSER = "librewolf";
  TERMINAL = "kitty";
  GBM_BACKEND= "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME= "nvidia";
  LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
  __GL_VRR_ALLOWED="1";
  WLR_RENDERER_ALLOW_SOFTWARE = "1";
  CLUTTER_BACKEND = "wayland";
  WLR_RENDERER = "vulkan";
  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  ELECTRON_OZONE_PLATFORM_HINT = "auto";
  NIXOS_OZONE_WL="1";
 };

 

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
