# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.jdk17
    pkgs.flutter
    pkgs.unzip
    pkgs.sudo
    pkgs.gradle_7
  ];
  # Sets environment variables in the workspace
  env = { };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # "vscodevim.vim"
      "Dart-Code.dart-code"
      "Dart-Code.flutter"
    ];
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = [
        {
          command = [ "flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555" ];
          id = "android";
          manager = "flutter";
        }
      ];
    };
  };
}
