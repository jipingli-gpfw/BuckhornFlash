REM Use default color
color

echo off
echo "              ######################################            "
echo "              Welcome to the Buckhorn Flash Program!            "
echo "                         Jiping Li                              "
echo "                         Rev 00.01                              "
echo "              ######################################            "
echo.



REM Unzip Customer build package zip file and then unzip BCK.0x.00.xx.00.zip file to get “aml_upgrade_package.img” build image file
REM Copy file SECURE_BOOT_SET into the following folder… C:\Program Files (x86)\Amlogic\USB_Burning_Tool\license
REM Copying this file into this directory will allow you to use the Secured version of the Buckhorn image.
REM If you know your Buckhorn device is non secured then you use aml_upgrade_package.img file. 
REM If you know your Buckhorn device is secured then you will use the secure-aml_upgrade_package.img file.  



REM echo on
REM Check whether the adb is installed or not
echo Check whether the adb is installed or not:
if not exist "C:/adb/adb.exe" (
     echo Did not find c:/adb/adb.exe, please make sure it's installed and location correct.
	 goto HandleError4adb
     ) else (
	 adb version
	 )
echo.


REM Check whether the USB_burning_tool is installed or not
echo Check whether the USB_burning_tool is installed or not:
if not exist "C:/Program Files (x86)/Amlogic/USB_Burning_Tool/USB_Burning_Tool.exe" (
     echo Hey, did not find "C:/Program Files (x86)/Amlogic/USB_Burning_Tool/USB_Burning_Tool.exe", please make sure it's installed and location correct.
	 goto HandleError
     ) else (
	 echo Already installed. Cool.
	 )
	 
	 
REM Check whether the Buckhorn is connected or not
REM If not connected, ask to confirm the adb mode "arm-home-record-mode"
echo.
echo "NOTE!!!!!! Please connect the Buckhorn to tester through USB port, and 
echo "power on the Buckhorn, then
echo "click arm-home-record-mode to put the Buckhorn into debug mode

set /p command=Already pressed the buttons? YES/NO?    
if "%command%"=="YES" (
echo "Buckhorn connected"
goto Connected
) else (
goto Disconnected
)



REM Check whether the secure certificate file exist or not for "secure" Buckhorn
:Connected
adb devices

set /p command=Did you see "12345678900  device"? YES/NO?    
if "%command%"=="YES" (
goto EnterADBShellToCheckSecure
) else (
goto Disconnected
)


REM Add tips here before opening the tool
:EnterADBShellToCheckSecure
echo Enter adb shell
echo Please check the secure or insecure info of androidboot.serialno. Keep in your memory!
adb shell cat /proc/cmdline
REM echo If %errorlevel%==0, last run is ok. else error.

if "%errorlevel%"=="0" (
	goto ShowUSBBurningToolTips 
) else (
	goto HandleError
)

:ShowUSBBurningToolTips
REM ----------------> going to use the usb burning too
echo.
echo !!!!Now, going to open the burning tool, before doing that, please read following instructions:
echo Please load the correct image file.  If you see secure at the end of the line, then choose secure image.
echo Secured ->  secure-aml_upgrade_package.img file. 
echo Insecured -> aml_upgrade_package.img file. 
echo Use:
echo -	Launch USB_Burning_Tool
echo -	File / Import Image 
echo -	Choose the image you want to install onto Buckhorn (i.e., aml_upgrade_package.img)
echo.
echo Configuration:
echo -	Once image has been imported into the USB_Burning_Tool v2.04
echo -	Unselect Erase Flash checkbox.  If this is still selected you will wipe out Buckhorn Manufacturing partition.
echo -	Erase bootloader should be selected (Due to NAND partition size changes this is required)
echo. 
echo !!!!!!!!!!!!!!!!!!!!!!!!!Important: check below instructions carefully!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo Getting Buckhorn to be recognized by USB_Burning_Tool:
echo -	Turn Buckhorn off
echo -	Connect Buckhorn to PC USB port with Type C USB cable
echo -	First Long Press and hold the Landing button. 10+ seconds.
echo You should see Connect Success on the screen of the USB_Burning_Tool
echo.	 
echo Burning on New Image:
echo -	Press the Start button.
echo Allow the tool to complete the installation.  
echo.
echo Once you see burning complete, please click "Stop" and close the Usb_Burning_Tool, then unplug the USB cable. 
echo.

set /p command=Are you clear? YES/NO?   
if "%command%"=="YES" (
goto OpenUSBBurningTool
) else (
goto HandleError
)


REM Open the USB burning tool, do the burning over there.
:OpenUSBBurningTool
"C:/Program Files (x86)/Amlogic/USB_Burning_Tool/USB_Burning_Tool.exe"
REM echo %errorlevel%
if "%errorlevel%"=="0" (
	goto FinishThisBat 
) 
if "%errorlevel%"=="2" (
	goto FinishThisBat 
) else (
	goto HandleError
)

 
:HandleError4adb
echo.
echo If adb (Android Debug Bridge) not installed, download from Google:  
echo https://developer.android.com/studio/index.html#downloads (you can download the command line tools). 
echo Some websites that explain the use of the tool.  
echo http://lifehacker.com/the-easiest-way-to-install-androids-adb-and-fastboot-to-1586992378
echo http://www.android.gs/install-android-sdk-adb-windows/
echo.
goto HandleError

:Disconnected
echo Buckhorn not ready!

:HandleError
color 4
echo !!!!!!!!!!!!! ERROR !!!!!!!!!!!!!  

:FinishThisBat
echo DONE!

:End
echo.
set /p command=Press any key to exit... 
