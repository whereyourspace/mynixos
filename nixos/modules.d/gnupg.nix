
{ config, lib, pkgs, inputs, outputs, ... }:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (config) custom;
in
{
  imports = [
  ];

  options = {
    custom.gnupg.enable = mkEnableOption "GnuPG tools installation";
  };

  config = mkIf custom.gnupg.enable {
    programs.gnupg = {
      package = pkgs.gnupg;
      agent.enable = true;
      agent.enableSSHSupport = true;
    };
  };
}
