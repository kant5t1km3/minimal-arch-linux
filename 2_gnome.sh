#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Gnome and a few extra apps"
sudo pacman -S --noconfirm gnome gnome-tweaks gnome-usage gitg evolution gvfs-goa

echo "Enabling GDM"
sudo systemctl enable gdm.service

echo "Enabling automatic login"
sudo tee -a /etc/gdm/custom.conf << END
# Enable automatic login for user
[daemon]
AutomaticLogin=$USER
AutomaticLoginEnable=True
END

echo "Installing themes"
# Kali themes source: https://gitlab.com/kalilinux/packages/kali-themes/-/tree/kali/master/share/themes
mkdir -p ~/.themes
wget -P ~/.themes https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali-themes.tar
tar -xzf ~/.themes/kali-themes.tar -C ~/.themes
rm -f ~/.themes/kali-themes.tar

echo "Installing icon themes"
# Kali themes source: https://gitlab.com/kalilinux/packages/kali-themes/-/tree/kali/master/share/icons
mkdir -p ~/.icons
wget -P ~/.icons https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali-icons.tar
tar -xzf ~/.icons/kali-icons.tar -C ~/.icons
rm -f ~/.icons/kali-icons.tar

echo "Your setup is ready. You can reboot now!"
