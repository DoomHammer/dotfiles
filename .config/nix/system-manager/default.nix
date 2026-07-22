{
  inputs,
  ...
}:
{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

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
  };
}
