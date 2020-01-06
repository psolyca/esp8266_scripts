:: Get configuration
call esp8266_config.bat

@echo %echov%
setlocal ENABLEDELAYEDEXPANSION
:: Little script to manage programming session with a NodeMCU
:: Could work with all esp8266 board with USB serial connection

:: Requirements :
::	- kitty or putty for serial connection
::	- an esp8266 device connected by USB serial


:: Open a terminal at the end (y|n)
set termopen=n


call esp8266_get_serial.bat
if "!_COM!"=="" (
	call esp8266_get_serial.bat errorcom
	goto :end
)


:: Reset the board
:reset
echo Hard reset ...
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
if ["%termopen%"]==["y"] echo Launching the terminal
pause
if NOT ["%termopen%"]==["y"] goto end
start %termpath%\%terminal%.exe -serial %_COM% -sercfg 115200,8,n,1,N

:end
goto :EOF