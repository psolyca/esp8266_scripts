:: Get configuration
call esp8266_config.bat

@echo %echov%
setlocal ENABLEDELAYEDEXPANSION
:: Little script to flash a firmware in a NodeMCU
:: Could work with all esp8266 board with USB serial connection

:: Requirements :
::	- kitty or putty for serial connection
::	- an esp8266 device connected by USB serial

:: The firmware is build on a remote server
:: Thus the necessity to retrieve it
:: This could work with any firmware build on a virtual machine

:: Local folder to download the firmware
set localf=.
:: Remote host address
set host=
:: Remote host folder
set remotef=
:: Name of the firmware
set file=firmware-combined.bin
:: User who connect to the remote host
set user=
:: Application used to retrive the firmware (pscp/scp/...)
:: Adding a publickey and a ssh-agent is recommended
set sshcp=scp
:: Set default behavior to avoid question
::		y : do it
::		n : do not do it
::		empty : ask
set download=
set erase=
set flash=y

call esp8266_get_serial.bat
if "!_COM!"=="" (
	call esp8266_get_serial.bat errorcom
	goto :end
)	

:: A file is provided (drag/drop or CLI), so no download is required
if NOT "%1"=="" (
	set file=%1
	goto erase_flash
)

if "%download%"=="n" goto erase_flash
if "%download%"=="" ( set /P download="Download firmware y|N ? " || set download=n )
if "%download%"=="n" goto erase_flash
%sshcp% %user%@%host%:%remotef%%file% %localf%

:erase_flash
if "%erase%"=="n" goto flash_firmware
if "%erase%"=="" ( set /P erase="Erase flash y|N ? " || set erase=n )
if "%erase%"=="n" goto flash_firmware
esptool.py --port %_COM% erase_flash

:flash_firmware
if "%flash%"=="n" goto end
if "%flash%"=="" ( set /P flash="Flash firmware y|N ? " || set flash=n )
if "%flash%"=="n" goto end
echo Flash firmware %file%
esptool.py --port %_COM% --baud 115200 --after hard_reset write_flash --flash_size=detect -fm=dio 0 %file%
set /P retry="Retry y|N?" || set retry=n
if "%retry%"=="y" goto flash_firmware
pause

:end
goto :EOF