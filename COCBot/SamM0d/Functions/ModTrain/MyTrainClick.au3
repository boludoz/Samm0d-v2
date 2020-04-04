
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

Func findMultipleQuick($sDirectory, $iQuantity2Match = 0, $saiArea2SearchOri = "0,0,860,732", $sOnlyFind = "", $bExactFind = False, $bForceCapture = True, $bDebugLog = False, $iLevel = 0)
	FuncEnter(findMultipleQuick)
	Local $sSearchDiamond = GetDiamondFromRect($saiArea2SearchOri)
	Local $aResult = findMultiple($sDirectory , $sSearchDiamond, $sSearchDiamond, $iLevel, 1000, $iQuantity2Match, "objectname,objectlevel,objectpoints", $bForceCapture)
	If Not IsArray($aResult) Then Return -1

	Local $iCount = 0

	; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
	Local $aAllResults[0][4]

	Local $aArrays = "", $aCoords, $aCommaCoord

	For $i = 0 To UBound($aResult) -1
		$aArrays = $aResult[$i] ; should be return objectname,objectpoints,objectlevel
		$aCoords = StringSplit($aArrays[2], "|", 2)
		For $iCoords = 0 To UBound($aCoords) -1
			$aCommaCoord = StringSplit($aCoords[$iCoords], ",", 2)

			If Not $sOnlyFind = "" Then
				If $bExactFind Then
					If StringCompare( $sOnlyFind, $aArrays[0] ) <> 0 Then ContinueLoop
				ElseIf not $bExactFind Then
					If StringInStr($aArrays[0], $sOnlyFind) = 0 Then ContinueLoop
				EndIf
			EndIf

			If _Sleep(20) Then Return

			; Inspired in Chilly-chill
			Local $aTmpResults[1][4] = [[$aArrays[0], Int($aCommaCoord[0]), Int($aCommaCoord[1]), Int($aArrays[1])]]
			_ArrayAdd($aAllResults, $aTmpResults)


			If ($i >= $iQuantity2Match) And not ($iQuantity2Match <= 0) Then ExitLoop
			If _Sleep(20) Then Return
		Next
		If _Sleep(20) Then Return
	Next

	Return (UBound($aAllResults) > 0) ? ($aAllResults) : (-1)
EndFunc

Func TestLocateTroopButton($sTroopB = "Giant", $bIsBrewSpell = False )
	Local $iSpace = 5
	Local $b = LocateTroopButton($iSpace, $sTroopB, $bIsBrewSpell)
	SetLog( $g_iTroopButtonX & " " & $g_iTroopButtonY & " " & $iSpace & " " & $b )
EndFunc    

Func LocateTroopButton( Byref $iSpace, $sTroopButton, $bIsBrewSpell = False )
	Local $aRegionForScan = "26,411,840,536"
	Local $aButtonXY
	
	For $iB = 0 To 1
	
		If not IsTrainPage() Then Return False

			; Capture troops train region.
			$aButtonXY = findMultipleQuick($g_sSamM0dImageLocation & "\TrainButtons\", 1, $aRegionForScan, $sTroopButton, False)

			For $iC = 0 To UBound($MyTroops) -1
				If ( StringInStr( $aButtonXY[0][0], $MyTroops[$iC][0] ) <> 0 ) Then
					$iSpace = ( StringInStr ( $aButtonXY[0][0], "Super" ) <> 0 ) ?  ($MyTroops[$iC][5]) : ($MyTroops[$iC][6])
				EndIf
			Next

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
					ClickDrag(617,476,318,476,250)
					If _sleep(500) Then Return False
					$iCount += 1
					If $iCount > 3 Then Return False
				WEnd
			ElseIf _ColorCheck(_GetPixelColor(838, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) Then
				While Not _ColorCheck(_GetPixelColor(24, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
					ClickDrag(236,476,538,476,250)
					If _sleep(500) Then Return False
					$iCount += 1
					If $iCount > 3 Then Return False
				WEnd
			EndIf
		EndIf
	Next

	Return False
EndFunc

Func MyTrainClick($x, $y, $iTimes = 1, $iSpeed = 0, $sdebugtxt="", $bIsBrewSpell = False)
	If IsTrainPage() Then

		Local $iRandNum = Random($iHLFClickMin-1,$iHLFClickMax-1,1) ;Initialize value (delay awhile after $iRandNum times click)
		Local $iRandX = Random($x - 5,$x + 5,1)
		Local $iRandY = Random($y - 5,$y + 5,1)

		If isProblemAffect(True) Then Return

		For $i = 0 To ($iTimes - 1)
			HMLPureClick(Random($iRandX-2,$iRandX+2,1), Random($iRandY-2,$iRandY+2,1))
			If $i >= $iRandNum Then
				$iRandNum = $iRandNum + Random($iHLFClickMin,$iHLFClickMax,1)
				$iRandX = Random($x - 5, $x + 5,1)
				$iRandY = Random($y - 5, $y + 5,1)
				If _Sleep(Random(($isldHLFClickDelayTime*90)/100, ($isldHLFClickDelayTime*110)/100, 1), False) Then ExitLoop
			Else
				If _Sleep(Random(($iSpeed*90)/100, ($iSpeed*110)/100, 1), False) Then ExitLoop
			EndIf
		Next

	EndIf
EndFunc   ;==>MyTrainClick

Func MakeTroopsAndSpellsTrainImage()

	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	; capture region left upper

	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep(200) Then Return

	If _Wait4Pixel($aButtonOpenTrainArmy[4], $aButtonOpenTrainArmy[5], $aButtonOpenTrainArmy[6], $aButtonOpenTrainArmy[7]) Then
		If $g_iSamM0dDebug = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If IsMainPage() Then
			If $g_bUseRandomClick = False Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf
	EndIf

	If _Sleep(250) Then Return

	If gotoTrainTroops() = False Then Return
	RemoveAllPreTrainTroops()

	Local $iCount = 0
	Local $iSlotWidth = 98.5
	Local $iStartingOffset = 45
	Local $iUpperLeftTroopElixirStartOffset = 26
	Local $iUpperLeftTroopDarkElixirStartOffset = 624
	Local $iUpperRightTroopDarkElixirStartOffset = 640
	Local $iUpperRowY1 = 413
	Local $iUpperRowY2 = 433
	Local $iLowerRowY1 = 514
	Local $iLowerRowY2 = 534

	_CaptureRegion2()
	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 0 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 5
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i + 6][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 1 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 5
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i + 6][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	If CheckNeedSwipe(19) = False Then
		SetLog("Cannot click drag to select troop" , $COLOR_ERROR)
		Return
	EndIf

	If _Sleep(500) Then Return

	_CaptureRegion2()

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 2 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to $iCount - 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 3 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to $iCount - 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	If gotoBrewSpells() = False Then Return
	RemoveAllPreTrainTroops()

	Local $iUpperLeftSpellStartOffset = 26
	Local $iUpperLeftDarkSpellStartOffset = 329

	_CaptureRegion2()
	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MySpellsButton) - 1
		If $MySpellsButton[$i][1] = 0 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 2
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MySpellsButton) - 1
		If $MySpellsButton[$i][1] = 1 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 2
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	$g_bRunState = $currentRunState
EndFunc

; Event
;~ Func MakeTroopsAndSpellsTrainImage()
;~ 	Local $currentRunState = $g_bRunState
;~ 	$g_bRunState = True
;~ 	; capture region left upper
;~ 	SetLog("MakeTroopsAndSpellsTrainImage Start")

;~ 	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
;~ 	If _Sleep(200) Then Return

;~ 	If _Wait4Pixel($aButtonOpenTrainArmy[4], $aButtonOpenTrainArmy[5], $aButtonOpenTrainArmy[6], $aButtonOpenTrainArmy[7]) Then
;~ 		If $g_iSamM0dDebug = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
;~ 		If IsMainPage() Then
;~ 			If $g_bUseRandomClick = False Then
;~ 				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
;~ 			Else
;~ 				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
;~ 			EndIf
;~ 		EndIf
;~ 	EndIf

;~ 	If _Sleep(250) Then Return

;~ 	If gotoTrainTroops() = False Then Return
;~ 	RemoveAllPreTrainTroops()

;~ 	Local $iCount = 0
;~ 	Local $iSlotWidth = 98.5
;~ 	Local $iStartingOffset = 45
;~ 	Local $iUpperLeftTroopElixirStartOffset = 26
;~ 	Local $iUpperLeftTroopDarkElixirStartOffset = 722
;~ 	Local $iUpperRightTroopDarkElixirStartOffset = 542
;~ 	Local $iUpperRowY1 = 413
;~ 	Local $iUpperRowY2 = 433
;~ 	Local $iLowerRowY1 = 514
;~ 	Local $iLowerRowY2 = 534

;~ 	_CaptureRegion2()
;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 0 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next

;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 6
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 to 0
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[7][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 1 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 6
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	For $i = 0 to 0
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[7][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	If CheckNeedSwipe(19) = False Then
;~ 		SetLog("Cannot click drag to select troop" , $COLOR_ERROR)
;~ 		Return
;~ 	EndIf

;~ 	Sleep(1000)

;~ 	_CaptureRegion2()

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 2 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to $iCount - 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 3 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to $iCount - 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	If gotoBrewSpells() = False Then Return
;~ 	RemoveAllPreTrainTroops()

;~ 	Local $iUpperLeftSpellStartOffset = 26
;~ 	Local $iUpperLeftDarkSpellStartOffset = 329
	Local $iUpperLeftDarkSpellStartOffset = 423 ; event 25-08

;~ 	_CaptureRegion2()
;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MySpellsButton) - 1
;~ 		If $MySpellsButton[$i][1] = 0 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 2
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 to 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MySpellsButton) - 1
;~ 		If $MySpellsButton[$i][1] = 1 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 2
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 to 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	SetLog("MakeTroopsAndSpellsTrainImage END")
;~ 	$g_bRunState = $currentRunState
;~ EndFunc
