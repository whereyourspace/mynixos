{ config, lib, ...}:
let
  inherit (lib) mkForce;
in
{
  imports = [ ];
  options = { };
  config = {
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = mkForce "us";
      useXkbConfig = true; # use xkb.options in tty.
    };
  };
}
