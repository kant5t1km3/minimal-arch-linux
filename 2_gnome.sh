#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Gnome and a few extra apps"
sudo pacman -S --noconfirm gnome gnome-tweaks gnome-usage gitg evolution gvfs-goa dconf-editor

echo "Enabling GDM"
sudo systemctl enable gdm.service

echo "Enabling automatic login"
sudo tee -a /etc/gdm/custom.conf << END
# Enable automatic login for user
[daemon]
AutomaticLogin=$USER
AutomaticLoginEnable=True
END

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

echo "Setting themes"
gsettings set org.gnome.desktop.interface gtk-theme Kali-Light
gsettings set org.gnome.desktop.interface icon-theme Flat-Remix-Blue-Dark

echo "Setting misc configurations"
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.calendar show-weekdate true

echo "Your setup is ready. You can reboot now!"
