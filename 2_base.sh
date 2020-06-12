#!/bin/bash

echo "Adding multilib support"
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

echo "Syncing repos and updating packages"
sudo pacman -Syu --noconfirm

echo "Installing and configuring UFW"
sudo pacman -S --noconfirm ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Installing additional Intel drivers"
sudo pacman -S --noconfirm intel-media-driver lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader

# Reference: https://github.com/lutris/docs/blob/master/WineDependencies.md
# echo "Installing Lutris (with Wine support)
# sudo pacman -S --noconfirm lutris wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs

echo "Installing common applications"
sudo pacman -S --noconfirm neovim keepassxc git openssh links upower htop powertop p7zip ripgrep unzip fwupd

echo "Installing Firefox Flatpak"
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user --assumeyes install flathub org.mozilla.firefox

echo "Setting automatic updates for Flatpak apps"
touch ~/.config/systemd/user/flatpak-update.timer
tee -a ~/.config/systemd/user/flatpak-update.timer << EOF
[Unit]
Description=Flatpak update

[Timer]
OnCalendar=7:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

touch ~/.config/systemd/user/flatpak-update.service
tee -a ~/.config/systemd/user/flatpak-update.service << EOF
[Unit]
Description=Flatpak update

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak update -y
EOF

systemctl --user enable flatpak-update.timer
systemctl --user start flatpak-update.timer

echo "Creating user's folders"
sudo pacman -S --noconfirm xdg-user-dirs

echo "Installing fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-roboto-mono ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts ttf-fira-code ttf-fira-mono cantarell-fonts

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/ahw57vapx9h41.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/snro7b9hso141.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/BU9AoyoEJgMgmmqKsAV7Kjr8PrRGhWiAZNRlbX8MWNw.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/DIGCO6c0q1wn3ueu_Uebpuv7BfKaQJgKhemcH_3vfVQ.png

# echo "Installing Node.js LTS"
# sudo pacman -S --noconfirm nodejs-lts-erbium

# echo "Increasing the amount of inotify watchers"
# echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system
