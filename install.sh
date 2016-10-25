sudo add-apt-repository ppa:fkrull/deadsnakes -y
sudo add-apt-repository ppa:mc3man/trusty-media -y
apt-get update
sudo apt-get upgrade

echo 
echo Installing python and its modules....
sleep 1

mkdir ~/installation-files
cd ~/installation-files
sudo apt-get install git python3.5 python3.5-dev unzip zlib1g-dev libjpeg8-dev -y
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.5 get-pip.py
pip install aiohttp
pip install fuzzywuzzy
pip install aiofiles
pip install python-Levenshtein
pip install Pillow
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
cd ~
rm -rfv installation-files

echo !Installation completed!
echo .
echo .
echo .
echo .
echo Starting configuration....
sleep 3