# Fixes bug with PUTTY relating to line drawing charcters used by dialog.
# https://www.novell.com/support/kb/doc.php?id=7015165
# https://stackoverflow.com/a/37847838
export NCURSES_NO_UTF8_ACS=1

dialog --keep-tite --no-mouse --yesno "This file is used to configure AutoMod and the related settings. Do not run this if you have previously configured the options! Would you like to start configuration?" 8 64

# 1 - Cancel pressed. 255 - ESC pressed.
response=$?
case $response in
   1) exit;;
   255) exit;;
esac

# Create temp file
OUTPUT="/tmp/input.txt"
>$OUTPUT

dialog --keep-tite --no-mouse --inputbox "Ok, our dependancies should have been installed. Lets continue to configuration. Well confirm your options later on.\n\nGo to https://github.com/MattBSG/ModTools/wiki/Configuration\n\nFollow the instructions to create an application and bot account. Then enter the account's CLIENT ID in the following prompt. Make sure it is the CORRECT user id or ModTools will give the wrong invite link!\n\nEnter the userid of your bot account:" 32 64 2>$OUTPUT

response=$?
case $response in
   1) exit;;
   255) exit;;
esac
botid=$(<$OUTPUT)

dialog --keep-tite --no-mouse --inputbox "On the same page as you got your userid you should see a field that says 'Token'.\n\nClick the 'Click to reveal' button, then copy and paste the ENTIRE string at the next prompt.\n\nEnter the token of your bot account:" 32 64 2>$OUTPUT

response=$?
case $response in
   1) exit;;
   255) exit;;
esac
bottoken=$(<$OUTPUT)

dialog --keep-tite --no-mouse --inputbox "Now we need to get your userid.\n\nFind it by mentioning your self with a backslash before.\n\nFor example: \@DamFam#1234 will read something like <@66516516512568135>\n\nYou would enter '66516516512568135' without quotes. This will be set as the bot's ownerid.\n\nPlease enter YOUR userid:" 32 64 2>$OUTPUT

response=$?
case $response in
   1) exit;;
   255) exit;;
esac
ownerid=$(<$OUTPUT)

dialog --keep-tite --no-mouse --inputbox "Last but not least, we need to know what you want to use for the command prefix.\n\nFor example: In !!help, !! is the command prefix.\n\nPlease enter what you would like for your command prefix (!! is the default):" 32 64 2>$OUTPUT

response=$?
case $response in
   1) exit;;
   255) exit;;
esac
prefix=$(<$OUTPUT)

echo "
BOT_USER_ACCOUNT = $botid" | cat - >> automod/constants.py
echo "[Credentials]
Token = $bottoken

[Permissions]
OwnerID = $ownerid

[Chat]
CommandPrefix = $prefix" | cat - >> config/options.txt

dialog --no-mouse --keep-tite --msgbox "Awesome! You finished configuration of the bot. Lets verify that all the information you entered is correct.\n\nHere are the options you set (inside quotation marks):\n\nBot User ID = '$botid'\nBot Token = '$bottoken'\nYour ID = '$ownerid'\nCommand Prefix = '$prefix'\n\nConfiguration complete! If there is any incorrect information, you will need to manually edit it in either automod/constants.py or config/configs.txt\n\nYou can start your bot by running 'python3.5 run.py'\n\nFor more information refer to the wiki." 32 64

# This file will delete it-self since if it is re-run then it will entirely break the config and need to be repaired
rm linux-config.sh
exit 0
