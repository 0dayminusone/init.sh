if [[ "$distro" == *"Arch"* ]]; then
  donecode 0
  echo "Arch Linux detected, executing Arch tweaks"
  donecode 0
elif [[ "$distro" == *"SUSE"* ]]; then
  donecode 0
  echo "openSUSE detected, executing openSUSE tweaks"
  donecode 0

  response "Adding zypper tweaks"
  if [[ $latestresponse == "y" ]]; then
    sudo chmod 777 /etc/zypp/zypp.conf
    echo "
download.max_concurrent_connections=10
download.min_download_speed=20000
" >>/etc/zypp/zypp.conf
    sudo chmod 600 /etc/zypp/zypp.conf
    donecode 0
    sudo "$bat" /etc/zypp/zypp.conf
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  response "Fixing SDDM (it's broken by default if you don't want to use XDM)"
  if [[ $latestresponse == "y" ]]; then
    sudo mkdir -p /etc/sddm.conf.d/
    sudo chmod 777 -R /etc/sddm.conf.d/
    echo "[General]
DisplayServer=wayland
" >/etc/sddm.conf.d/10-wayland.conf
    sudo chmod 600 -R /etc/sddm.conf.d/
    sudo chmod 600 /etc/sddm.conf.d/10-wayland.conf
    donecode 0
    sudo "$bat" /etc/sddm.conf.d/10-wayland.conf
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  response "Removing preinstalled KDE bloat"
  if [[ $latestresponse == "y" ]]; then
    donecode 0
    sudo zypper remove -y kate kcalc kcharselect kmag kmousetool kompare konversation kuiviewer kwalletmanager okular virt-viewer skanlite xterm-bin tigervnc vlc xscreensaver firefox
    donecode 0
  else
    echo "Skipping"
    donecode 0.5
  fi

elif [[ "$distro" == *"fedora"* ]]; then
  donecode 0
  echo "Fedora detected, executing Fedora tweaks"
  donecode 0
  response "DNF improvements"
  if [[ $latestresponse == "y" ]]; then
    sudo chmod 777 /etc/dnf/dnf.conf
    echo "# DNF Configuration:
fastestmirror=True
max_parallel_downloads=20
defaultyes=True
keepcache=False" >>/etc/dnf/dnf.conf
    sudo chmod 600 /etc/dnf/dnf.conf
    donecode 0
    sudo cat /etc/dnf/dnf.conf
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  response "Would you like to disable and remove the openssh-server service?"
  if [[ $latestresponse == "y" ]]; then
    sudo systemctl status sshd
    sudo systemctl stop sshd
    sudo systemctl disable sshd --now
    sudo systemctl status sshd
    sudo dnf remove openssh-server -y
    sudo systemctl status sshd
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  # Configure flatpak and flathub
  response "Would you like to execute flatpak improvements and add the Flathub repository?"
  if [[ $latestresponse == "y" ]]; then
    sudo dnf install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sudo flatpak override --filesystem=/usr/share/icons/:ro
    sudo flatpak override --filesystem="/home/$USER/.icons/:ro"
    donecode 0
  else
    echo "Skipping"
    donecode 0.5
  fi

  response "Would you like to enable and add the RPM Fusion Fedora package repositories? They include packages that Fedora doesn't want to ship since they contain non-free packages"
  if [[ $latestresponse == "y" ]]; then
    sudo dnf install \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf group upgrade core
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  response "Would you like to disable Plymouth (the boot screen overlay)? It hides systemctl logs, which can be harmful to the user"
  if [[ $latestresponse == "y" ]]; then
    sudo dnf remove plymouth -y
    donecode 0
  else
    echo "skipping"
    donecode 0
  fi

  response "If you intend to use UFW instead of firewalld, proceed (this will also remove firewalld). MAKE SURE YOU ARE ON A SECURE NETWORK WHEN YOU RUN THIS"
  if [[ $latestresponse == "y" ]]; then
    sudo systemctl status firewalld
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld --now
    sudo systemctl status firewalld
    sudo dnf remove firewalld -y
    sudo systemctl status firewalld
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi
else
  echo "Distribution not supported"
fi

response "The CTT Linux utility is a very useful tool that provides scripts with an interactive screen for all distributions, like changing the GRUB theme. It also has some special modules for Fedora (Snapper GRUB support)"
if [[ $latestresponse == "y" ]]; then
  donecode 0
  curl -fsSL https://christitus.com/linux | sh
  donecode 0
  response "If you selected the 'GRUB theme script' in the linutil, you need to also run this script module for it to work. You may also want to edit things in the GRUB config file. This module will give you an opportunity to do that"
  if [[ $latestresponse == "y" ]]; then
    sudo "$nvim" /etc/default/grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    donecode 0
  else
    echo "Skipping"
    donecode 0
  fi
else
  echo "Skipping"
  donecode 0
fi

donemodule
