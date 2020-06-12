# Arch Linux install scripts

## Install script

- LVM on LUKS
- LUKS2
- systemd-boot (with Pacman hook for automatic updates)
- systemd init hooks (instead of busybox)
- SSD Periodic TRIM
- Intel microcode
- Standard Kernel + LTS kernel as fallback
- Hibernate support

### Requirements

- UEFI mode
- NVMe SSD
- TRIM compatible SSD
- Intel CPU (recommended: Skylake or newer due to fastboot)

### Partitions

| Name                                                  | Type  | Mountpoint |
| ----------------------------------------------------- | :---: | :--------: |
| nvme0n1                                               | disk  |            |
| ├─nvme0n1p1                                           | part  |   /boot    |
| ├─nvme0n1p2                                           | part  |            |
| &nbsp;&nbsp;&nbsp;└─cryptlvm                        | crypt |            |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─vg0-swap |  lvm  |   [SWAP]   |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─vg0-root |  lvm  |     /      |

## Post install script
- Gnome / KDE (separate scripts)
- UFW (deny incoming, allow outgoing)
- Automatic login
- Fonts
- Wallpapers
- Intel: vulkan + intel-media-driver
- Multilib
- Lutris with Wine support (commented)
- Flatpak support with automatic updates via systemd timer (Firefox installed as Flatpak)

## Installation guide

1. Download and boot into the latest [Arch Linux iso](https://www.archlinux.org/download/)
2. Connect to the internet. If using wifi, you can use `wifi-menu` to connect to a network
3. Clear all existing partitions (see below: MISC - How to clear all partitions)
4. Give highest priority to the closest mirror to you on /etc/pacman.d/mirrorlist by moving it to the top
5. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/1_install.sh`
6. Change the variables at the top of the file (lines 3 through 9)
   - continent_country must have the following format: Zone/SubZone . e.g. Europe/Berlin
   - run `timedatectl list-timezones` to see full list of zones and subzones
7. Make the script executable: `chmod +x 1_install.sh`
8. Run the script: `./1_install.sh`
9. Reboot into Arch Linux
10. Connect to wifi with `nmtui`
11. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_gnome.sh` or `2_plasma.sh`
12. Make the script executable: `chmod +x 2_gnome.sh` or `chmod +x 2_plasma.sh`
13. Run the script: `./2_gnome.sh` or `./2_plasma.sh`

## Misc guides

### How to clear all partitions

```
gdisk /dev/nvme0n1
x
z
y
y
```

### How to setup Github with SSH Key

```
git config --global user.email "Github external email"
git config --global user.name "Github username"
ssh-keygen -t rsa -b 4096 -C "Github email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
copy SSH key and add to Github (eg. nvim ~/.ssh/id_rsa.pub and copy content into github.com)
```

### How to install yay (AUR helper)
```
echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin
```

### How to chroot

```
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
cryptsetup luksOpen /dev/nvme0n1p2 cryptlvm
mount /dev/vg0/root /mnt
arch-chroot /mnt
```

### Plymouth
```
echo "Installing and configuring Plymouth"
yay -S --noconfirm plymouth
sudo sed -i 's/base systemd autodetect/base systemd sd-plymouth autodetect/g' /etc/mkinitcpio.conf
sudo sed -i 's/quiet rw/quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0 rw/g' /boot/loader/entries/arch.conf
# Arch LTS left out on purpose, in case there's an issue with Plymouth

echo "Installing and setting plymouth theme"
yay -S --noconfirm plymouth-theme-arch-breeze-git
sudo plymouth-set-default-theme -R arch-breeze
```

### Gnome and KDE Plasma only
```
Only Gnome and KDE Plasma are supported now. To see alternative DE/WM setups refer to the repository at [this commit](https://github.com/exah-io/minimal-arch-linux/tree/660ea7e57cfb3f89879dd3bfb47b3d4dd1f569f5)
```
