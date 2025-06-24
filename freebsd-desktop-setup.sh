# Switch to quarterly pkg repo for stable desktop packages
mkdir -p /usr/local/etc/pkg/repos
cat <<EOF > /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/quarterly",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF

pkg update -f
pkg upgrade -y

# Install XFCE and all requested multimedia, productivity, and gaming apps
pkg install -y \
  xorg xfce xfce4-goodies \
  firefox chromium \
  vlc gimp libreoffice \
  retroarch kodi steam \
  qt5ct gnome-themes-extra \
  open-vm-tools xf86-video-vmware \
  alsa-utils pulseaudio pavucontrol \
  neofetch octopkg git wget unzip htop

# Enable desktop and VMware services
sysrc sddm_enable=YES
sysrc dbus_enable=YES
sysrc hald_enable=YES
sysrc vmware_guest_vmblock_enable=YES
sysrc vmware_guest_vmhgfs_enable=YES
sysrc vmware_guest_vmmemctl_enable=YES
sysrc vmware_guest_vmxnet_enable=YES
sysrc sndiod_enable=YES

# Default audio device and mixer level
echo 'hw.snd.default_unit=0' >> /etc/sysctl.conf
echo 'mixer vol 100' >> /etc/rc.local

# Wallpapers and themes
mkdir -p /usr/share/wallpapers/custom
cd /usr/share/wallpapers/custom
fetch https://wallpapercave.com/wp/wp2599594.jpg -o space1.jpg
fetch https://wallpapercave.com/wp/wp2754828.jpg -o retro1.jpg
fetch https://wallpapercave.com/wp/wp2860281.jpg -o archstyle1.jpg
cd ~

# Enable Linux support and prepare for Steam and Chrome
pkg install -y linux_base-c7
sysrc linux_enable=YES
kldload linux

# Post-install loader config for Linux and sound
cat << EOF >> /boot/loader.conf
linux_load="YES"
linux64_load="YES"
vmware_load="YES"
snd_hda_load="YES"
EOF

# Configure SDDM
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

# Final instructions
echo ">>> Setup complete! Reboot and log into XFCE via SDDM."
echo ">>> KDE is not included; install it later using: pkg install kde5"
