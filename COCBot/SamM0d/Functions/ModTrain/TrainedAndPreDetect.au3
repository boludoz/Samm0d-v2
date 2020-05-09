; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Functions
; Description ...: This file Includes several files in the current script.
; Syntax ........: #include
; Parameters ....: None
; Return values .: None
; Author ........: Boldina
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetTrainedAndPreDetect($sMode = "Troops", $bTest = False)
	Local $vDelete
	Local $bIsPreSiegesOk = False
	Local $bBitsPreIsOk = True
	Local $iLoopW = 0
	Local $iQty
	Local $aReadyTroopsDel
	Local $sTmpBrew = ""
	Local $aTmpArray[3]
	Local $aIsTraining[0][5]
	Local $iTotal = 0

	Local $sTIn = $g_sSamM0dImageLocation & "\Troops\Train\"
	
	If ($sMode = "Spells") Then
		$sTIn = $g_sSamM0dImageLocation & "\Spells\Brew\"
	EndIf


	_CaptureRegion2()
	$vDelete = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 13, "17,190,842,199", "Delete", False, True, 50)
	
	If IsArray($vDelete) Then

		For $i = UBound($vDelete) - 1 To 0 Step -1
			; x = ? / y = 185
			; Pre-Brew : 0xCFCFC8
			; Brew : 0xD7AFA9
			If _ColorCheck(_GetPixelColor($vDelete[$i][1], 185, True), Hex(0xD7AFA9, 6), 20) Then ContinueLoop
			$iQty = getMyOcrSoft($vDelete[$i][1] - 50, 191, $vDelete[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtybrew\", "spellqtybrew", True)

			$sTmpBrew = ""

			; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6
			$sTmpBrew = Int($vDelete[$i][1] - 50) & "," & Int($vDelete[$i][2] + 59) & "," & Int($vDelete[$i][1] + 12) & "," & Int($vDelete[$i][2] - 6)

			$aReadyTroopsDel = findMultipleQuick($sTIn, 1, $sTmpBrew)

			$aTmpArray[1] = $iQty
			$aTmpArray[2] = $vDelete[$i][1]
			
			If IsArray($aReadyTroopsDel) Then
				$aTmpArray[0] = $aReadyTroopsDel[0][0]
			Else
				$aTmpArray[0] = "NotRecognized"
			EndIf
			; Name, qty, IsPre, IsReady
			Local $sIsReady = $vDelete[$i][1] - 5 & "," & 240 & "," & $vDelete[$i][1] + 20 & "," & 248

			Local $aMatrix[1][5] = [[$aTmpArray[0], $aTmpArray[1], False, False, $aTmpArray[2] ]]
			_ArrayAdd($aIsTraining, $aMatrix)
			
			_ArrayDelete($vDelete, $i)
			$iTotal += 1
		Next
		
		If UBound($vDelete) - 1 > 0 Then
			For $i = UBound($vDelete) - 1 To 0 Step -1
				; x = ? / y = 185
				; Pre-Brew : 0xCFCFC8
				; Brew : 0xD7AFA9
				If _ColorCheck(_GetPixelColor($vDelete[$i][1], 185, True), Hex(0xCFCFC8, 6), 20) Then ContinueLoop
				$iQty = getMyOcrSoft($vDelete[$i][1] - 50, 191, $vDelete[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtypre\", "spellqtypre", True)
		
				$sTmpBrew = ""
		
				; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6
				$sTmpBrew = Int($vDelete[$i][1] - 50) & "," & Int($vDelete[$i][2] + 59) & "," & Int($vDelete[$i][1] + 12) & "," & Int($vDelete[$i][2] - 6)
		
				$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Queue\", 1, $sTmpBrew)
		
				$aTmpArray[1] = $iQty
		
				$aTmpArray[0] = $vDelete[$i][1]
				
				If IsArray($aReadyTroopsDel) Then
					$aTmpArray[0] = $aReadyTroopsDel[0][0]
				Else
					$aTmpArray[0] = "NotRecognized"
				EndIf
		
				; Name, qty, IsPre, IsReady
				Local $sIsReady = $vDelete[$i][1] - 5 & "," & 240 & "," & $vDelete[$i][1] + 20 & "," & 248
		
				Local $aMatrix[1][5] = [[$aTmpArray[0], $aTmpArray[1], True, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True, $aTmpArray[2] ]]
				_ArrayAdd($aIsTraining, $aMatrix)
			Next
		EndIf
	EndIf
	
	_ArraySort($aIsTraining, 0, 0, 0, 4)
	Return (UBound($aIsTraining) <> 0) ? ($aIsTraining) : (-1)

EndFunc

