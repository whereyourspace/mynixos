{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (config) custom;
in
{
  imports = [ ];
  options = {
    custom.hostName = mkOption {
      type = types.strMatching "[[:alnum:]\\-\\.]{1,253}";
      default = "localhost";
      description = "System hostname";
    };
  };
  config = {
    networking = {
      hostName = custom.hostName;
      networkmanager.enable = true;
    };
  };
}
