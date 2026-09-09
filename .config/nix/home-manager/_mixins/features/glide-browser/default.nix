{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (inputs.firefox-addons.lib.${pkgs.stdenv.hostPlatform.system}) buildFirefoxXpiAddon;
  firefox-addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  mute-sites-by-default = (
    buildFirefoxXpiAddon {
      pname = "mute-sites-by-default";
      version = "1.11resigned1";
      addonId = "{@mute-sites-by-default}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4272832/mute_sites_by_default-1.11resigned1.xpi";
      sha256 = "sha256-VPolBV4lyW+DxBLOvh9j/q9h3jfItKZjaJFu4R+mZO0=";
      meta = with lib; {
        platforms = platforms.all;
      };
    }
  );
in
{
  programs.glide-browser = {
    enable = true;
    package = inputs.glide-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

    globalExtensions = with firefox-addons; [
      {
        package = adnauseam;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = clearurls;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = decentraleyes;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = dont-track-me-google1;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = mute-sites-by-default;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = privacy-badger;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = qwant-search;
        settings = {
          private_browsing = true;
        };
      }
      {
        package = streetpass-for-mastodon;
      }
      # {
      #   package = ublock-origin;
      #   settings = {
      #     private_browsing = true;
      #   };
      # }
    ];

    policies = {
      DisableTelemetry = true;
    };

    profiles = {
      "doomhammer" = {
        id = 0;
        name = "doomhammer";
        isDefault = true;

        containers = {

        };

        extensions = {
          packages = with firefox-addons; [ ]

          ;
        };

        settings = {
          "extensions.autoDisableScopes" = 0; # enable all extensions by default
        };
      };
    };

  };
}
