#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
	#NoTrayIcon
	#RequireAdmin
	#include <MsgBoxConstants.au3>
	#include <WinAPIFiles.au3>

	$command="taskkill /im adb.exe /f"
	run($command)

	$command="taskkill /im MyBot.run.exe /f"
	run($command)

	$command="taskkill /im MyBot.run.MiniGui.exe /f"
	run($command)


	$command="taskkill /im MyBot.run.Watchdog.exe /f"
	run($command)


	$command="taskkill /im MyBot.run.Wmi.exe /f"
	run($command)

DirRemove ("COCBot",1)
DirRemove ("CSV",1)
DirRemove ("Help",1)
DirRemove ("images",1)
DirRemove ("imgxml",1)
DirRemove ("Languages",1)
DirRemove ("lib",1)
DirRemove ("Strategies",1)
FileDelete("CHANGELOG")
FileDelete("CHANGELOG_LANGUAGES")
FileDelete("License.txt")
FileDelete("MyBot.run Community Support Key.asc")
FileDelete("MyBot.run.au3")
FileDelete("MyBot.run.exe")
FileDelete("MyBot.run.MiniGui.au3")
FileDelete("MyBot.run.MiniGui.exe")
FileDelete("MyBot.run.MiniGui_stripped.au3")
FileDelete("MyBot.run.txt")
FileDelete("MyBot.run.version.au3")
FileDelete("MyBot.run.Watchdog.au3")
FileDelete("MyBot.run.Watchdog.exe")
FileDelete("MyBot.run.Watchdog_stripped.au3")
FileDelete("MyBot.run.Wmi.au3")
FileDelete("MyBot.run.Wmi.exe")
FileDelete("MyBot.run.Wmi_stripped.au3")
FileDelete("MyBot.run_stripped.au3")
FileDelete("README.md")

Sleep(1000)