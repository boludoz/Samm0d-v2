
; #FUNCTION# ====================================================================================================================
; Name ..........: MyTrainClick
; Description ...: Clicks in troop training window
; Syntax ........: MyTrainClick($TroopButton, $iTimes, $iSpeed, $sdebugtxt="")
; Parameters ....: $TroopButton         - base on HLFClick button type
;                  $iTimes              - Number fo times to cliok
;                  $iSpeed              - Wait time after click
;				   $sdebugtxt		    - String with click debug text
; Return values .: None
; Author ........: Samkie (23 Feb 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func findMultipleQuick($sDirectory, $iQuantity2Match = 0, $saiArea2SearchOri = "0,0,860,732", $sOnlyFind = Default, $bExactFind = False, $bForceCapture = True, $iDistance2check = 25, $bDebugLog = False, $iLevel = 1,  $iMaxLevel = 1000)
	FuncEnter(findMultipleQuick)
	Local $sSearchDiamond = IsArray($saiArea2SearchOri) ? GetDiamondFromArray($saiArea2SearchOri) : GetDiamondFromRect($saiArea2SearchOri)
	Local $aResult = findMultiple($sDirectory, $sSearchDiamond, $sSearchDiamond, $iLevel, $iMaxLevel, $iQuantity2Match, "objectname,objectlevel,objectpoints", $bForceCapture)
	If Not IsArray($aResult) Then Return -1

	Local $iCount = 0

	; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
	Local $aAllResults[0][4]

	Local $aArrays = "", $aCoords, $aCommaCoord

	For $i = 0 To UBound($aResult) - 1
		$aArrays = $aResult[$i] ; should be return objectname,objectpoints,objectlevel
		$aCoords = StringSplit($aArrays[2], "|", 2)
		For $iCoords = 0 To UBound($aCoords) - 1
			$aCommaCoord = StringSplit($aCoords[$iCoords], ",", 2)

			If $sOnlyFind <> Default And $sOnlyFind <> "" Then
				If $bExactFind Then
					If StringCompare($sOnlyFind, $aArrays[0]) <> 0 Then ContinueLoop
				ElseIf Not $bExactFind Then
					If StringInStr($aArrays[0], $sOnlyFind) = 0 Then ContinueLoop
				EndIf
			EndIf

			; Inspired in Chilly-chill
			Local $aTmpResults[1][4] = [[$aArrays[0], Int($aCommaCoord[0]), Int($aCommaCoord[1]), Int($aArrays[1])]]
			If $iCount >= $iQuantity2Match And Not $iQuantity2Match = 0 Then ContinueLoop
			_ArrayAdd($aAllResults, $aTmpResults)
			$iCount += 1
		Next
	Next

	If $iDistance2check > 0 And UBound($aAllResults) > 0 Then
		; Sort by X axis
		_ArraySort($aAllResults, 0, 0, 0, 1)

		; Distance in pixels to check if is a duplicated detection , for deploy point will be 5
		Local $iD2Check = $iDistance2check

		; check if is a double Detection, near in 10px
		For $i = 0 To UBound($aAllResults) - 1
			If $i > UBound($aAllResults) - 1 Then ExitLoop
			Local $LastCoordinate[4] = [$aAllResults[$i][0], $aAllResults[$i][1], $aAllResults[$i][2], $aAllResults[$i][3]]
			SetDebugLog("Coordinate to Check: " & _ArrayToString($LastCoordinate))
			If UBound($aAllResults) > 1 Then
				For $j = 0 To UBound($aAllResults) - 1
					If $j > UBound($aAllResults) - 1 Then ExitLoop
					Local $SingleCoordinate[4] = [$aAllResults[$j][0], $aAllResults[$j][1], $aAllResults[$j][2], $aAllResults[$j][3]]
					If $LastCoordinate[1] <> $SingleCoordinate[1] Or $LastCoordinate[2] <> $SingleCoordinate[2] Then
						If $SingleCoordinate[1] < $LastCoordinate[1] + $iD2Check And $SingleCoordinate[1] > $LastCoordinate[1] - $iD2Check Then
							_ArrayDelete($aAllResults, $j)
						EndIf
					Else
						If $LastCoordinate[1] = $SingleCoordinate[1] And $LastCoordinate[2] = $SingleCoordinate[2] And $LastCoordinate[3] <> $SingleCoordinate[3] Then
							_ArrayDelete($aAllResults, $j)
						EndIf
					EndIf
				Next
			EndIf
		Next
	EndIf

	Return (UBound($aAllResults) > 0) ? ($aAllResults) : (-1)
EndFunc   ;==>findMultipleQuick

Func TestLocateTroopButton($sTroopB = "Giant", $bIsBrewSpell = False)
	Local $iSpace = 5
	Local $b = LocateTroopButton($iSpace, $sTroopB, $bIsBrewSpell)
	SetLog($g_iTroopButtonX & " " & $g_iTroopButtonY & " " & $iSpace & " " & $b)
EndFunc   ;==>TestLocateTroopButton

Func LocateTroopButton(ByRef $iSpace, $sTroopButton, $bIsBrewSpell = False)
	Local $aRegionForScan = "26,411,840,536"
	Local $aButtonXY
	
	For $iB = 0 To 1
		
		If Not IsTrainPage() Then Return False

		; Capture troops train region.
		$aButtonXY = findMultipleQuick($g_sSamM0dImageLocation & "\TrainButtons\", 1, $aRegionForScan, $sTroopButton, False)
		
		If not $bIsBrewSpell Then
			For $iC = 0 To UBound($MyTroops) - 1
				If $aButtonXY = -1 Then ExitLoop
				
				If (StringInStr($aButtonXY[0][0], $MyTroops[$iC][0]) <> 0) Then
					$iSpace = (StringInStr($aButtonXY[0][0], "Super") <> 0) ? ($MyTroops[$iC][5]) : ($MyTroops[$iC][6])
				EndIf
			Next
		EndIf
		
		; If is not bad findMultipleQuick result.
		If $aButtonXY <> -1 Then

			; Array to global.
			$g_iTroopButtonX = $aButtonXY[0][1]
			$g_iTroopButtonY = $aButtonXY[0][2]
			Return True

		ElseIf $iB = 0 Then
			Local $iCount = 0
			If _ColorCheck(_GetPixelColor(24, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) Then
				While Not _ColorCheck(_GetPixelColor(838, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
					ClickDrag(617, 476, 318, 476, 250)
					If _sleep(500) Then Return False
					$iCount += 1
					If $iCount > 3 Then Return False
				WEnd
			ElseIf _ColorCheck(_GetPixelColor(838, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) Then
				While Not _ColorCheck(_GetPixelColor(24, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
					ClickDrag(236, 476, 538, 476, 250)
					If _sleep(500) Then Return False
					$iCount += 1
					If $iCount > 3 Then Return False
				WEnd
			EndIf
		EndIf
	Next

	Return False
EndFunc   ;==>LocateTroopButton

Func MyTrainClick($x, $y, $iTimes = 1, $iSpeed = 0, $sdebugtxt = "", $bIsBrewSpell = False)
	If IsTrainPage() Then

		Local $iRandNum = Random($iHLFClickMin - 1, $iHLFClickMax - 1, 1) ;Initialize value (delay awhile after $iRandNum times click)
		Local $iRandX = Random($x - 5, $x + 5, 1)
		Local $iRandY = Random($y - 5, $y + 5, 1)

		If isProblemAffect(True) Then Return

		For $i = 0 To ($iTimes - 1)
			HMLPureClick(Random($iRandX - 2, $iRandX + 2, 1), Random($iRandY - 2, $iRandY + 2, 1))
			If $i >= $iRandNum Then
				$iRandNum = $iRandNum + Random($iHLFClickMin, $iHLFClickMax, 1)
				$iRandX = Random($x - 5, $x + 5, 1)
				$iRandY = Random($y - 5, $y + 5, 1)
				If _Sleep(Random(($isldHLFClickDelayTime * 90) / 100, ($isldHLFClickDelayTime * 110) / 100, 1), False) Then ExitLoop
			Else
				If _Sleep(Random(($iSpeed * 90) / 100, ($iSpeed * 110) / 100, 1), False) Then ExitLoop
			EndIf
		Next
		Return True
	EndIf
EndFunc   ;==>MyTrainClick