#!/bin/sh

set -e

echo ">>> Updating system..."
pkg update -f
pkg upgrade -y

echo ">>> Installing core desktop packages and tools..."
pkg install -y \
    xorg sddm \
    kde5 plasma5-sddm-kcm \
    xfce xfce4-goodies \
    firefox chromium \
    vlc gimp libreoffice \
    retroarch kodi \
    qt5ct gnome-themes-extra \
    open-vm-tools xf86-video-vmware \
    alsa-utils pulseaudio pavucontrol \
    neofetch octopkg git wget unzip htop

echo ">>> Enable sddm for GUI login..."
sysrc sddm_enable=YES

echo ">>> Enabling VMware tools and required services..."
sysrc vmware_guest_vmblock_enable=YES
sysrc vmware_guest_vmhgfs_enable=YES
sysrc vmware_guest_vmmemctl_enable=YES
sysrc vmware_guest_vmxnet_enable=YES
sysrc dbus_enable=YES
sysrc hald_enable=YES

echo ">>> Enable sound..."
sysrc sndiod_enable=YES

echo ">>> Set default sound device (VMware) and mixer volume..."
echo 'hw.snd.default_unit=0' >> /etc/sysctl.conf
echo 'mixer vol 100' >> /etc/rc.local

echo ">>> Creating wallpapers and themes directory..."
mkdir -p /usr/share/wallpapers/custom
cd /usr/share/wallpapers/custom
fetch https://wallpapercave.com/wp/wp2599594.jpg -o space1.jpg
fetch https://wallpapercave.com/wp/wp2754828.jpg -o retro1.jpg
fetch https://wallpapercave.com/wp/wp2860281.jpg -o archstyle1.jpg
cd ~

echo ">>> Installing Google Chrome via linux_base-c7 setup..."
pkg install -y linux_base-c7
sysrc linux_enable=YES
kldload linux

echo ">>> Installing Steam (Linux version)..."
pkg install -y steam

echo ">>> Post-install tip: You may need to enable Linux kernel modules at boot..."
cat << EOF >> /boot/loader.conf
linux_load="YES"
linux64_load="YES"
vmware_load="YES"
snd_hda_load="YES"
EOF

echo ">>> Set up user session chooser for SDDM..."
cat << EOF > /usr/local/etc/sddm.conf
[Autologin]
User=
Session=

[Theme]
Current=breeze

[Users]
MaximumUid=65000
MinimumUid=1000
EOF

echo ">>> Setup complete!"
echo ">> Reboot, log in with SDDM, and choose between KDE Plasma and XFCE."
echo ">> Consider running 'octopkg' as GUI package manager."
