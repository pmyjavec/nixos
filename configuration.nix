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

  nixpkgs.config.allowUnfree = true;

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
     nv  = "nvim";
     vim = "nvim";
     vi  = "nvim";
   };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";
  #time.timeZone = "America/Los_Angeles";

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
     lm_sensors
     gnome3.adwaita-icon-theme # Without this, the cursor size was tiny and had no themses in i3


     # Games
     steam

     # Photography
     nomacs
     gimp
     exiftool

     # Development
     tmux
     tmuxPlugins.tmux-colors-solarized
     docker
     neovim
     fzf
     silver-searcher
     gitAndTools.hub
     gitAndTools.git-ignore
     shellcheck
     jq
     direnv
     circleci-cli


     # Languages
     ruby
     bundler
     python3
     pipenv
     gcc
     gnumake
     go

     # Python tooling
     python37Packages.black
     python37Packages.pylint

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
     postman
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

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git fzf aws vi-mode z" ];
    ohMyZsh.theme = "spaceship";
    ohMyZsh.customPkgs = [pkgs.spaceship-prompt pkgs.zsh-powerlevel9k];
    syntaxHighlighting.enable = true;
  };

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

  hardware.bluetooth.enable = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  # Update firmwarre
  services.fwupd.enable = true;

  services.logind.extraConfig =  ''
    RuntimeDirectorySize=40%
  '';

  # X Server Configuration. There is a bit of trickery in here to get HiDPI
  # working with i3. Thi stuff can be removed after moving to a more modern WM.
  environment.variables.XCURSOR_SIZE = "32"; # Trying to get a decent mouse size.
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      naturalScrolling = true;
      disableWhileTyping = true;
      accelSpeed = "0.6";
    };

    #videoDrivers = [ "intel" "nvidia" ];
    videoDrivers = [ "nvidia" ];

    xkbOptions = "caps:ctrl_modifier, terminate:ctrl_alt_bksp"; #, altwin:ctrl_win";`

    # Makes things look nicer on a HiDPI screen.
    dpi=180;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    # Fixes small cursor when logging in.
    displayManager = {
      lightdm.greeters.gtk.cursorTheme.size = 30;

      sessionCommands = ''
        if test -e $HOME/.Xresources; then
          ${pkgs.xorg.xrdb}/bin/xrdb -merge $HOME/.Xresources &disown
        fi
      '';
    };

    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3lock #default i3 screen locker
          i3status-rust
          feh
          scrot
       ];
      };
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
    font-awesome_4
    (nerdfonts.override { withFont = "SourceCodePro"; })
   ];

  services.redshift = {
    enable = false;
  };

  location.provider = "geoclue2";

  programs.ssh.startAgent = false;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
