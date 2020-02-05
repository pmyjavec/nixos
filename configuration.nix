# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./yubikey.nix
      ./vpn.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1024x768x32;1024x768x24;auto";

  # This is required for now to get > 5.4 so the new X1 Xtreme works.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Decrypt root FS
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/0ebaf0bc-b483-4f50-ab13-3bb0ee016b9d";
      preLVM = true;
    }
  ];

  # Automatic system upgrades
  system.autoUpgrade.enable = true;

  networking.hostName = "fuji"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "127.0.0.1" ];
  powerManagement.enable = true;

   #Select internationalisation properties.
   i18n = {
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

   # Shell Aliases
   environment.shellAliases = {
     nv = "nvim";
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
     unzip
     xclip
     binutils


     # Photography
     nomacs
     gimp
     exiftool

     # Development
     tmux
     docker
     neovim
     fzf
     gitAndTools.hub
     gitAndTools.git-ignore
     shellcheck


     # Languages
     ruby
     bundler
     python
     python3
     gcc
     gnumake
     go

     # DevOps and Operational Tooling
     ansible
     dnsutils
     awscli
     vagrant
     google-cloud-sdk
     minikube
     openvpn
     saml2aws
     update-resolv-conf
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

  # Fix intel CPU throttling.
  services.throttled.enable = true;

  # Think Fan
  services.thinkfan.enable = true;

  # NTP syncing
  services.chrony.enable = true;

  # DNS Cache
  services.dnscache = {
    enable = true;
    domainServers = {
      "@" = ["208.67.222.222" "208.67.220.220"];
    };
    forwardOnly = true;
  };

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
    libinput.accelSpeed = "0.6";

    #videoDrivers = [ "intel" "nvidia" ];
    videoDrivers = [ "nvidia" ];

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
  system.stateVersion = "19.09";

  fonts.fonts = with pkgs; [
    source-code-pro
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    powerline-fonts
    font-awesome
    (nerdfonts.override { withFont = "SourceCodePro"; })
   ];

  services.redshift = {
    enable = false;
  };

  location.provider = "geoclue2";

  nixpkgs.config.allowUnfree = true;

  programs.ssh.startAgent = false;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
