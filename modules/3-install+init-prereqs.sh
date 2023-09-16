read -p "Is this for a server or desktop? Type 'd' for Desktop or 's' for Server: " latestresponse
if [[ $latestresponse == *"s"* ]] || [[ $latestresponse == *"S"* ]]; then
  if [[ $distro == *"nixos"* ]]; then
    echo "NixOS server detected"
    donecode 0
    response "First, you will be prompted to provide the 'configuration.nix' file within your backup, then you will be able to edit it, then the configuration.nix file from the backup will be copied to the system"
    if [[ $latestresponse = "y" ]]; then
      read -p "Where is the /etc/nixos/configuration.nix file located within your backup? Provide the full filepath: " nixconfigfile
      echo "It will be copied to a temporary location, you will be able to edit it. Once you are done with the changes, save and exit the editor"
      sudo cp -vf "$nixconfigfile" "/tmp/configuration.nix"
      sudo "$nvim" "/tmp/configuration.nix"
      donecode 0
      echo "Now copying the file to the system"
      donecode 2
      sudo cp -vi "/tmp/configuration.nix" "/etc/nixos/configuration.nix"
      echo "Now displaying the copied system /etc/nixos/configuration.nix file"
      "$bat" /etc/nixos/configuration.nix
      donecode 2
    fi
    response "Now rebuilding the system with the new configuration.nix file"
    if [[ $latestresponse == "y" ]]; then
      sudo nixos-rebuild switch
    fi
  fi
else

  donecode 0
  printf "A desktop system has been detected, executing the respective commands"
  donecode 0.5

  donecode 0
  sudo systemctl set-default graphical.target
  donecode 0

  response "Now edit the gen.toml file and change all the variables like hostname and systemd service branches, etc. (you may want to just switch your .dotfiles git branch, if you got this backup from another machine)"
  if [[ $latestresponse == "y" ]]; then
    vi "/home/$USER/.config/rebos/gen.toml"
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  response "Initializing rebos"
  if [[ $latestresponse == "y" ]]; then
    "$rebos" setup
    "$rebos" gen commit "1st"
    "$rebos" gen current to-latest
    "$rebos" gen current build
    donecode 0.5
  else
    echo "Skipping"
    donecode 0.5
  fi

  donecode 0
  printf "Now exit this script, start your display server/desktop environment, then rerun this script and module to this point"
  echo "(Ctrl + C)"
  donecode 2

  # Personal Reminders
  donecode 0
  response "Now change the gitconfig file to reflect your current device"
  donecode 0
  response "Now setup KDE Connect"
  donecode 0
  response "Now setup Plasma accounts (in the settings page)"
  donecode 0
  response "Now setup desktop and monitor settings in KDE settings"
  donecode 0
  response "Now setup mouse settings in KDE settings"
  donecode 0
  response "Now login to Kopia"
  donecode 0
  response "Now setup font settings in KDE settings"
  donecode 0
  response "Change all the git repositories (i.e. .dotfiles) to the correct git branch of your hostname"
  donecode 0
  response "It is highly recommended you reboot, as it is likely that Plasma or other DEs may break for some reason"
  donecode 0
  response "Make sure you setup the cloud sync app"
  donecode 0
fi

# Global Server & Desktop Reminders
response "Configure and check the system firewall"
donecode 0
response "Now login to the Tailnet and setup Tailscale"
donecode 0
response "REMEMBER: ~/.ssh/ permissions should be 770, THE FILES INSIDE ~/.ssh/* should be 600. MAKE SURE YOU DO THIS (it's always a pain point)"
if [[ $latestresponse == "y" ]]; then
  sudo chown "$USER" "/home/$USER/.ssh/"
  sudo chmod 770 "/home/$USER/.ssh/" -R

  sudo chown "$USER" "/home/$USER/.ssh/"* -R
  sudo chmod 600 "/home/$USER/.ssh/"* -R
  donecode 0
else
  echo "Skipping"
  donecode 0
fi

donemodule
