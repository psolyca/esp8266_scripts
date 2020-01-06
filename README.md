# ESP8266 Windows Scripts

These scripts are usefull on Windows for :

* Retrieving a firmware from a remote server or VM
* Uploading a firmware to a esp8266 board
* Get the serial port of a esp8266 board
* Hard resetting a esp8266 board (Not working every time)
* Openning a terminal to a esp8266 board

These scripts have been tested on a NodeMCU v3 board.

## Prerequisites

* Kitty or Putty for the serial communication
* pscp (from putty) or scp (from OpenSSH) for downloading file(s) from remote
server or VM


## Configuration

Change following values if needed.

### In esp8266_config.bat

* Terminal to use for serial connection (kitty_portable, kitty  or putty or...)  
`terminal=kitty_portable`

* In case the terminal is not in PATH  
  If in the same path as the script '.'  
  If one level up '..'  
`termpath=..`

* Check your driver in Device manager when the board is connected but `USB`
variable should be right for most users.

### In esp8266_upload_files.bat

* Open a terminal at the end (y|n)  
`termopen=y`

* Default folder if no argument is given  
`defaultf=espup`

* Extensions which should be uploaded (only when a folder is given)  
  In default folder, every files are uploaded no matter extension  
  If extension matter, add space separated extensions i.e. *.py *.json  
`extensions=*.py *.json`

* Reset the board or not (y|n)  
`reset=y`

### In esp8266_flash_firmware.bat

* Local folder to download the firmware  
`localf=.`

* Remote host address  
`host=dev.myhost.com`

* Remote host folder where `file` has been build  
`remotef=/home/dev/firmware_repo`

* Name of the firmware (should be fine for every body)  
`file=firmware-combined.bin`

* User who connect to the remote host  
`user=dev`

* Application used to retrive the firmware (pscp/scp/...)  
  Adding a publickey and a ssh-agent is recommended  
`sshcp=scp`

* Set default behavior to avoid question  
`download=`  
`erase=`  
`flash=y`  

  - y : do it
  - n : do not do it
  - empty : ask
