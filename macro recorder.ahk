#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;***********************************************
;**                                           **
;**  Keyboard and Mouse Recorder              **
;**  created by Max Johnson                   **
;**                                           **
;***********************************************

; for similar scripts check out garath's MoRe script or AHK Script Writer

global keystrokeList := []
global mouseXList := []
global mouseYList := []
global timingList := []
global characterList := []
global isRecording := false
global isPlayingBack := false
global loopsRemaining := 0
global mostRecentActionTime


;*********BASIC CONTROLS**************************
;**                                             **
;**   F4 Start or Stop Recording                **
;**   F8 Start or Stop Playback (loop forever)  **
;**                                             **
;*************************************************



;*********NON-INFINITE LOOPS********************************
;**                                                       **
;**   Any of these will start playback and add loops      **
;**   Hit F8 to stop playback and clear remaining loops   **
;**   Example: F10 twice will loop 20 times then stop     **
;**                                                       **
;**   F9 Add 1 Loop                                       **
;**   F10 Add 10 Loops                                    **
;**   F11 Add 100 Loops                                   **
;**   F12 Add 1000 Loops                                  **
;**                                                       **
;***********************************************************



;*******ADVANCED CONTROLS********************************
;**                                                    **
;**   windows+r to reload script                       **
;**   windows+q to quit                                **
;**   Press windows+P to pause/unpause                 **
;**   F3 while recording to move mouse only (no click) **
;**                                                    **
;********************************************************


#r::Reload ; windows+r to reload script

#q::ExitApp ; windows+q to quit

#p::Pause  ; Press windows+P to pause. Press it again to resume.

F4:: ; F4 to start or stop recording
	
	isRecording := !isRecording
	isPlayingBack := false
	
	if (isRecording)
	{
		SoundPlay *-1 ; A beep to confirm program is active
		mostRecentActionTime := A_TickCount
		
		; erase the arrays
		keystrokeList := []
		mouseXList := []
		mouseYList := []
		timingList := []
		characterList := []
	}else{
		elapsedtime := A_TickCount - mostRecentActionTime
		timingList[1] := (elapsedtime) ; set the first timing to the stop record button, to make loops smoother
	}
	
return




F8:: ; F8 to start or stop playback

	if(loopsRemaining = 0){
	loopsRemaining = 100000000000000
	}
	
	isRecording := false
	isPlayingBack := !isPlayingBack
	
	if(isPlayingBack = true){
	StartLoop()
	}else{
	EndLoop()
	}
	
return

F9:: ; F9 to add one loop
	loopsRemaining += 1
	StartLoop()
return

F10:: ; F10 to add 10 loops
	loopsRemaining += 10
	StartLoop()
return

F11:: ; F11 to add 100 loops
	loopsRemaining += 100
	StartLoop()
return

F12:: ; F12 to add 1000 loops
	loopsRemaining += 1000
	StartLoop()
return

StartLoop(){

	isRecording := false
	isPlayingBack := true
	SetTimer, MoveToAnotherThread, 1
	
}

EndLoop(){

	isRecording := false
	isPlayingBack := false
	loopsRemaining = 0
	SetTimer, MoveToAnotherThread, Off

}



MoveToAnotherThread:
	LoopThroughList()
return

LoopThroughList() {

	outer:
	while (loopsRemaining > 0)
    {
			
			
		for index, element in keystrokeList ; Enumeration is the recommended approach in most cases.
		{
			
			clickType := keystrokeList[a_index]
			xposRecording := mouseXList[a_index]
			yposRecording := mouseYList[a_index]
			timingRecording := timingList[a_index]
			characterRecording := characterList[a_index]
			characterRecordingModified := StrReplace(characterRecording, "~", "") ; get rid of the ~
			
			sleep, %timingRecording% ; (wait for correct amount of time) 
			
			if(isPlayingBack = false){
			break outer
			}
			
			; MsgBox, % characterRecordingModified ; useful for debugging
			
			
			MouseMove, %xposRecording%, %yposRecording% ; always move the mouse
			sleep, 1 ; some programs need a bit of "hover" to register an interaction
			
			if(clickType = "Mouse"){
			Click, %xposRecording% %yposRecording% %characterRecordingModified%
			}
			
			if(clickType = "Key"){
			
				if(StrLen(characterRecordingModified) > 1){
					Send, {%characterRecordingModified%}
				}else{
					Send, %characterRecordingModified%
				}
			}
		}	
		loopsRemaining --
	}
	EndLoop()
}



; hover recording, to move mouse to a position without clicking
F3::  
RecordKeystroke("Hover", A_ThisHotkey)
return

; mouse recording
~LButton::  
~RButton::  
~WheelUp::
~WheelDown:: 
RecordKeystroke("Mouse", A_ThisHotkey)
return

; The keyboard. I couldn't find a more elegant way to do this.
~a::
~b::
~c::
~d:: 
~e:: 
~f:: 
~g:: 
~h:: 
~i:: 
~j:: 
~k:: 
~l:: 
~m:: 
~n:: 
~o:: 
~p:: 
~q:: 
~r:: 
~s:: 
~t:: 
~u:: 
~v:: 
~w:: 
~x:: 
~y:: 
~z::
~0::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~,:: 
~.:: 
~/:: 
~;:: 
~':: 
~[:: 
~]:: 
~\::  
~-:: 
~=:: 
~`::   
~enter::
~backspace::
~up::
~down:: 
~left:: 
~right::
~Escape::
~Tab::
~Space::
~CapsLock::
~ScrollLock::
~Delete::
~Insert::
~Home::
~End::
~PgUp::
~PgDn::
~Numpad0::
~Numpad1::
~Numpad2::
~Numpad3::
~Numpad4::
~Numpad5::
~Numpad6::
~Numpad7::
~Numpad8::
~Numpad9::
~NumpadDot::
~NumLock::
~NumpadDiv::
~NumpadMult::
~NumpadAdd::
~NumpadSub::
~NumpadEnter::
~XButton1:: ; even though this is a mouse key, you have to use Send to use it so im placing it here
~XButton2:: 
~MButton::    
RecordKeystroke("Key", A_ThisHotkey)
return




; the function that actually records everything
RecordKeystroke(Keystroke, Character) {

SetMouseDelay, 0
SetKeyDelay, 0

if (isRecording){
SoundPlay *-1 
keystrokeList.Push(Keystroke) ; add keystroke to list
characterList.Push(Character) ; add keystroke to list

MouseGetPos, xpos, ypos 
mouseXList.Push(xpos) ; add position to list
mouseYList.Push(ypos) ; add position to list

elapsedtime := A_TickCount - mostRecentActionTime
timingList.Push(elapsedtime) ; add timing to list
mostRecentActionTime := A_TickCount 

}
}