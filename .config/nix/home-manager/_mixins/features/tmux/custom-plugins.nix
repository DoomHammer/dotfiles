{ pkgs, ... }:

let
  buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in
{
  colortag = buildTmuxPlugin rec {
    pluginName = "tmux-colortag";
    version = "v1.4";
    src = fetchTarball {
      url = "https://github.com/Determinant/tmux-colortag/archive/${version}.tar.gz";
      sha256 = "19fjlzyrmha10jjcxd25a24rz1wsc5k3k6jl4y868rnc6dclxf5z";
    };
    rtpFilePath = "tmux-colortag.tmux";
  };
  man = buildTmuxPlugin {
    pluginName = "tmux-man";
    version = "v0.0.1+acfde12eb182fda4a320dfd0b3918d77d9cd6cfa";
    src = fetchTarball {
      url = "https://github.com/knakayama/tmux-man/archive/acfde12eb182fda4a320dfd0b3918d77d9cd6cfa.tar.gz";
      sha256 = "1c2dc9vwmq7n3kngrdn6hpp3si57qjl5hihp25xy6sp2bi5gyga0";
    };
    rtpFilePath = "tmux-man.tmux";
  };
  floax = buildTmuxPlugin {
    pluginName = "floax";
    version = "v0.0.1+61c7f466b9a4ceed56f99d403250164170d586cd";
    src = fetchTarball {
      url = "https://github.com/omerxx/tmux-floax/archive/61c7f466b9a4ceed56f99d403250164170d586cd.tar.gz";
      sha256 = "0dcbhci5ig2rfaaa3i5nz7v7hlnhahk07517c9wvzz10f7njgv0c";
    };
    rtpFilePath = "floax.tmux";
  };
  irrational = buildTmuxPlugin {
    pluginName = "irrational";
    version = "v0.0.1+fcd8d4e498f95b9373bccb57e7bf7094432fbf67";
    src = fetchTarball {
      url = "https://github.com/DoomHammer/tmux-irrational/archive/fcd8d4e498f95b9373bccb57e7bf7094432fbf67.tar.gz";
      sha256 = "08n03h32x5i14407j7s21bk43mr35q5mxhr6h6mg82m17y6q3fss";
    };
    rtpFilePath = "sensible.tmux";
  };
  newline-detector = buildTmuxPlugin {
    pluginName = "newline-detector";
    version = "v0.0.1+7e3a43c105f79f20ddd98c6fb4dd1bf4a177f31c";
    src = fetchTarball {
      url = "https://github.com/knakayama/tmux-newline-detector/archive/7e3a43c105f79f20ddd98c6fb4dd1bf4a177f31c.tar.gz";
      sha256 = "0xm8pzk45a7rspsh3kw0cpb9d3zcpglc6a8d664mdch9gpxgxr5b";
    };
    rtpFilePath = "newline-detector.tmux";
  };
  which-key = buildTmuxPlugin {
    pluginName = "which-key";
    version = "v0.0.1+1f419775caf136a60aac8e3a269b51ad10b51eb6";
    src = fetchTarball {
      url = "https://github.com/alexwforsythe/tmux-which-key/archive/1f419775caf136a60aac8e3a269b51ad10b51eb6.tar.gz";
      sha256 = "1h830h9rz4d5pdr3ymmjjwaxg6sh9vi3fpsn0bh10yy0gaf6xcaz";
    };
    rtpFilePath = "plugin.sh.tmux";
  };
}
