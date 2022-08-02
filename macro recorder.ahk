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


;*************************************************
;**                                             **
;**   F4 Start or Stop Recording                **
;**   F8 Start or Stop Playback (loop forever)  **
;**   F9 Add 1 Loop    (stackable)              **
;**   F10 Add 10 Loops (stackable)              **
;**                                             **
;*************************************************




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
	
Return


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
	
Return

F9:: ; F9 to do one loop
	loopsRemaining += 1
	StartLoop()
Return

F10:: ; F10 to do 10 loop
	loopsRemaining += 10
	StartLoop()
Return



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

; mouse recording
~LButton::  
~RButton::  
~WheelUp::
~WheelDown:: 
RecordKeystroke("Mouse", A_ThisHotkey)
Return

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
~enter::
~backspace::
~up::
~down:: 
~left:: 
~right::   
~XButton1:: ; even though this is a mouse key, you have to use Send to use it so im placing it here
~XButton2:: 
~MButton::    
RecordKeystroke("Key", A_ThisHotkey)
Return




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