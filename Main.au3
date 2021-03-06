#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author: Edgar Ignite

#ce ----------------------------------------------------------------------------
#Region
#AutoIt3Wrapper_Icon = Logo_Time.ico
#EndRegion

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <Date.au3>

; Main Form
#Region ### START Koda GUI section ### Form=
Global $MainForm = GUICreate("Computer power off program v1.0", 546, 548, -1, -1)
GUISetFont(14, 400, 0, "Segoe UI")
Global $TitleProgram = GUICtrlCreateLabel("Computer power off program", 96, 24, 354, 41)
GUICtrlSetFont(-1, 20, 400, 0, "Segoe UI")
Global $SelectOptShutdowns = GUICtrlCreateCombo("", 32, 120, 225, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
GUICtrlSetData(-1, "Shutdown|Restart", "Restart")
Global $ForceShutdown = GUICtrlCreateCheckbox("Force running applications to close", 32, 168, 337, 25)
Global $SetTimeout = GUICtrlCreateCheckbox("Set the time-out period before shutdown", 32, 200, 377, 25)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $TitleSetTimeout = GUICtrlCreateLabel("Time-out:", 40, 240, 90, 29, $SS_RIGHT)
Global $InputSetTimeout = GUICtrlCreateInput("60", 136, 240, 89, 33, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
Global $SubTitleSetTimeout = GUICtrlCreateLabel("Seconds", 232, 240, 74, 29)
Global $BtnSetTimeout = GUICtrlCreateButton("Time picker", 328, 240, 115, 33)
Global $TitleComment = GUICtrlCreateLabel("Comment:", 40, 296, 90, 29)
Global $CommentBox = GUICtrlCreateEdit("", 40, 328, 473, 113)
GUICtrlSetData(-1, "")
Global $BtnAbort = GUICtrlCreateButton("Abort", 144, 464, 171, 49)
Global $BtnStart = GUICtrlCreateButton("Start Process", 328, 464, 171, 49)
Global $TitleOption = GUICtrlCreateLabel("Select Option Shutdown", 40, 88, 189, 27)
GUICtrlSetFont(-1, 13, 400, 0, "Segoe UI")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Select Time Form
#Region ### START Koda GUI section ### Form=
Global $FormTimePicked = GUICreate("Select Time Picked", 442, 195, 748, 383, -1, -1, $MainForm)
GUISetFont(14, 400, 0, "Segoe UI")
Global $DateTimePicker = GUICtrlCreateDate("00:00:00", 32, 80, 386, 41)
Global $sStyle = "yyyy/MM/dd HH:mm:ss"
GUICtrlSendMsg($DateTimePicker, $DTM_SETFORMATW, 0, $sStyle)
Global $ButtonOke = GUICtrlCreateButton("OK", 32, 128, 387, 41)
Global $LableTiltle = GUICtrlCreateLabel("Select Time", 152, 24, 136, 44, $SS_CENTER)
GUICtrlSetFont(-1, 18, 400, 0, "Segoe UI")
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg(1) ; B???t ch??? ????? n??ng cao
	Switch $nMsg[0]
		Case $GUI_EVENT_CLOSE
			If $nMsg[1] == $MainForm Then
				Exit
			EndIf

			If $nMsg[1] == $FormTimePicked Then
				GUISetState(@SW_HIDE, $FormTimePicked)
			EndIf

		Case $SetTimeout
			If GUICtrlRead($SetTimeout) == $GUI_CHECKED Then
				ToggerTimer(True)
				GUICtrlSetState($InputSetTimeout, $GUI_FOCUS)
			Else
				ToggerTimer(False)
			EndIf


		Case $BtnSetTimeout
			GUISetState(@SW_SHOW, $FormTimePicked)

		Case $BtnAbort
			Run("shutdown -a", "", @SW_HIDE)
			Local $item = StringLower(GUICtrlRead($SelectOptShutdowns)) == "shutdown" ? "shutdown" : "restart"
			MsgBox(0, "Success Stop ", "The Process "  & $item & " had been stop !")

		Case $BtnStart
			Run(genarateCommand(), "", @SW_HIDE)

		Case $ButtonOke
			Local $getTimeSet = GUICtrlRead($DateTimePicker)
			Local $seconds = _DateDiff('s', _NowCalc(), $getTimeSet)

			If $seconds <= 0 Then
				MsgBox(16 + 262144, "Error", "Invalid input time" & @CRLF & "Time shutdown must be greater than the current time")
			Else
				GUICtrlSetData($InputSetTimeout, $seconds)
				Run(genarateCommand(), "", @SW_HIDE)
				GUISetState(@SW_HIDE, $FormTimePicked)
			EndIf

	EndSwitch
WEnd

Func ToggerTimer($enable)
	; box ???n hay hi???n th?? d??? tr??n tham s??? truy???n v??o
	Local $val = $enable ? $GUI_ENABLE : $GUI_DISABLE

	GUICtrlSetState($TitleSetTimeout, $val)
	GUICtrlSetState($InputSetTimeout, $val)
	GUICtrlSetState($SubTitleSetTimeout, $val)
	GUICtrlSetState($BtnSetTimeout, $val)
EndFunc

Func genarateCommand()
	Local $cmd = "shutdown"

	; shutdown or restart
	$cmd &= ' ' & (StringLower(GUICtrlRead($SelectOptShutdowns)) == "shutdown" ? "-s" : "-r")

	; force or not
	If GUICtrlRead($ForceShutdown) == $GUI_CHECKED Then
		$cmd &= ' -f'
	EndIf

	; Time-out
	If GUICtrlRead($SetTimeout) == $GUI_CHECKED Then
		Local $time = GUICtrlRead($InputSetTimeout)

		If Not $time Then
			$time = 30
			GUICtrlSetData($InputSetTimeout, 30)
		EndIf

		; check default value
		$cmd &= ' -t ' & $time
	EndIf

	; comment
	Local $comment = GUICtrlRead($CommentBox)
	If $comment Then
		$cmd &= ' -c "Conent comment: ' & $comment & @CRLF & 'Time remaining ' & $time &' seconds !"'
	EndIf

	return $cmd
EndFunc
