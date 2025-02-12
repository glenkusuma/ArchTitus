#!/bin/bash
#github-action genshdoc
#
# @file ArchTitus
# @brief Entrance script that launches children scripts for each phase of installation.

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
-------------------------------------------------------------------------
                    Automated ArchKusuma Linux Installer
-------------------------------------------------------------------------
                Scripts are in directory named ArchTitus
"
# Function: confirm_continue
# Description: Ask for user confirmation. If the user answers yes,
#              the script continues; otherwise, it exits.
    confirm_continue() {
        read -r -p "Do you wish to continue with the installation? (y/N): " confirm
        case "$confirm" in
            [yY]|[yY][eE][sS])
                echo "Continuing installation..."
                ;;
            *)
                echo "Installation aborted."
                exit 1
                ;;
        esac
    }
    ( bash $SCRIPT_DIR/scripts/startup.sh )|& tee startup.log
      source $CONFIGS_DIR/setup.conf

    confirm_continue

    ( arch-chroot /mnt $HOME/ArchTitus/scripts/1-setup.sh )|& tee 1-setup.log
    
    confirm_continue

    if [[ ! $DESKTOP_ENV == server ]]; then
      ( /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/ArchTitus/scripts/2-user.sh )|& tee 2-user.log
    fi
    
    confirm_continue

    ( $HOME/ArchTitus/scripts/3-post-setup-kusuma.sh )|& tee 3-post-setup-kusuma.log
    
    confirm_continue
    
    cp -v *.log /home/$USERNAME

echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
-------------------------------------------------------------------------
                    Automated ArchKusuma Linux Installer
-------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"
