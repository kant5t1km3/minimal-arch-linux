#!/bin/bash

echo "Updating packages"
sudo pacman -Syu --noconfirm

echo "Installing DKMS packages"
sudo pacman -S --noconfirm dkms

echo "Installing and configuring UFW"
sudo pacman -S --noconfirm ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Improving Intel GPU support"
sudo pacman -S --noconfirm intel-media-driver

echo "Adding Vulkan support"
sudo pacman -S --noconfirm vulkan-intel vulkan-icd-loader

echo "Installing common applications"
sudo pacman -S --noconfirm firefox chromium keepassxc git openssh neovim links upower htop powertop p7zip ripgrep unzip

echo "Installing fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Bold%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Light%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Medium%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Retina%20Nerd%20Font%20Complete.ttf
# sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Regular.ttf
# sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Bold%20Italic.ttf
# sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Italic.ttf
# sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Bold.ttf

echo "Installing and setting zsh, oh-my-zsh and powerlevel10k"
sudo pacman -S --noconfirm zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k
rm -rf "$HOME"/.zshrc
wget -P "$HOME" https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/.zshrc

echo "Installing Node.js LTS"
sudo pacman -S --noconfirm nodejs-lts-erbium npm yarn

echo "Changing default npm directory"
mkdir "$HOME"/.npm-global
npm config set prefix "$HOME/.npm-global"
touch "$HOME"/.profile
tee "$HOME"/.profile << END
export PATH=$HOME/.npm-global/bin:$PATH
END
source "$HOME"/.profile

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Installing Go lang"
sudo pacman -S go dep go-tools

echo "Installing VS Code"
sudo pacman -S --noconfirm code

echo "Installing VS Code theme + icons"
code --install-extension ms-vscode.go

echo "Blacklisting bluetooth"
sudo touch /etc/modprobe.d/nobt.conf
sudo tee /etc/modprobe.d/nobt.conf << END
blacklist btusb
blacklist bluetooth
END
sudo mkinitcpio -p linux-lts
sudo mkinitcpio -p linux

echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

echo "Downloading wallpaper"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/andre-benz-cXU6tNxhub0-unsplash.jpg
