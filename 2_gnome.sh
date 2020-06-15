#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Gnome and a few extra apps"
sudo pacman -S --noconfirm gnome gnome-tweaks gnome-usage gitg evolution gvfs-goa dconf-editor

# echo "Enabling Arch repositories in Gnome Software"
# sudo pacman -S --noconfirm gnome-software-packagekit-plugin

echo "Enabling GDM"
sudo systemctl enable gdm.service

echo "Enabling automatic login"
sudo tee -a /etc/gdm/custom.conf << EOF
# Enable automatic login for user
[daemon]
AutomaticLogin=$USER
AutomaticLoginEnable=True
EOF

echo "Downloading themes (Kali Linux theme without the dragon)"
# Kali themes source: https://gitlab.com/kalilinux/packages/kali-themes/-/tree/kali/master/share/themes
mkdir -p ~/.themes
wget -P ~/.themes https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali-themes.tar.gz
tar -xzf ~/.themes/kali-themes.tar.gz -C ~/.themes
rm -f ~/.themes/kali-themes.tar.gz

echo "Downloading icon themes (Kali Linux icons)"
# Kali themes source: https://gitlab.com/kalilinux/packages/kali-themes/-/tree/kali/master/share/icons
mkdir -p ~/.icons
wget -P ~/.icons https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/icons/kali-icons.tar.gz
tar -xzf ~/.icons/kali-icons.tar.gz -C ~/.icons
rm -f ~/.icons/kali-icons.tar.gz

echo "Setting themes"
gsettings set org.gnome.shell enabled-extensions ['user-theme@gnome-shell-extensions.gcampax.github.com']
gsettings set org.gnome.desktop.interface gtk-theme 'Kali-Light'
gsettings set org.gnome.desktop.interface icon-theme 'Flat-Remix-Blue-Dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Kali-Dark'

echo "Setting misc configurations"
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false

echo "Setting font sizes"
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 10'
gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'

echo "Changing UPower levels"
sudo sed -i 's/PercentageLow=10/PercentageLow=20/g' /etc/UPower/UPower.conf
sudo sed -i 's/PercentageCritical=3/PercentageCritical=10/g' /etc/UPower/UPower.conf
sudo sed -i 's/PercentageAction=2/PercentageAction=5/g' /etc/UPower/UPower.conf

echo "Setting custom shortcuts"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Gnome Terminal'
gsettings set org.gnome.desktop.wm.keybindings close ['<Shift><Super>q']

echo "Disabling select search providers"
gsettings set org.gnome.desktop.search-providers disabled ['org.gnome.Epiphany.desktop', 'org.gnome.Software.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Characters.desktop']

echo "Improving Plymouth support"
sudo systemctl disable gdm.service
sudo systemctl enable gdm-plymouth.service

echo "Your setup is ready. You can reboot now!"
