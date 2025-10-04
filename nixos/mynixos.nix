{ 
  pkgs, config, lib, inputs, outputs, 
  hostname ? "localhost", 
  username ? "user", 
  ... }@args:
{
  imports = [
    ./modules.d/custom.nix
  ];
  # Define the option values of the custom modules

  # Enable the custom modules
  custom.enable = true;

  # Setup hostname
  custom.hostName = hostname;

  # Define a default user account. Don't forget to set a password with ‘passwd’.
  custom.defaultUser = username;

  # Enable sound support to the system
  custom.audio.enable = true;

  # Enable video and desktop environment support to the system
  custom.video.enable = true;
  custom.desktopEnvironment = {
    enable = true;
    displayManagers = [ "sddm" ];
    windowManagers = [ "i3" ];
    desktopManagers = [ "plasma6" ];
  };

  # Enable steam installation
  custom.steam.enable = true;

  # Enable bluetooth
  custom.bluetooth.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    man
    man-pages
    nano
    inputs.home-manager.packages.${pkgs.system}.default
  ];
}
