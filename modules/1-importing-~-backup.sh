response "Importing home directory backup"
if [[ $latestresponse == "y" ]]; then
  printf "IMPORTANT: Ensure this script is NOT running inside the backup directory or user directory"
  printf "\nIMPORTANT: Ensure you have external backups of the backup directory"
  printf "\nProcess: 1. Moving backup to /home/tmp/ directory\n2. Removing user directory\n3. Moving backup to user directory"

  donecode 5

  read -p "What is the username of the target user? " usr
  groups "$usr"
  read -p "What group does the user belong to (usually the same as the username)? " group
  donecode 0
  lsblk
  donecode 0
  read -p "What is the root path of the backup? REMEMBER TO ADD / TO THE END OF THE PATH: " rootpath

  donecode 0

  sudo mkdir -p /home/tmp
  sudo chown -R "$usr:$group" /home/tmp
  sudo mv -v "$rootpath" /home/tmp/backup
  sudo rm -rfv "/home/$usr"
  sudo mv /home/tmp/backup/ "/home/$usr"
  sudo chown -R "$usr:$group" "/home/$usr"
  sudo chmod -R 740 "/home/$usr"
  sudo rm -rf /home/tmp
  donecode 0.5

else
  echo "Skipping"
  donecode 0.5
fi

response "Distributions with SELinux don't like it when you replace the home directory. You need to reassign the extended home directory label"
if [[ $latestresponse == "y" ]]; then
  sudo ls -lZ /home
  sudo restorecon -R /home
  donecode 2
else
  echo "Skipping"
  donecode 0.5
fi

donecode 0
ping -c 5 1.1.1.1
donecode 0

response "Before you continue, please ensure you have an internet connection. Some distributions don't copy it over from the install page. This module will ping 1.1.1.1 and then open nmtui after 5 seconds"
if [[ $latestresponse == "y" ]]; then
  nmtui
  donecode 0
else
  echo "Skipping"
  donecode 0
fi

response "Setting up network hostname"
if [[ $latestresponse == "y" ]]; then

  read -p "What would you like the system hostname to be? " hostnamevar
  echo "Setting hostname to:"
  echo "$hostnamevar"

  printf "\n"
  sudo hostnamectl hostname "$hostnamevar"
  donecode 0
  sudo hostnamectl
  donecode 3
else
  echo "Skipping"
  donecode 0
fi
donemodule
