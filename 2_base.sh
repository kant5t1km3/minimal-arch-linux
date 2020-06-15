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
sudo pacman -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader

echo "Enabling video accelaration "
sudo pacman -S --noconfirm libva libva-utils libva-intel-driver ffmpeg

# Reference: https://github.com/lutris/docs/blob/master/WineDependencies.md
# echo "Installing Lutris (with Wine support)
# sudo pacman -S --noconfirm lutris wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs

echo "Installing common applications"
sudo pacman -S --noconfirm vim keepassxc git openssh links upower htop powertop p7zip ripgrep unzip fwupd

echo "Installing Firefox Flatpak"
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user --assumeyes install flathub org.mozilla.firefox
flatpak override --user --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox

echo "Improving font rendering issues with Firefox Flatpak on Wayland"
mkdir -p ~/.var/app/org.mozilla.firefox/config/fontconfig
touch ~/.var/app/org.mozilla.firefox/config/fontconfig/fonts.conf
tee -a ~/.var/app/org.mozilla.firefox/config/fontconfig/fonts.conf << EOF
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
    <!-- Disable bitmap fonts. -->
    <selectfont><rejectfont><pattern>
        <patelt name="scalable"><bool>false</bool></patelt>
    </pattern></rejectfont></selectfont>
</fontconfig>
EOF

echo "Creating user's folders"
sudo pacman -S --noconfirm xdg-user-dirs

echo "Installing fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-roboto-mono ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts ttf-fira-code ttf-fira-mono ttf-font-awesome

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/ahw57vapx9h41.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/snro7b9hso141.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/BU9AoyoEJgMgmmqKsAV7Kjr8PrRGhWiAZNRlbX8MWNw.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/DIGCO6c0q1wn3ueu_Uebpuv7BfKaQJgKhemcH_3vfVQ.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/nasajp.jpg

echo "Ricing bash"
touch ~/.bashrc
tee -a ~/.bashrc << EOF
export PS1="\w \\$  "
PROMPT_COMMAND='PROMPT_COMMAND='\''PS1="\n\w \\$  "'\'
EOF

echo "Blacklisting watchdog modules"
sudo touch /etc/modprobe.d/nowatchdog.conf
sudo tee -a /etc/modprobe.d/nowatchdog.conf << EOF
blacklist iTCO_wdt
EOF

# echo "Installing Node.js LTS"
# sudo pacman -S --noconfirm nodejs-lts-erbium

# echo "Increasing the amount of inotify watchers"
# echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

# echo "Installing zsh"
# sudo pacman -S --noconfirm zsh zsh-completions
# chsh -s /usr/bin/zsh

# echo "Installing powerlevel10k theme"
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
# wget -P ~/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/zsh/.p10k.zsh
# wget -P ~/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/dotfiles/zsh/.zshrc
