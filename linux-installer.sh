arch=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
# this is just a mess, leave me be
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

elif [ -f /etc/debian_version ]; then
    os=Debian
    ver=$(cat /etc/debian_version)
	installer=0
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


if [ "$os" = "Ubuntu" ]; then

	# Adding repos that have dependancies that we need to download
	sudo add-apt-repository ppa:fkrull/deadsnakes -y
	sudo add-apt-repository ppa:mc3man/trusty-media -y
	apt-get update
	sudo apt-get upgrade -y

	echo
	echo Installing python and its modules....
	sleep 1

	# Working out of the users current directory
	mkdir installation-files
	cd installation-files
	sudo apt-get install git python3.5 python3.5-dev unzip zlib1g-dev libjpeg8-dev -y
	wget https://bootstrap.pypa.io/get-pip.py
	sudo python3.5 get-pip.py
	sudo pip install -U -r requirements.txt
	if [ "$levenshtein" = 0 ]; then
		sudo pip install python-Levenshtein
	fi

elif [ "$os" = "Debian" ]; then
	apt-get update
	sudo apt-get install build-essential libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl unzip -y
	mkdir installation-files
	pushd installation-files
	wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
	tar -xvf Python-3.5.2.tgz
	cd Python-3.5.2
	sudo ./configure
	sudo make
	sudo make altinstall
	cd ..
	pip3.5 install --upgrade pip
	pip3.5 install -U -r requirements.txt
	pip3.5 install python-Levenshtein
fi

# cleanup; too tired to think of better solution
	rm -rfv installation-files

	echo
	echo Installation completed, starting configuration....
	sleep 3

# Hand off to config shell file

clear
chmod +x config.sh
./linux-config.sh
# This file will delete it-self as it is unnessecary to keep the file after it is used
rm linux-installer.sh
exit 0

