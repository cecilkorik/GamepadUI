#SingleInstance Ignore
;FormatTime,TS,,yyyy-MM-dd-HH:mm:ss
;FileAppend,%TS%> -- SCRIPT STARTUP -- `n,C:\GamepadUI\debug.txt 


Gui,Bg:New
Gui,Bg:Color,Black,000000
Gui,Bg:-Caption +AlwaysOnTop E0x08000000
Gui,Bg:+hwndGuiBg
Gui,Bg:Show, h1080 w1920 x0 y0
Gui,Bg:Add, ActiveX, x0 y0 w1920 h1080 vWB, Shell.Explorer
WB.silent := true ;Surpress JS Error boxes
WB.Navigate("file:///c:/GamepadUI/bg_display.html")

repeats := 0
menuitem := 0
menuitem_skipmax := 7
menuitem_max := 7
shutting_down := 0
og_menu := 0
RepeatDelay := -1
RepeatDelay2 := -1
Setting_RepeatDelayPolling := 125
Setting_RepeatDelayFirst := 350
Setting_RepeatDelayAgain := 140

SetTimer, WatchJoy, %Setting_RepeatDelayPolling%
GoSub redraw_menu

Esc::
	Gosub really_exit
return

really_exit:
	Gui,Main:Destroy
	Gui,Bg:Destroy
	exitapp
return



menu_prev:
	menuitem--
	if( menuitem < 0 )
	{
		menuitem := menuitem_max
	}
	GoSub redraw_menu
return


menu_next:
	menuitem++
	if( menuitem >= menuitem_max )
	{
		menuitem := 0
	}
	GoSub redraw_menu
return


menu_click:
	if ( shutting_down == 1 ) { 
		return
	}
	
	if ( og_menu == 1 )
	{
		
	}
	else
	{

		if ( menuitem == 0 ) {
			GoSub load_screen
			Run, C:\Retroarch\Retroarch.exe
			GoSub load_screen_finish
		}
		if ( menuitem == 1 ) {
			GoSub load_screen
			Run, C:\Program Files (x86)\Steam\Steam.exe -start steam://open/bigpicture/library
			GoSub load_screen_finish
		}
		if ( menuitem == 2 ) {
			; Other Games
			og_menu := 1
			GoSub redraw_menu
		}
		if ( menuitem == 3 ) {
			GoSub load_screen
			Run, c:\GamepadUI\Chromium\bin\chrome.exe https://www.cravetv.ca/ --start-fullscreen
			GoSub load_screen_finish
		}
		if ( menuitem == 4 ) {
			GoSub load_screen
			Run, C:\Kodi\Kodi.exe
			GoSub load_screen_finish
		}
		if ( menuitem == 5 ) {
			Gosub really_exit
		}
		if ( menuitem == 6 ) {
			Gosub really_exit
		}
		if ( menuitem == 7 ) {
			; restart system
			Shutdown, 6
		}
	}

return

load_screen:
	Gui,Bg:-AlwaysOnTop
	Gui,Main:Destroy
	Gui,Main:New
	Gui,Main:Color,0E0A09
	Gui,Main:-AlwaysOnTop +OwnerBg
	Gui,Main:+hwndGuiMain
	Gui,Main:Show, h1080 w1920 x0 y0
	WinSet, TransColor, 0E0A09, ahk_id %GuiMain%
	Gui,Main:-Caption
	Gui,Main:Font,Tahoma s46
	
	;MsgBox, yval = %yval% = %menuitem% = %menuitem_max%	
	
	Gui,Main:Add, Text,cWhite w550 x650 y400,Please Wait! Loading ...
	shutting_down := 1
	SetTimer, cleanup_timer, 100
return

load_screen_finish:
	sleep 15000
	Gosub really_exit

return

cleanup_timer:
	WinGetTitle, Title, A	

	if ( Title != "GamepadUI.ahk" ) {
		Gosub really_exit
	}
return

redraw_menu:
	if ( shutting_down == 1 ) {
		return
	}

	yval := 550 + (menuitem * 50)
	Gui,Main:Destroy
	Gui,Main:New
	Gui,Main:Color,0E0A09
	Gui,Main:+AlwaysOnTop +OwnerBg
	Gui,Main:+hwndGuiMain
	Gui,Main:Show, h1080 w1920 x0 y0
	WinSet, TransColor, 0E0A09, ahk_id %GuiMain%
	Gui,Main:-Caption
	Gui,Main:Font,Tahoma s28
	
	;MsgBox, yval = %yval% = %menuitem% = %menuitem_max%
	Gui,Main:Add, Text,cWhite w350 x1180 y%yval% 0x12,
	
	if ( og_menu == 1 ) {
		Gui,Main:Add, Text,cWhite w550 x1200 y550,Fortnite
		Gui,Main:Add, Text,cWhite w550 x1200 y600,Minecraft
		Gui,Main:Add, Text,cWhite w550 x1200 y650,Terraria
		Gui,Main:Add, Text,cWhite w550 x1200 y700,Other Games
		Gui,Main:Add, Text,cWhite w550 x1200 y750,Other Games
		Gui,Main:Add, Text,cWhite w550 x1200 y800,Exit and Resume
		Gui,Main:Add, Text,cWhite w550 x1200 y850,Exit to Desktop
		Gui,Main:Add, Text,cWhite w550 x1200 y900,Return To Main Menu	
	}
	else
	{
		Gui,Main:Add, Text,cWhite w550 x1200 y550,Retro Console
		Gui,Main:Add, Text,cWhite w550 x1200 y600,Steam Library
		Gui,Main:Add, Text,cWhite w550 x1200 y650,Other Games
		Gui,Main:Add, Text,cWhite w550 x1200 y700,CraveTV / HBO
		Gui,Main:Add, Text,cWhite w550 x1200 y750,Kodi Media Player
		Gui,Main:Add, Text,cWhite w550 x1200 y800,Exit and Resume
		Gui,Main:Add, Text,cWhite w550 x1200 y850,Exit to Desktop
		Gui,Main:Add, Text,cWhite w550 x1200 y900,Reboot
	}
return



WatchJoy:
	delayed := 0
	GetKeyState, POV, JoyPOV  ; Get position of the POV control.
	GetKeyState, POV2, 2JoyPOV  ; Get position of the POV control.
	PovDirPrev = %PovDir%  ; Prev now holds the key that was down before (if any).
	PovDir2Prev = %Pov2Dir%  ; Prev now holds the key that was down before (if any).

	if ( ( POV < 0 ) && ( POV2 < 0 ) ) {
		return
	}
	
	FormatTime,TS,,yyyy-MM-dd-HH:mm:ss
	;FileAppend,%TS%> Pov=%POV% LastPov=%PovDirPrev%`n,C:\GamepadUI\debug.txt 
	; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
	; To support them all, use a range:
	if POV < 0   ; No angle to report
		PovDir = 0
	else if POV > 27000
		PovDir = Up
	else if POV between 0 and 8999
		PovDir = Up
	else if POV between 9001 and 26999 
		PovDir = Down
	else
		PovDir = 0

	if ( PovDir != 0 ) {
		if ( PovDir == PovDirPrev ) ; The correct key is already down (or no key is needed).
		{
			if ( RepeatDelay > 0 ) {
				RepeatDelay := RepeatDelay - Setting_RepeatDelayPolling
				;FileAppend,%TS%> Waiting For Repeat=%repeats% RD=%RepeatDelay% POV=%POV% PovDir=%PovDir% LastPovDir=%PovDirPrev%`n,C:\GamepadUI\debug.txt 

				delayed := 1
			}
			else
			{

				repeats++
				;FileAppend,%TS%> Repeated=%repeats% RD=%RepeatDelay% POV=%POV% PovDir=%PovDir% LastPovDir=%PovDirPrev%`n,C:\GamepadUI\debug.txt 
				RepeatDelay := Setting_RepeatDelayAgain
				delayed := 0
			}
		}
		else
		{
			
			; This is the first time this key is pressed, so we wait longer before repeating
			RepeatDelay := Setting_RepeatDelayFirst
			repeats := 0
			delayed := 0
			;FileAppend,%TS%> First Press=%repeats% RD=%RepeatDelay% POV=%POV% PovDir=%PovDir% LastPovDir=%PovDirPrev%`n,C:\GamepadUI\debug.txt 
		}
	}

	PovDir2Prev = %Pov2Dir%  ; Prev now holds the key that was down before (if any).

	; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
	; To support them all, use a range:
	if POV2 < 0   ; No angle to report
		Pov2Dir = 0
	else if POV2 > 27000
		Pov2Dir = Up
	else if POV2 between 0 and 8999
		Pov2Dir = Up
	else if POV2 between 9001 and 26999 
		Pov2Dir = Down
	else
		Pov2Dir = 0

	if ( Pov2Dir != 0 ) {
		if ( Pov2Dir == PovDir2Prev )  ; The correct key is already down (or no key is needed).
		{
			if ( RepeatDelay2 > 0 ) {
				RepeatDelay2 := RepeatDelay2 - Setting_RepeatDelayPolling

				return  ; Do nothing.
			}
			else
			{
				RepeatDelay2 := Setting_RepeatDelayAgain
			}
		}
		else
		{
			; This is the first time this key is pressed, so we wait longer before repeating
			RepeatDelay2 := Setting_RepeatDelayFirst
		}
	}
	
	if ( delayed == 1 ) {
		return
	}
	;FileAppend,%TS%> Repeating=%repeats% RD=%RepeatDelay% POV=%POV% PovDir=%PovDir% LastPovDir=%PovDirPrev%`n,C:\GamepadUI\debug.txt 

	
	if ( ( PovDir == 0 ) && ( Pov2Dir == 0 ) ) {
		return
	}

	if ( ( PovDir == "Up" ) || ( Pov2Dir == "Up" ) ) {
		GoSub menu_prev
	}
	
	if ( ( PovDir == "Down" ) || ( Pov2Dir == "Down" ) ) {
		GoSub menu_next
	}
return

Joy1::
	GoSub menu_click
return

2Joy1::
	GoSub menu_click
return

Joy2::
	GoSub menu_click
return

2Joy2::
	GoSub menu_click
return
	
Up::
	GoSub menu_prev
return

Down::
	GoSub menu_next
return

Enter::
	GoSub menu_click
return
