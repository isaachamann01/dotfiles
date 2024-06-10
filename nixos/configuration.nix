# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
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
  #services.xserver = {
	#enable = true;
	#displayManager.sddm.enable = true;
	#desktopManager.gnome.enable = true;
  #videoDrivers = ["nvidia"];
  #};

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  }
 
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

 


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
