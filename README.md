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
- Kernel: LZ4 compression
- Watchdog disabled

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
- Gnome / KDE / Sway (separate scripts)
- UFW (deny incoming, allow outgoing)
- Automatic login
- Fonts
- Wallpapers
- Intel: vulkan + intel-vaapi-driver
- Multilib
- yay (AUR helper)
- Plymouth
- Flatpak support - Firefox installed as Flatpak
- Lutris with Wine support (commented)
- Sway only:
   - Base16 theme: alacritty, rofi, vim
   - Flatpak: automatic updates via systemd timer

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
11. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_gnome.sh` or `2_plasma.sh` or `2_sway.sh`
12. Make the script executable: `chmod +x 2_gnome.sh` or `chmod +x 2_plasma.sh` or `chmod +x 2_sway.sh`
13. Run the script: `./2_gnome.sh` or `./2_plasma.sh` or `./2_sway.sh`

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

### How to chroot

```
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
cryptsetup luksOpen /dev/nvme0n1p2 cryptlvm
mount /dev/vg0/root /mnt
arch-chroot /mnt
```
