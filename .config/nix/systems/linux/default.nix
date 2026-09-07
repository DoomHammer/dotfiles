{
  inputs,
  pkgs,
  username,
  hostname,
  ...
}:
{
  imports = [
    inputs.nix-apt.systemManagerModules.default
    inputs.doomhammer-nur.nixosModules.default

    ./${hostname}
  ];
  config = {
    nixpkgs = {
      hostPlatform = "x86_64-linux";
    };

    nix = {
      enable = true;

      settings = {

        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [ "@adm" ];

        substituters = [ "https://cache.numtide.com" ];
        trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
        nix-path = "nixpkgs=flake:nixpkgs";
      };

      channel.enable = false;

      registry = {
        nixpkgs = {
          flake = inputs.nixpkgs;
        };
      };
    };

    environment.etc = {
      # Workaround for https://github.com/numtide/system-manager/issues/543
      zprofile = {
        text = ''
          if [ -e '/etc/profile' ]; then
              . '/etc/profile'
          fi
        '';
      };
    };

    services.nix-apt = {
      enable = true;
      aptPackages = [
        "git"
        "curl"
        "openssh-server"
      ];
    };

    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };

  };
}
