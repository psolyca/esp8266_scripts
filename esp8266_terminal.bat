:: Get configuration
call esp8266_config.bat

@echo %echov%
setlocal ENABLEDELAYEDEXPANSION
:: Little script to connect to a NodeMCU with a terminal
:: Could work with all esp8266 board with USB serial connection

:: Requirements :
::	- kitty or putty for serial connection
::	- an esp8266 device connected by USB serial



if "%1"=="" (
	call esp8266_get_serial.bat
	echo !_COM!
	if "!_COM!"=="" (
		call esp8266_get_serial.bat errorcom
		goto :end
	)
) else (
	set _COM=%1
)

start %termpath%\%terminal%.exe -serial %_COM% -sercfg 115200,8,n,1,N

:end
goto :EOF
