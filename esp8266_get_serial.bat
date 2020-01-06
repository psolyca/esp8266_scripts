:: Get configuration
call esp8266_config.bat

@echo %echov%
:: Little script to manage serial port

:: Requirements :
::	- a NodeMCU connected by serial USB



echo Get serial port...
call :get_serial "%USB%"
goto find_serial

:: Search for the used COM port
:get_serial <USB list>
setlocal EnableDelayedExpansion
for /F "tokens=1* delims=," %%a in ("%~1") do (
	call :parse "%%a"
	echo !num!|findstr /xr "[1-9][0-9]* 0" >nul && (
		set _COM=COM!num!
	) || (
		if NOT "%%b"=="" call :get_serial "%%b"
	)
)
endlocal & set _COM=%_COM%
goto :EOF

:parse <str>
setlocal
for /F "tokens=1* delims==" %%I in ('wmic path win32_pnpentity get caption /format:list ^| find %1') do set str=%%J
set num=%str:*(COM=%
set num=%num:)=%
endlocal & set num=%num%
goto :EOF

:find_serial
echo     Port is %_COM%
echo.
:: Close previous session to avoid unavailable COM port
echo Close %terminal%
::wmic Path win32_process Where "Caption Like '%terminal%.exe'" call Terminate >nul
:: ToDo : Search for putty in task list
for /F "tokens=1* delims=: " %%I in ('tasklist /FI "WINDOWTITLE eq %_COM% - Kitty" /FO LIST ^| findstr "PID"') do set _PID=%%J
if NOT "%_PID%"=="" taskkill /PID %_PID%
goto :EOF

:errorcom
echo No COM port available !
echo Is the USB cable connected ?
echo.
pause
goto :EOF