@echo off

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

echo Admin elevation successful, installing dependancies


pip install aiohttp
pip install fuzzywuzzy
pip install aiofiles
pip install Pillow
pip install -U discord.py
easy_install python-slugify
pip install python-Levenshtein
echo.
echo.
echo Done! Starting configuration
timeout /t 5 /nobreak



cls
echo Hi there. For this part you will need to set your ownerid
echo for the bot, this is the same as your discord user id.
echo.
echo Opening the relevent page for you with more detailed instructions
start "Getting userid" "https://github.com/MattBSG/ModTools/wiki/Configuration"
echo.
echo.
echo Please enter your user id in the prompt
set /p ownerid="Your User ID: "
cls



echo Got it. "%ownerid%" is the user id being set as bot owner
echo.
echo Now on that same page there is instructions to create a bot account; go ahead and do that now.
echo You are going to be entering the Token in this next prompt.
echo Its the thing your bot will use to login to discord
echo.
echo.
set /p token="Your Bot Token: "
cls



echo Got it. "%token%" is the token the bot will use to login
echo.
echo On the same page you got your bot's token you will see its client id
echo under APP DETAILS
echo.
echo.
echo Please enter it here
set /p clientid="Client ID: "
cls



echo Got it. "%clientid%" is the client id for your bot account
echo.
echo Next go ahead and select what you would like your command prefix to be.
echo.
echo AKA in ^^!^^!ping "^!^!" is the prefix and goes before every command
echo.
echo.
set /p prefix="Command Prefix: "
cls
echo Got it. "%prefix%" is the command prefix
echo.



echo Last but not least, we need to get your sentry token.
echo This token allows the bot to report errors online, to you, so 
echo it is easier to debug any issues that arise.
echo.
echo It looks something like this: 
echo https://dfsdkjfnshekjhnfkjsdfsmsnfjke:djhmsbfweuikfbljhasgvweuyfdgjhds@sentry.io/123456:
echo.
echo.
set /p sentrytoken="Sentry Token: "
cls
echo Got it. "%sentrytoken%" is your sentry token
echo.

echo Writing settings to file...

echo [Credentials]>"config\options.txt"
echo Token = %token%>>"config\options.txt"
echo.>>"config\options.txt"
echo [Permissions]>>"config\options.txt"
echo OwnerID = %ownerid%>>"config\options.txt"
echo.>>"config\options.txt"
echo [Chat]>>"config\options.txt"
echo CommandPrefix = %prefix%>>"config\options.txt"
echo.>>"automod\constants.py"
echo BOT_USER_ACCOUNT = %clientid%>>"automod\constants.py"
echo SENTRYTOKEN = %sentrytoken%>>"automod\constants.py"

echo Done.

echo That's it! Configuration is done! You can run the bot by executing start.bat
echo.
echo Pressing any key at the prompt will close this window
echo and open the page to invite your bot to it's first server
pause
start "Bot Application Page" "https://discordapp.com/oauth2/authorize?client_id=%clientid%&scope=bot&permissions=536345663"