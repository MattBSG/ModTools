chmod +x install.sh
echo -e "This script will install ModTools in your home directory for your user \n \n \n \n \n \nThis action will use about 100mb of storage. Would you like to continue?"

while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy]* ) clear; echo Running installer; sleep 2; ./install.sh; break;;
        [Nn]* ) echo Quitting; exit;;
        * ) echo "Invalid Selection. Please answer y for yes or n for no.";;
    esac
done
