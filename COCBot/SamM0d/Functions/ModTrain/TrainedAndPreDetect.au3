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

			Local $aReady
			Local $aIsPreTraining[0][4]
			Local $aUbi = [19, 182, 843, 263]

			Local $vDeleteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "Delete", False, True, 50)

			If IsArray($vDeleteSymbol) Then

			Local $aItems = findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Queue\", 15, $aUbi)

			If IsArray($aItems) Then
				If ($sMode = "Troops") Then
					$aReady = findMultipleQuick($g_sSamM0dImageLocation & "\Troops\Train\", 15, $aUbi)
				ElseIf ($sMode = "Spells") Then
					$aReady = findMultipleQuick($g_sSamM0dImageLocation & "\Spells\Brew\", 15, $aUbi)
				EndIf
				If IsArray($aReady) Then _ArrayAdd($aItems, $aReady)
			EndIf

			For $i = 0 To UBound($vDeleteSymbol) - 1
				Local $iQty = 0 ; qty
				Local $bMode = True ; True : pre ? False : brew
				Local $sItn = "NotRecognized" ; Item name.

				If _ColorCheck(_GetPixelColor($vDeleteSymbol[$i][1], 185, True), Hex(0xCFCFC8, 6), 20) Then
					$iQty = getMyOcrSoft($vDeleteSymbol[$i][1] - 50, 191, $vDeleteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtybrew\", "spellqtybrew", True)
					$bMode = False
				Else
					$iQty = getMyOcrSoft($vDeleteSymbol[$i][1] - 50, 191, $vDeleteSymbol[$i][1] + 12, 191 + 17, $g_sSamM0dImageLocation & "\OCR\spellqtypre\", "spellqtypre", True)
					$bMode = True
				EndIf

				If IsArray($aItems) Then
					For $i2 = UBound($aItems) -1 To 0 Step -1
						If Int($vDeleteSymbol[$i][1] - 50) < Int($aItems[$i2][1]) And Int($vDeleteSymbol[$i][1] + 12) > Int($aItems[$i2][1]) Then
							$sItn = $aItems[$i2][0]
							_ArrayDelete($aItems, $i2)
						EndIf
					Next
				EndIf

				Local $sIsReady = $vDeleteSymbol[$i][1] - 5 & "," & 240 & "," & $vDeleteSymbol[$i][1] + 20 & "," & 248

				Local $aMatrix[1][4] = [[$sItn, $iQty, $bMode, IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\" & $sMode & "\Ready\", 1, $sIsReady)) = True ]]

				_ArrayAdd($aIsPreTraining, $aMatrix)

			Next

		EndIf
		
		Return IsArray($aIsPreTraining) ? ($aIsPreTraining): (-1)
EndFunc

