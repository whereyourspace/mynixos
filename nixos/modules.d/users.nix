{ pkgs, config, lib, ... }:
let
  inherit (lib) mkOption types mkIf;
  inherit (config) custom;
in
{
  imports = [ ];

  options = {
    custom.defaultUser = mkOption {
      type = types.strMatching "[[:alnum:]\\-_]+";
      default = "user";
      description = ''
        A default user name.
      '';
    };
  };

  config = mkIf custom.enable {
    users.users = {
      "${custom.defaultUser}" = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [ ];
      };
    };
  };
}
