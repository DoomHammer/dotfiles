Some of my dotfiles for your further amusement.

If you want them nicely managed just `yadm clone` them.
[yadm](https://github.com/TheLocehiliosan/yadm) is a dotfile manager I endorse.

Here's a quick set of commands you can run to get it ready on a fresh machine
(as long as you have Git).

```shell
mkdir -p ~/.local/bin
curl -fLo ~/.local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm
chmod a+x ~/.local/bin/yadm
~/.local/bin/yadm clone https://github.com/DoomHammer/dotfiles.git
~/.local/bin/yadm restore --staged $HOME
~/.local/bin/yadm checkout -- $HOME
~/.local/bin/yadm bootstrap
rm -rf ~/.local/bin/yadm
```
