{ pkgs, ... }:

{
  home.packages = with pkgs; [
    k3d
    kubectl
    kubernetes-helm
    k9s
  ];
}
