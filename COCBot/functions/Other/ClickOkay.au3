; #FUNCTION# ====================================================================================================================
; Name ..........: ClickOkay
; Description ...: checks for window with "Okay" button, and clicks it
; Syntax ........: ClickOkay($FeatureName)
; Parameters ....: $FeatureName         - [optional] String with name of feature calling. Default is "Okay".
; ...............; $bCheckOneTime       - (optional) Boolean flag - only checks for Okay button once
; Return values .: Returns True if button found, if button not found, then returns False and sets @error = 1
; Author ........: MonkeyHunter (2015-12)
;~ ; Modified ......: TFKNazGul (12/11/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ClickOkay($FeatureName = "Okay", $bCheckOneTime = False)
	Local $i = 0
	If _Sleep($DELAYSPECIALCLICK1) Then Return False ; Wait for Okay button window
	While 1 ; Wait for window with Okay Button
		Local $offColors[3][3] = [[0xE6FC97, 1, 0], [0xE6FC97, 2, 0], [0xE6FC97, 3, 0]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Local $ButtonPixel = _MultiPixelSearch(496, 257, 560, 475, 1, 1, Hex(0xE6FC97, 6), $offColors, 30)
		;If $g_bDebugSetlog Then SetDebugLog($FeatureName & " btn chk-#1: " & _GetPixelColor(441, 374, True) & ", #2: " & _GetPixelColor(441 + 144, 374 + $g_iMidOffsetY, True) & ", #3: " & _GetPixelColor(441 + 54, 374 + 17 + $g_iMidOffsetY, True) & ", #4: " & _GetPixelColor(441 + 54, 374 + 10 + $g_iMidOffsetY, True), $COLOR_DEBUG)
		If IsArray($ButtonPixel) Then
			If $g_bDebugSetlog Then
				SetDebugLog("ButtonPixelLocation = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
				SetDebugLog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 10, True), $COLOR_DEBUG)
			EndIf
			PureClick($ButtonPixel[0], $ButtonPixel[1] + 25, 2, 50, "#0117") ; Click Okay Button
			If _Sleep(500) Then Return
			ExitLoop
		EndIf
		If $bCheckOneTime Then Return False ; enable external control of loop count or follow on actions, return false if not clicked
		If $i > 5 Then
			SetLog("Can not find button for " & $FeatureName & ", giving up", $COLOR_ERROR)
			If $g_bDebugImageSave Then DebugImageSave($FeatureName & "_ButtonCheck_")
			SetError(1, @extended, False)
			Return
		EndIf
		$i += 1
		If _Sleep($DELAYSPECIALCLICK2) Then Return False ; improve pause button response
	WEnd
	Return True
EndFunc   ;==>ClickOkay
