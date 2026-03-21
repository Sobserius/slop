Dependencies:
```mango kitty fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome```

# Install Dependencies:
```console
sudo pacman -S kitty fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome
```
``` console
yay -S mangowm-git
```

# Dots installation:
```console
git clone https://github.com/Sobserius/slop.git
cd slop
cp -rf fuzzel kitty mako waybar mango swaylock ~/.config/
cp -f wallpaper.png ~
cd ~
sudo rm -rf ~/slop
```

# Post-installation:
```console
chmod +x ~/.config/mango/screenshot.sh
chmod +x ~/.config/waybar/scripts/keyboard-layout.sh
chmod +x ~/.config/waybar/scripts/power-menu.sh
chmod +x ~/.config/waybar/scripts/layout-menu.sh
```
> [!NOTE]
> To update, run the installation process again and relogin.

# Gallery:

March 20th:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7e64537a-7994-44ed-a775-7cf85f3d78ae" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/957a4f7f-6f0e-4ce8-97e9-c79074351ece" />
