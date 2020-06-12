#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing sway"
sudo pacman -S --noconfirm sway swaylock swayidle waybar rofi light pulseaudio pavucontrol slurp grim

echo "Ricing sway"
mkdir -p ~/.config/sway
wget -P ~/.config/sway/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/sway/config

echo "Ricing waybar"
mkdir -p ~/.config/waybar
wget -P ~/.config/waybar/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/waybar/config

echo "Ricing rofi"
mkdir -p ~/.config/rofi/config
wget -P ~/.config/rofi/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/rofi/base16-one-light.config
wget -P ~/.config/rofi/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/rofi/base16-one-light.rasi
wget -P ~/.config/rofi/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/rofi/base16-onedark.config
wget -P ~/.config/rofi/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/rofi/base16-onedark.rasi

echo "Enabling sway autostart"
touch ~/.bash_profile
tee -a ~/.bash_profile << EOF
# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi
EOF

echo "Ricing vim"
mkdir -p ~/.config/nvim/
wget -P ~/.config/nvim/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/vim/init.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c 'PluginInstall' -c 'qa!'

echo "Installing and ricing Alacritty terminal"
sudo pacman -S --noconfirm alacritty
mkdir -p ~/.config/alacritty/
wget -P ~/.config/alacritty/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/alacritty/alacritty.yml

echo "Installing thunar with auto-mount and archives creation/deflation support"
sudo pacman -S --noconfirm thunar gvfs thunar-volman thunar-archive-plugin ark file-roller xarchiver

echo "Installing PDF viewer"
sudo pacman -s --noconfirm xreader

echo "Installing Thunderbird Flatpak with Wayland support"
flatpak --user --assumeyes install flathub org.mozilla.Thunderbird
flatpak override --user --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.Thunderbird

echo "Downloading themes (Kali Linux theme without the dragon)"
# Kali themes source: https://gitlab.com/kalilinux/packages/kali-themes/-/tree/kali/master/share/themes
mkdir -p ~/.themes
wget -P ~/.themes https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali-themes.tar.gz
tar -xzf ~/.themes/kali-themes.tar.gz -C ~/.themes
rm -f ~/.themes/kali-themes.tar.gz

echo "Downloading icon themes (Kali Linux icons)"
# Kali themes source: https://gitlab.com/kalilinux/packages/kali-themes/-/tree/kali/master/share/icons
mkdir -p ~/.icons
wget -P ~/.icons https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/icons/kali-icons.tar.xz
tar -xzf ~/.icons/kali-icons.tar.xz -C ~/.icons
rm -f ~/.icons/kali-icons.tar.xz

echo "Setting GTK theme, font and icons"
FONT="Fira Code Regular 10"
GTK_THEME="Kali-Light"
GTK_ICON_THEME="Flat-Remix-Blue-Dark"
GTK_SCHEMA="org.gnome.desktop.interface"
gsettings set $GTK_SCHEMA gtk-theme "$GTK_THEME"
gsettings set $GTK_SCHEMA icon-theme "$GTK_ICON_THEME"
gsettings set $GTK_SCHEMA font-name "$FONT"
gsettings set $GTK_SCHEMA document-font-name "$FONT"

echo "Enabling suspend and hibernate hotkeys"
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/g' /etc/systemd/logind.conf

echo "Blacklisting bluetooth"
sudo touch /etc/modprobe.d/nobt.conf
sudo tee -a /etc/modprobe.d/nobt.conf << END
blacklist btusb
blacklist bluetooth
END
sudo mkinitcpio -p linux-lts
sudo mkinitcpio -p linux

echo "Enabling autologin"
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo touch /etc/systemd/system/getty@tty1.service.d/override.conf
sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf << END
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin $USER --noclear %I $TERM
END

echo "Removing last login message"
touch ~/.hushlogin

echo "Installing xwayland"
sudo pacman -S --noconfirm xorg-server-xwayland