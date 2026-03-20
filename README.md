Dependencies:
```mango kitty fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome```

# Install Dependencies:
```console
sudo pacman -S kitty fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome
```

# Dots installation:
```console
git clone https://github.com/Sobserius/slop.git

cd slop

cp -r fuzzel kitty mako waybar mango swaylock ~/.config/
cp -r wallpaper.png ~/

cd
sudo rm -rf ~/slop
```

# Post-installation:
```console
chmod +x ~/.config/mango/screenshot.sh
chmod +x ~/.config/waybar/scripts/keyboard-layout.sh
```
> [!NOTE]
> To update, run the installation process again and relogin.


