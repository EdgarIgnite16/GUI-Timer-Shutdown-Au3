#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author: Edgar Ignite

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
Global $MainForm = GUICreate("Computer power off program v1.0", 542, 547, -1, -1)
GUISetFont(14, 400, 0, "Segoe UI")
Global $TitleProgram = GUICtrlCreateLabel("Computer power off program", 88, 24, 354, 41)
GUICtrlSetFont(-1, 20, 400, 0, "Segoe UI")
Global $SelectOptShutdowns = GUICtrlCreateCombo("", 32, 120, 225, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Shutdown|Restart", "Shutdown")
Global $ForceShutdown = GUICtrlCreateCheckbox("Force running applications to close", 32, 168, 337, 25)
Global $SetTimeout = GUICtrlCreateCheckbox("Set the time-out period before shutdown", 32, 200, 377, 25)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $TitleSetTimeout = GUICtrlCreateLabel("Time-out: ", 40, 240, 90, 29, $SS_RIGHT)
Global $InputSetTimeout = GUICtrlCreateInput("30", 136, 240, 89, 33, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
Global $SubTitleSetTimeout = GUICtrlCreateLabel("Seconds", 232, 240, 74, 29)
Global $BtnSetTimeout = GUICtrlCreateButton("Time picker", 328, 240, 115, 33)
Global $TitleComment = GUICtrlCreateLabel("Comment:", 40, 296, 90, 29)
Global $CommentBox = GUICtrlCreateEdit("", 40, 328, 473, 113)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
Global $BtnAbort = GUICtrlCreateButton("Abort", 144, 464, 171, 49)
Global $BtnStart = GUICtrlCreateButton("Start Process", 328, 464, 171, 49)
Global $TitleOption = GUICtrlCreateLabel("Select Option Shutdown", 40, 88, 189, 27)
GUICtrlSetFont(-1, 13, 400, 0, "Segoe UI")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $SelectOptShutdowns

		Case $ForceShutdown

		Case $SetTimeout
			If GUICtrlRead($SetTimeout) == $GUI_CHECKED Then
				ToggerTimer(True)
				GUICtrlSetState($InputSetTimeout, $GUI_FOCUS)
			Else
				ToggerTimer(False)
			EndIf

		Case $InputSetTimeout

		Case $BtnSetTimeout

		Case $CommentBox

		Case $BtnAbort
			Run("shutdown -a", "", @SW_HIDE)

		Case $BtnStart
			Run(genarateCommand(), "", @SW_HIDE)
	EndSwitch
WEnd

Func ToggerTimer($enable)
	; box ẩn hay hiện thì dự trên tham số truyền vào
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
