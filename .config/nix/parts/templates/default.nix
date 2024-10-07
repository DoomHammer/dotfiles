{
  flake = rec {
    # Usage: nix flake new -t github:doomhammer/dotfiles .
    # Usage: nix flake new -t 'github:doomhammer/dotfiles#terraform-gcp' .
    templates = {
      # c = {
      #   path = ./c;
      #   description = "A basic C/C++ configuration";
      # };
      hugo = {
        path = ./hugo;
        description = "A basic Hugo configuration";
      };
      # platformio-rp2040 = {
      #   path = ./platformio-rp2040;
      #   description = "A basic Platform.io configuration for RP2040";
      # };
      platformio-esp32 = {
        path = ./platformio-esp32;
        description = "A basic Platform.io configuration for ESP32";
      };
      simple = {
        path = ./simple;
        description = "";
      };
      # terraform-aws = {
      #   path = ./terraform-aws;
      #   description = "A basic Terraform with AWS configuration";
      # };
      # terraform-gcp = {
      #   path = ./terraform-gcp;
      #   description = "A basic Terraform with GCP configuration";
      # };
    };
    defaultTemplate = templates.simple;
  };

}
