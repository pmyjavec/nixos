# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }: 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./yubikey.nix
    ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Decrypt root FS
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  boot.kernelModules = [ "kvm-intel" ];

  # Automatic system upgrades
  system.autoUpgrade.enable = true; 

  networking.hostName = "xps-13"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  powerManagement.enable = true;
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #

   #Select internationalisation properties.
   i18n = {
     consoleFont = "sun12x22";
     consoleKeyMap = "us";
     defaultLocale = "en_AU.UTF-8";
   };

   users.extraUsers.pmyjavec = {
   	createHome = true;
	extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "docker"];
	group = "users";
	home = "/home/pmyjavec";
	isNormalUser = true;
	uid = 1000;
	shell = pkgs.zsh;
   };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     curl
     pamixer
     playerctl
     openssl
     wget 
     firefox
     nmap
     git
     htop
     which
     kitty
     zsh
     tdesktop
     spotify
     slack
     pavucontrol
     bc 
     ipcalc
     pciutils
     update-resolv-conf
     zip
     gnupg
     zoom-us


     # Development
     tmux
     docker
     (import (fetchTarball "channel:nixos-unstable") {}).neovim
     (import (fetchTarball "channel:nixos-unstable") {}).terraform
     
     # Languages
     ruby
     python
     python3
     gcc
     gnumake

     # DevOps and Operational Tooling
     #terraform
     ansible
     dnsutils
     awscli
     vagrant
     google-cloud-sdk
     minikube 
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  programs.gnupg.agent = { 
	enable = true; 
	enableSSHSupport = true; 
	};

  # List services that you want to enable:

  services.keybase.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true; 
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  # NTP syncing
  services.chrony.enable = true;


  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;

  hardware.pulseaudio = {
    enable = true;
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  # Update firmwarre
  services.fwupd.enable = true;

  # Enable touchpad support.
  services.xserver = {
    enable = true;

    libinput.enable = true;
    libinput.naturalScrolling = true;  
    libinput.disableWhileTyping = true;

    displayManager.sddm.enable = false;
    xkbOptions = "caps:ctrl_modifier, terminate:ctrl_alt_bksp"; #, altwin:ctrl_win";`

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; 

  fonts.fonts = with pkgs; [
    source-code-pro
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
   ];

  services.redshift = {
    enable = false;
    provider = "geoclue2";
  }; 

  nixpkgs.config.allowUnfree = true;

  programs.ssh.startAgent = false;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
