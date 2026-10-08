Dependencies:
```mango kitty noto-fonts-emoji papirus-icons fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome```

# Install Dependencies:
```console
sudo pacman -S kitty noto-fonts-emoji papirus-icon-theme fuzzel swaylock waybar swaybg swayidle mako grim slurp wl-clipboard libnotify xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome
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

### Or:

```console
git clone https://github.com/Sobserius/slop.git
cd slop
cp -rf fuzzel kitty mako waybar sway swaylock ~/.config/
cp -f wallpaper.png ~
cd ~
sudo rm -rf ~/slop
jq '."modules-center"=[] | ."modules-right" |= map(if . == "custom/keyboard" then "sway/language" else . end) | del(."custom/layout", ."custom/keyboard") | ."sway/language"={"format":"{short}","tooltip":false}' ~/.config/waybar/config > ~/.config/waybar/config.tmp && mv ~/.config/waybar/config.tmp ~/.config/waybar/config && sed -i 's/#custom-keyboard/#language/g' ~/.config/waybar/style.css && pkill -USR2 waybar
sed -i 's/^radius = .*/radius = 0/' ~/.config/fuzzel/fuzzel.ini; sed -i 's/^border-radius=.*/border-radius=0/' ~/.config/mako/config; makoctl reload
```

# Post-installation:
```console
chmod +x ~/.config/mango/screenshot.sh
chmod +x ~/.config/waybar/scripts/keyboard-layout.sh
chmod +x ~/.config/waybar/scripts/power-menu.sh
chmod +x ~/.config/waybar/scripts/layout-menu.sh
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
```
### Or:

```console
chmod +x ~/.config/sway/scripts/screenshot.sh
chmod +x ~/.config/waybar/scripts/keyboard-layout.sh
chmod +x ~/.config/waybar/scripts/power-menu.sh
chmod +x ~/.config/waybar/scripts/layout-menu.sh
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
jq '."modules-left" |= map(if . == "ext/workspaces" then "sway/workspaces" else . end) | ."sway/workspaces" = ((."ext/workspaces" // {}) + {"disable-scroll": true, "persistent-workspaces": (reduce range(1;10) as $n ({}; . + {($n|tostring): []}))}) | del(."ext/workspaces")' ~/.config/waybar/config > ~/.config/waybar/config.tmp && mv ~/.config/waybar/config.tmp ~/.config/waybar/config && sed -i 's/#workspaces button.active/#workspaces button.focused/' ~/.config/waybar/style.css && pkill -USR2 waybar
```


> [!NOTE]
> To update, run the installation process again and relogin.

# Gallery:

March 20th:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7e64537a-7994-44ed-a775-7cf85f3d78ae" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/957a4f7f-6f0e-4ce8-97e9-c79074351ece" />

October 8th:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/fb41c073-0963-47f6-97b6-303a44f9b2ee" />

