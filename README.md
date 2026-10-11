# slop

Sway/MangoWM dotfiles in two flavours: **dark** (Catppuccin Mocha) and **light**
(Catppuccin Latte). One command flips between them, in the bar or on the
keyboard.

```
$ switch-theme light
slop theme -> light  (Latte (light))
  wallpaper: /home/sob/lallpaper.png
```

## Layout

```
dark/     light/     everything that differs between the two themes
  theme.env            wallpaper name, icon theme, colour scheme
  wallpaper.png        dark mode wallpaper   -> ~/wallpaper.png
  lallpaper.png        light mode wallpaper  -> ~/lallpaper.png
  fuzzel/fuzzel.ini
  kitty/theme.conf     the colours kitty.conf includes
  mako/config
  sway/theme.conf      client colours + wallpaper, sway config includes this
  swaylock/config
  waybar/style.css
shared/               the same on both themes
  kitty/kitty.conf     include theme.conf at the end
  sway/config          include theme.conf near the top
  waybar/config        the modules, including the DRK/LHT button
  */scripts/          executable helpers
scripts/
  switch-theme.sh      the switcher
  upload.sh            commit + push to GitHub
mango/                MangoWM config (not theme aware)
```

`~/.config` holds **symlinks** into this repo, so editing a file here changes
your desktop on reload - there is no copy step and no install step.

## Install

```sh
sudo pacman -S kitty noto-fonts-emoji papirus-icon-theme fuzzel swaylock \
                waybar swaybg swayidle mako grim slurp wl-clipboard libnotify \
                xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome jq
# MangoWM only:  yay -S mangowm-git

git clone https://github.com/Sobserius/slop.git ~/slop
~/slop/scripts/switch-theme.sh dark      # wires everything up, backs up the old files
relogin                                     # so sway picks up the new config
```

The first run moves whatever was already in `~/.config` aside as
`<name>.slop-backup` - nothing is deleted, delete those once you are happy.

## Themes

```sh
switch-theme            # toggle
switch-theme light      # Latte
switch-theme dark       # Mocha
switch-theme status     # what is active, and what the bar button will switch to
```

The bar button sits at the far right, after `PWR`. It reads `THEME` and
toggles. `$mod+Shift+t` does the same thing from the keyboard.

Switching changes waybar, swaylock, mako, fuzzel, kitty, the sway client
colours, the wallpaper and the GTK icon/colour-scheme settings, then reloads
what is running. Anything that only reads its config at startup (fuzzel,
swaylock) picks it up next time you open it.

If a switch ever needs undoing, `SLOP_REPO` points the script at a different
checkout and the previous files are still sitting in `~/.config` as
`*.slop-backup`.

## Upload

```sh
./scripts/upload.sh              # stage, commit, push
./scripts/upload.sh "new wallpaper"   # with a message
./scripts/upload.sh --dry-run    # show what would happen
```

It sets your git identity once if you have none, refuses to push if the remote
moved ahead of you, and on the very first push explains how to authenticate -
over HTTPS with a personal access token, or over SSH with a new key.

## MangoWM

`mango/` is kept as it was; it is not theme aware, so switching only affects the
sway setup. On MangoWM the switcher still swaps the wallpaper and the GTK icon
theme.