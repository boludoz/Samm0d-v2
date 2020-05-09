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
Func GetTrainedAndPreDetect($sMode = "Troops")
	Local $aIsTraining[0][4]
	Local $aIsPreTraining[0][4]
	Local $vDeleteSymbol
	Local $bIsPreSiegesOk = False
	Local $bBitsPreIsOk = True
	Local $iLoopW = 0
	Local $iQty
	Local $aReadyTroopsDel
	Local $sTmpBrew = ""
	Local $aTmpArray[2]

		$vDeleteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "Delete", False, True, 50)

			If IsArray($vDeleteSymbol) Then

				For $i = 0 To UBound($vDeleteSymbol) - 1
					; x = ? / y = 185
					; Pre-Brew : 0xCFCFC8
					; Brew : 0xD7AFA9
					If _ColorCheck(_GetPixelColor($vDeleteSymbol[$i][1], 185, True), Hex(0xD7AFA9, 6), 20) Then ContinueLoop
					$iQty = getMyOcrSoft($vDeleteSymbol[$i][1] - 50, 191, $vDeleteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtybrew\", "spellqtybrew", True)

					$sTmpBrew = ""

					; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6
					$sTmpBrew = Int($vDeleteSymbol[$i][1] - 50) & "," & Int($vDeleteSymbol[$i][2] + 59) & "," & Int($vDeleteSymbol[$i][1] + 12) & "," & Int($vDeleteSymbol[$i][2] - 6)

					If ($sMode = "Troops") Then
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
					Local $sIsReady = $vDeleteSymbol[$i][1] - 5 & "," & 240 & "," & $vDeleteSymbol[$i][1] + 20 & "," & 248

					Local $aMatrix[1][4] = [[$aTmpArray[0], $aTmpArray[1], False, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True]]
					_ArrayAdd($aIsTraining, $aMatrix)
				Next

			EndIf



		$vDeleteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "DeleteR", True, True, 25)

		If IsArray($vDeleteSymbol) Then

			For $i = 0 To UBound($vDeleteSymbol) - 1
				; x = ? / y = 185
				; Pre-Brew : 0xCFCFC8
				; Brew : 0xD7AFA9
				If _ColorCheck(_GetPixelColor($vDeleteSymbol[$i][1], 185, True), Hex(0xCFCFC8, 6), 20) Then ContinueLoop
				$iQty = getMyOcrSoft($vDeleteSymbol[$i][1] - 50, 191, $vDeleteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtypre\", "spellqtypre", True)

				$sTmpBrew = ""

				; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6
				$sTmpBrew = Int($vDeleteSymbol[$i][1] - 50) & "," & Int($vDeleteSymbol[$i][2] + 59) & "," & Int($vDeleteSymbol[$i][1] + 12) & "," & Int($vDeleteSymbol[$i][2] - 6)

				$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Queue\", 0, $sTmpBrew)

				$aTmpArray[1] = $iQty

				If IsArray($aReadyTroopsDel) Then
					$aTmpArray[0] = $aReadyTroopsDel[0][0]
				Else
					$aTmpArray[0] = "NotRecognized"
				EndIf

				; Name, qty, IsPre, IsReady
				Local $sIsReady = $vDeleteSymbol[$i][1] - 5 & "," & 240 & "," & $vDeleteSymbol[$i][1] + 20 & "," & 248

				Local $aMatrix[1][4] = [[$aTmpArray[0], $aTmpArray[1], True, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True ]]
				_ArrayAdd($aIsPreTraining, $aMatrix)
			Next

		EndIf
		;ExitLoop
	;WEnd
EndFunc
#cs
Func GetTrainedAndPreDetect($sMode = "Troops")

			Local $aUbi = [19, 182, 843, 263]

			$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Queue\", 0, $sTmpBrew)
			
			If ($sMode = "Troops") Then
				$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Troops\Train\", 15, $sTmpBrew)
			ElseIf ($sMode = "Spells") Then
				$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Spells\Brew\", 15, $sTmpBrew)
			EndIf
			

			Local $vDeleteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "Delete", False, True, 50)
			
			If IsArray($vDeleteSymbol) Then

				For $i = 0 To UBound($vDeleteSymbol) - 1
					Local $iQty = 0 ; qty
					Local $sMode = True ; True : pre ? False : brew
					Local $sItn = "NotRecognized" ; Item name.
					
					If _ColorCheck(_GetPixelColor($vDeleteSymbol[$i][1], 185, True), Hex(0xCFCFC8, 6), 20) Then 
						$iQty = getMyOcrSoft($vDeleteSymbol[$i][1] - 50, 191, $vDeleteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtybrew\", "spellqtybrew", True)
						$sMode = False
					Else
						$iQty = getMyOcrSoft($vDeleteSymbol[$i][1] - 50, 191, $vDeleteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtypre\", "spellqtypre", True)
						$sMode = True
					EndIf
					
					If IsArray($aReadyTroopsDel) Then $sItn = $aReadyTroopsDel[0][0]
					
					Local $sIsReady = $vDeleteSymbol[$i][1] - 5 & "," & 240 & "," & $vDeleteSymbol[$i][1] + 20 & "," & 248

					Local $aMatrix[1][4] = [[$sItn, $iQty, $sMode, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True ]]
					
					_ArrayAdd($aIsPreTraining, $aMatrix)

				Next
			
			EndIf

EndFunc

#ce