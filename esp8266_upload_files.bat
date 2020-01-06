:: Get configuration
call esp8266_config.bat

@echo %echov%
setlocal
:: Little script to manage programming session with a NodeMCU
:: Could work with all esp8266 board with USB serial connection

:: Requirements :
::	- kitty or putty for serial connection
::	- an esp8266 device connected by USB serial

:: Upload one to multiple files and folders by dragging and dropping them over the script.
:: Upload one to multiple files and folders by CLI.
:: Upload the content af a default folder recursively if no argument given.


:: Open a terminal at the end (y|n)
set termopen=y
:: Default folder if no argument is given
set defaultf=espup
:: Extensions which should be uploaded (only when a folder is given)
:: In default folder, every files are uploaded no matter extension
:: If extension matter, add space separated extensions i.e. *.py *.json
set extensions=*.py *.json
:: Reset the board or not (y|n)
set reset=y


call esp8266_get_serial.bat
if "%_COM%"=="" (
	call esp8266_get_serial.bat errorcom
	goto :end
)

:: Number or args
set argC=0
for %%x in (%*) do Set /A argC+=1

:: Default behavior i.e. no drag/drop, no argument
echo Uploading files...
if NOT %argC% EQU 0 goto handle_args
:: In default folder, every files are uploaded no matter extension
:: If extension matter, replace * by %extensions%
for /R %defaultf% %%a in (*) do (
	call :upload "%%a"
)
goto reset

:: Files are drag/drop or given as CLI arguments
:handle_args
if %argC% EQU 0 goto reset
set /A argC-=1
if ["%~x1"]==[""] goto handle_folder
call :upload "%1"
SHIFT
goto handle_args

:: Manage drag/drop folder (ONE folder)
:handle_folder
for /R %1 %%a in (%extensions%) do (
	call :upload "%%a"
)
SHIFT
goto handle_args

:: Upload
:upload <file>
echo     Upload %1 ...
ampy --port %_COM% put %1
echo         Done
echo.
goto :EOF

:: Reset the board
:reset
echo     Done
if NOT ["%reset%"]==["y"] goto term
echo Hard reset...
:: Following esptool reset
:: Workaround to sleep less than a 1s
set sleepVbs=..\sleep.vbs
echo WScript.Sleep WScript.Arguments(0) > %sleepVbs%

MODE %_COM% dtr=off >nul
MODE %_COM% rts=on >nul
MODE %_COM% dtr=off >nul
cscript %sleepVbs% 100 >nul
MODE %_COM% dtr=on >nul
MODE %_COM% rts=off >nul
MODE %_COM% dtr=on >nul
cscript %sleepVbs% 50 >nul
MODE %_COM% dtr=off >nul

MODE %_COM% rts=on >nul
cscript %sleepVbs% 100 >nul
MODE %_COM% rts=off >nul

del %sleepVbs%
echo     Done

:: Start terminal session
:term
echo Everything as been done
echo.
echo Byebye
if ["%termopen%"]==["y"] echo Launching the terminal
pause
if NOT ["%termopen%"]==["y"] goto end
start %termpath%\%terminal%.exe -serial %_COM% -sercfg 115200,8,n,1,N

:end
goto :EOF