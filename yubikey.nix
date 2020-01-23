{ config, pkgs, lib, ... }:

{
  hardware.u2f.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.pcscd.enable = true;


  environment.systemPackages = (with pkgs; [
    yubico-piv-tool
    yubikey-personalization
    yubioath-desktop
    yubikey-personalization-gui
    yubikey-manager
    pass
  ]);

  security.pam.u2f.enable = true;
}
