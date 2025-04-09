SetBatchLines, -1
#MaxHotkeysPerInterval 1000
#UseHook
#Persistent
#SingleInstance Force

wLocked := false
dLocked := false
upLocked := false
leftLocked := false

wDown := false
dDown := false
upDown := false
leftDown := false

Gui, +AlwaysOnTop +ToolWindow -SysMenu
Gui, Font, s10, Segoe UI
Gui, Add, Text, vStatusText, MuSe-R HardMode is waiting for Muse Dash...
Gui, Add, Button, gExitScript, Exit
Gui, Show, NoActivate, MuSe-R HardMode
return

#IfWinActive ahk_exe MuseDash.exe

*w::
    if (wLocked)
        return
    wDown := true
    Send, {Blind}{w Down}
return

*w up::
    if (wDown) {
        wDown := false
        Send, {Blind}{w Up}
        SetTimer, LockW, -10
    }
return

LockW:
    wLocked := true
    dLocked := false
    UpdateGUI()
return

*d::
    if (dLocked)
        return
    dDown := true
    Send, {Blind}{d Down}
return

*d up::
    if (dDown) {
        dDown := false
        Send, {Blind}{d Up}
        SetTimer, LockD, -10
    }
return

LockD:
    dLocked := true
    wLocked := false
    UpdateGUI()
return

*Up::
    if (upLocked)
        return
    upDown := true
    Send, {Blind}{Up Down}
return

*Up up::
    if (upDown) {
        upDown := false
        Send, {Blind}{Up Up}
        SetTimer, LockUp, -10
    }
return

LockUp:
    upLocked := true
    leftLocked := false
    UpdateGUI()
return

*Left:: 
    if (leftLocked)
        return
    leftDown := true
    Send, {Blind}{Left Down}
return

*Left up::
    if (leftDown) {
        leftDown := false
        Send, {Blind}{Left Up}
        SetTimer, LockLeft, -10
    }
return

LockLeft:
    leftLocked := true
    upLocked := false
    UpdateGUI()
return

#IfWinActive

UpdateGUI() {
    global wLocked, dLocked, upLocked, leftLocked
    if (WinActive("ahk_exe MuseDash.exe")) {
        status := "MuSe-R HardMode Active`n"
        status .= "W: " . (wLocked ? "Locked" : "Active") . "`n"
        status .= "D: " . (dLocked ? "Locked" : "Active") . "`n"
        status .= "Up: " . (upLocked ? "Locked" : "Active") . "`n"
        status .= "Left: " . (leftLocked ? "Locked" : "Active")
    } else {
        status := "MuSe-R HardMode is waiting for Muse Dash..."
    }
    GuiControl,, StatusText, %status%
}

ResetLocks() {
    global wLocked, dLocked, upLocked, leftLocked, wDown, dDown, upDown, leftDown
    if (wDown) {
        Send, {Blind}{w Up}
        wDown := false
    }
    if (dDown) {
        Send, {Blind}{d Up}
        dDown := false
    }
    if (upDown) {
        Send, {Blind}{Up Up}
        upDown := false
    }
    if (leftDown) {
        Send, {Blind}{Left Up}
        leftDown := false
    }
    wLocked := false
    dLocked := false
    upLocked := false
    leftLocked := false
}

SetTimer, CheckActiveWindow, 100
CheckActiveWindow:
    if (WinActive("ahk_exe MuseDash.exe")) {
        UpdateGUI()
    } else {
        ResetLocks()
        UpdateGUI()
    }
return

ExitScript:
GuiClose:
    ExitApp
