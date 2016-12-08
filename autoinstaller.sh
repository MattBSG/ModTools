arch=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    os=$DISTRIB_ID
    ver=$DISTRIB_RELEASE

	if [ "$os" = "Ubuntu" ]; then
		if [ "$ver" = "12.04" ]; then
			installer=0
			levenshtein=0
		elif [ "$ver" = "14.04" ]; then
			installer=0
			levenshtein=0
		elif [ "$ver" = "16.04" ]; then
			installer=0
			levenshtein=1
		elif [ "$ver" = "16.10" ]; then
			installer=0
			levenshtein=1
		else
			installer=1
		fi
	else
		installer=1
	fi
# Future multi-OS support for installation when I'm not lazy
#
#elif [ -f /etc/debian_version ]; then
#    os=Debian
#    ver=$(cat /etc/debian_version)
else
    os=$(uname -s)
    ver=$(uname -r)
fi

if [ "$installer" = 1 ]; then
		echo -e "This system is running an unsupported OS. Details: \nOS: $os \nVersion: $ver"
		echo
		printf "\e[1;31mThe installer will not continue. Please reference the wiki for a list of supported operating systems. Exiting...\e[0m\n"
		exit 1
fi

clear

if [ "$levenshtein" = 1 ]; then
printf "\e[1;31mThis OS is not supported in installing python-Levenshtein.\e[0m This will not affect the bot.\n"
fi

echo -e "This script will install ModTools in your home directory for your user \n \nThis action will use about 110mb of storage. Would you like to continue?"
# prompt user if they want to install the bot or not
while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy]* ) clear; echo Running installer; sleep 2; break;;
        [Nn]* ) echo Quitting; exit;;
        * ) echo "Invalid Selection. Please answer y for yes or n for no.";;
    esac
done

if [ "$os" = "Ubuntu" ]; then

	# Adding repos that have dependancies that we need to download
	sudo add-apt-repository ppa:fkrull/deadsnakes -y
	sudo add-apt-repository ppa:mc3man/trusty-media -y
	apt-get update
	sudo apt-get upgrade -y

	echo 
	echo Installing python and its modules....
	sleep 1

	# Working out of the users home directory to make things easier to find
	mkdir ~/installation-files
	cd ~/installation-files
	sudo apt-get install git python3.5 python3.5-dev unzip zlib1g-dev libjpeg8-dev -y
	wget https://bootstrap.pypa.io/get-pip.py
	sudo python3.5 get-pip.py
	pip install aiohttp
	pip install fuzzywuzzy
	pip install aiofiles
	pip install Pillow

	if [ "$levenshtein" = 0 ]; then
		pip install python-Levenshtein
	fi

	python3.5 -m pip install -U discord.py
	easy_install python-slugify
	pip install python-slugify
	git clone http://github.com/un33k/python-slugify
	cd python-slugify
	python3.5 setup.py install
	wget https://github.com/un33k/python-slugify/zipball/master
	cd python-slugify
	unzip master -d archive-files
	cd archive-files/un33k-python-slugify-f2ab4b7
	python3.5 setup.py install

	# cleanup and start the configuration process
	cd ~
	rm -rfv installation-files

	echo
	echo Installation completed, starting configuration....
	sleep 3
fi

#Hand off to config shell file
./config.sh

exit 0
