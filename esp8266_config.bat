set echov=off

@echo %echov%

:: Terminal to use for serial connection
set terminal=kitty_portable
:: In case the terminal is not in PATH
set termpath=..

:: List of the string defining the USB serial (devices manager)
set USB=CH340,USB Serial Port