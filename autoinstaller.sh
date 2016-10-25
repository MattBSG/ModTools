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


clear
echo Ok, our dependancies should have been installed. Lets continue to configuration. We\'ll confirm your options later on
echo
echo      Go to https://github.com/MattBSG/ModTools/wiki/Manual-Installation-Instructions#setting-up-the-bot-config
echo
echo
echo Follow the instructions to create an application and bot account. Then enter the accounts USER ID in the following prompt. Make sure it is the CORRECT user id or ModTools will give the wrong invite link!
echo
echo
echo Enter the userid of your bot account \(ie. 237760867968614402\):
read botid
echo Got it. $botid is the user id for your bot account. Moving on.
sleep 3
clear

echo On the same page as you got your userid you should see a field that says "Token".
echo      Click the "Click to reveal" button, then copy and paste the ENTIRE thing at the next prompt.
echo 
echo Enter the token of your bot account:
read bottoken
echo Got it. $bottoken is the token for your bot account. Moving on.
sleep 3
clear

echo Now we need to get your userid.
echo      Find it by mentioning your self with a backslash before.
echo      For example: \\@DamFam#1234 will read something like \<@66516516512568135\>
echo
echo      You would enter "66516516512568135" without quotes. This will be set as the bot\'s ownerid
echo
echo Please enter YOUR userid:
read ownerid
echo Got it. $ownerid is the user id to be set as bot owner. Moving on.
sleep 3
clear

echo Last but not least, we need to know what you want to use for the command prefix
echo      For example: In !!help !! is the command prefix
echo
echo Please enter what you would like for your command prefix \(\"!!\" is the default\):
read prefix
echo Got it. $prefix will be your command prefix.
sleep 3
clear

echo "
BOT_USER_ACCOUNT = $botid" | cat - >> ~/ModTools/automod/constants.py
echo "[Credentials]
Token = $bottoken

[Permissions]
OwnerID = $ownerid

[Chat]
CommandPrefix = $prefix" | cat - >> ~/ModTools/config/options.txt

echo Awesome! You finished configuration of the bot. Lets verify that all the information you entered is correct.
echo      Here are the options you set \(inside quotation marks\):
echo
echo Bot User ID = \"$botid\"
echo Bot Token = \"$bottoken\"
echo Your ID = \"$ownerid\"
echo Command Prefix = \"$prefix\"
echo
echo
echo Configuration complete! If there is any incorrect information entered, you will need to manually edit it in either automod/constants.py or config/configs.txt
echo
echo      You can start your bot by running \"python3.5 run.py\"
echo For more information refer to the wiki.