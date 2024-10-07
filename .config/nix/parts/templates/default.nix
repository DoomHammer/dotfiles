{
  flake = {
    # Usage: nix flake new -t github:doomhammer/dotfiles .
    # Usage: nix flake new -t 'github:doomhammer/dotfiles#terraform-gcp' .
    templates = {
      c = {
        path = ./templates/c;
        description = "A basic C/C++ configuration";
      };
      hugo = {
        path = ./templates/hugo;
        description = "A basic Hugo configuration";
      };
      platformio-rp2040 = {
        path = ./templates/platformio-rp2040;
        description = "A basic Platform.io configuration for RP2040";
      };
      platformio-esp32 = {
        path = ./templates/platformio-esp32;
        description = "A basic Platform.io configuration for ESP32";
      };
      simple = {
        path = ./templates/simple;
        description = "";
      };
      terraform-aws = {
        path = ./templates/terraform-aws;
        description = "A basic Terraform with AWS configuration";
      };
      terraform-gcp = {
        path = ./templates/terraform-gcp;
        description = "A basic Terraform with GCP configuration";
      };
    };
    defaultTemplate = self.templates.simple;
  };

}
