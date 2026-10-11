Dependencies: `mango kitty noto-fonts-emoji papirus-icons fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome jq`

# Install Dependencies:
```console
sudo pacman -S kitty noto-fonts-emoji papirus-icon-theme fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome jq
```
```console
yay -S mangowm-git
```

# Dots installation:
```console
cd ~
git clone https://github.com/Sobserius/slop.git
cd slop
./scripts/switch-theme.sh dark
```

then log out and back in, sway needs to read the new config.

`~/.config` becomes symlinks into the repo, so edit the repo and it edits your
desktop. whatever was in `~/.config` first gets moved to `<name>.slop-backup`.

# Themes:
`dark` is mocha, `light` is latte.
```console
switch-theme dark
switch-theme light
switch-theme toggle
switch-theme status
```

the bar button `THEME` sits right of `PWR`, and `$mod+Shift+t` toggles too.

waybar, swaylock, mako, fuzzel, kitty, sway borders, wallpaper and gsettings all
follow. fuzzel and swaylock pick it up the next time they open.

wallpapers are `dark/wallpaper.png` and `light/lallpaper.png`, they end up as
`~/wallpaper.png` and `~/lallpaper.png`.

# Upload:
```console
./scripts/upload.sh
```
```console
./scripts/upload.sh "message here"
```

> [!NOTE]
> To update, run `./scripts/upload.sh` and log out and back in.

# Gallery:

March 20th:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7e64537a-7994-44ed-a775-7cf85f3d78ae" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/957a4f7f-6f0e-4ce8-97e9-c79074351ece" />

October 8th:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/fb41c073-0963-47f6-97b6-303a44f9b2ee" />