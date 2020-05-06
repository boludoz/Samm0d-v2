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
	Global $aIsTraining[0][4]
	Global $aIsPreTraining[0][4]
	
	TrainedAndPreDetect($sMode)
	
	Local $aFullConcat = $aIsTraining
	_ArrayAdd($aFullConcat, $aIsPreTraining)
	If $bTest = True Then _ArrayDisplay($aFullConcat)
	Return (UBound($aFullConcat) <> 0) ? ($aFullConcat) : (-1)
EndFunc

Func TrainedAndPreDetect($sMode = "Troops")
	Local $vDeleteRedSymbol, $vDeleteWhiteSymbol
	Local $bIsPreSiegesOk = False
	Local $bBitsPreIsOk = True
	Local $iLoopW = 0
	Local $iQty
	Local $aReadyTroopsDel
	Local $sTmpBrew = ""
	Local $aTmpArray[2]
	;Local $aIsTraining[0][2], $aIsPreTraining[0][2]

	; "AI" part.
	;While 1
	;If _Sleep(Random(500,1000,1)) Then Return
		$vDeleteWhiteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "DeleteW", True, True, 25)
		
			If IsArray($vDeleteWhiteSymbol) Then

				For $i = 0 To UBound($vDeleteWhiteSymbol) - 1
					; x = ? / y = 185
					; Pre-Brew : 0xCFCFC8
					; Brew : 0xD7AFA9
					If _ColorCheck(_GetPixelColor($vDeleteWhiteSymbol[$i][1], 185, True), Hex(0xD7AFA9, 6), 20) Then ContinueLoop
					$iQty = getMyOcrSoft($vDeleteWhiteSymbol[$i][1] - 50, 191, $vDeleteWhiteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtybrew\", "spellqtybrew", True)

					$sTmpBrew = ""

					; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6
					$sTmpBrew = Int($vDeleteWhiteSymbol[$i][1] - 50) & "," & Int($vDeleteWhiteSymbol[$i][2] + 59) & "," & Int($vDeleteWhiteSymbol[$i][1] + 12) & "," & Int($vDeleteWhiteSymbol[$i][2] - 6)
					
					If ($sMode = "Train") Then
						$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Troops\Train\", 0, $sTmpBrew)
					ElseIf ($sMode = "Spells") Then
						$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Spells\Brew\", 0, $sTmpBrew)
					EndIf
					
					$aTmpArray[1] = $iQty

					If IsArray($aReadyTroopsDel) Then
						$aTmpArray[0] = $aReadyTroopsDel[0][0]
					Else
						$aTmpArray[0] = "NotRecognized"
					EndIf
					; Name, qty, IsPre, IsReady
					Local $sIsReady = $vDeleteWhiteSymbol[$i][1] - 5 & "," & 240 & "," & $vDeleteWhiteSymbol[$i][1] + 20 & "," & 248
					
					Local $aMatrix[1][4] = [[$aTmpArray[0], $aTmpArray[1], False, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True]]
					_ArrayAdd($aIsTraining, $aMatrix)
				Next

			EndIf
				


		$vDeleteRedSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "DeleteR", True, True, 25)
		
		If IsArray($vDeleteRedSymbol) Then

			For $i = 0 To UBound($vDeleteRedSymbol) - 1
				; x = ? / y = 185
				; Pre-Brew : 0xCFCFC8
				; Brew : 0xD7AFA9
				If _ColorCheck(_GetPixelColor($vDeleteRedSymbol[$i][1], 185, True), Hex(0xCFCFC8, 6), 20) Then ContinueLoop
				$iQty = getMyOcrSoft($vDeleteRedSymbol[$i][1] - 50, 191, $vDeleteRedSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtypre\", "spellqtypre", True)

				$sTmpBrew = ""

				; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6
				$sTmpBrew = Int($vDeleteRedSymbol[$i][1] - 50) & "," & Int($vDeleteRedSymbol[$i][2] + 59) & "," & Int($vDeleteRedSymbol[$i][1] + 12) & "," & Int($vDeleteRedSymbol[$i][2] - 6)

				$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Queue\", 0, $sTmpBrew)

				$aTmpArray[1] = $iQty

				If IsArray($aReadyTroopsDel) Then
					$aTmpArray[0] = $aReadyTroopsDel[0][0]
				Else
					$aTmpArray[0] = "NotRecognized"
				EndIf
				
				; Name, qty, IsPre, IsReady
				Local $sIsReady = $vDeleteRedSymbol[$i][1] - 5 & "," & 240 & "," & $vDeleteRedSymbol[$i][1] + 20 & "," & 248
                
				Local $aMatrix[1][4] = [[$aTmpArray[0], $aTmpArray[1], True, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True ]]
				_ArrayAdd($aIsPreTraining, $aMatrix)
			Next

		EndIf
		;ExitLoop
	;WEnd
EndFunc

