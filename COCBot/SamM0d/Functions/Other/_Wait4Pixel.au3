Func _Wait4Pixel($x, $y, $sColor, $iColorVariation, $iWait = 1000, $iDelay = 100, $sMsglog = Default)
	Local $hTimer = __TimerInit()
	Local $iMaxCount = Int($iWait / $iDelay)
	For $i = 1 To $iMaxCount
		ForceCaptureRegion()
		If _CheckColorPixel($x, $y, $sColor, $iColorVariation, True, $sMsglog) Then Return True
		;If _ColorCheck(_GetPixelColor($x, $y, True, "Ori Color: " & Hex($sColor,6)), Hex($sColor,6), Int($iColorVariation)) Then Return True
		If _Sleep($iDelay) Then Return False
		If __TimerDiff($hTimer) >= $iWait Then ExitLoop
	Next
	Return False
EndFunc

Func _Wait4PixelGone($x, $y, $sColor, $iColorVariation, $iWait = 1000, $iDelay = 100, $sMsglog = Default)
	Local $hTimer = __TimerInit()
	Local $iMaxCount = Int($iWait / $iDelay)
	For $i = 1 To $iMaxCount
		ForceCaptureRegion()
		If Not _CheckColorPixel($x, $y, $sColor, $iColorVariation, True, $sMsglog) Then Return True
		If _Sleep($iDelay) Then Return False
		If __TimerDiff($hTimer) >= $iWait Then ExitLoop
	Next
	Return False
EndFunc

Func _CheckColorPixel($x, $y, $sColor, $iColorVariation, $bFCapture = True, $sMsglog = Default)
	Local $hPixelColor = _GetPixelColor2($x, $y, $bFCapture)
	Local $bFound = _ColorCheck($hPixelColor, Hex($sColor,6), Int($iColorVariation))
	Local $COLORMSG = ($bFound = True ? $COLOR_BLUE : $COLOR_RED)
	If $sMsglog <> Default And IsString($sMsglog) And $g_iSamM0dDebug = 1 Then
		Local $String = $sMsglog & " - Ori Color: " & Hex($sColor,6) & " at X,Y: " & $x & "," & $y & " Found: " & $hPixelColor
		SetLog($String, $COLORMSG)
	EndIf
	Return $bFound
EndFunc

Func _GetPixelColor2($iX, $iY, $bNeedCapture = False)
	Local $aPixelColor = 0
	If $bNeedCapture = False Or $g_bRunState = False Then
		$aPixelColor = _GDIPlus_BitmapGetPixel($g_hBitmap, $iX, $iY)
	Else
		_CaptureRegion($iX - 1, $iY - 1, $iX + 1, $iY + 1)
		$aPixelColor = _GDIPlus_BitmapGetPixel($g_hBitmap, 1, 1)
	EndIf
	Return Hex($aPixelColor, 6)
EndFunc   ;==>_GetPixelColor

Func findMultipleQuick2($sDirectory, $iQuantityMatch = Default, $vArea2SearchOri = Default, $bForceCapture = Default, $sOnlyFind = Default, $bExactFindP = Default, $iDistance2check = 25, $bDebugLog = False, $iLevel = 0, $iMaxLevel = 1000)
	FuncEnter(findMultipleQuick)
	
	Local $bCapture, $sArea2Search, $sIsOnlyFind, $iQuantToMach, $bExactFind, $iQuantity2Match
	$iQuantity2Match = ($iQuantityMatch = Default) ? (0) : ($iQuantityMatch)
	$bCapture = ($bForceCapture = Default) ? (True) : ($bForceCapture)
	$sIsOnlyFind = ($sOnlyFind = Default) ? ("") : ($sOnlyFind)
	$iQuantToMach = ($sOnlyFind = Default) ? ($iQuantity2Match) : (20)
	$bExactFind = ($bExactFindP = Default) ? ($bExactFind) : (False)

	If $vArea2SearchOri = Default Then
		$sArea2Search = "FV"
	ElseIf (IsArray($vArea2SearchOri)) Then
		$sArea2Search = (GetDiamondFromArray($vArea2SearchOri))
	Else
		Switch UBound(StringSplit($vArea2SearchOri, ",", $STR_NOCOUNT))
			Case 4
				$sArea2Search = GetDiamondFromRect($vArea2SearchOri)
			Case 0, 5
				$sArea2Search = $vArea2SearchOri
			Case Else
				SetDebugLog("findMultipleQuick | Coords error. ")
				Return -1
		EndSwitch
	EndIf
	
	Local $aResult = findMultiple($sDirectory, $sArea2Search, $sArea2Search, $iLevel, $iMaxLevel, $iQuantToMach, "objectname,objectlevel,objectpoints", $bCapture)
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

			If $sIsOnlyFind <> "" Then
				If $bExactFind Then
					If StringCompare($sIsOnlyFind, $aArrays[0]) <> 0 Then ContinueLoop
				ElseIf Not $bExactFind Then
					If StringInStr($aArrays[0], $sIsOnlyFind) = 0 Then ContinueLoop
				EndIf
			EndIf
			
			; Inspired in Chilly-chill
			Local $aTmpResults[1][4] = [[$aArrays[0], Int($aCommaCoord[0]), Int($aCommaCoord[1]), Int($aArrays[1])]]
			If $iCount >= $iQuantity2Match And Not $iQuantity2Match = 0 Then ExitLoop 2
			_ArrayAdd($aAllResults, $aTmpResults)
			$iCount += 1
		Next
	Next
	
	; Sort by X axis
	_ArraySort($aAllResults, 0, 0, 0, 1)
	If $iDistance2check > 0 And UBound($aAllResults) > 1 Then
		; Distance in pixels to check if is a duplicated detection , for deploy point will be 5
		Local $D2Check = $iDistance2check

		; check if is a double Detection, near in 10px
		Local $Dime = 0
		For $i = 0 To UBound($aAllResults) - 1
			If $i > UBound($aAllResults) - 1 Then ExitLoop
			Local $LastCoordinate[4] = [$aAllResults[$i][0], $aAllResults[$i][1], $aAllResults[$i][2], $aAllResults[$i][3]]
			SetDebugLog("Coordinate to Check: " & _ArrayToString($LastCoordinate))
			If UBound($aAllResults) > 1 Then
				For $j = 0 To UBound($aAllResults) - 1
					If $j > UBound($aAllResults) - 1 Then ExitLoop
					Local $SingleCoordinate[4] = [$aAllResults[$j][0], $aAllResults[$j][1], $aAllResults[$j][2], $aAllResults[$j][3]]
					If $LastCoordinate[1] <> $SingleCoordinate[1] Or $LastCoordinate[2] <> $SingleCoordinate[2] Then
						If Abs($SingleCoordinate[1] - $LastCoordinate[1]) <= $D2Check Or _
								Abs($SingleCoordinate[2] - $LastCoordinate[2]) <= $D2Check Then
							_ArrayDelete($aAllResults, $j)
						EndIf
					Else
						If $LastCoordinate[1] = $SingleCoordinate[1] And $LastCoordinate[2] = $SingleCoordinate[2] And not ($LastCoordinate[3] <> $SingleCoordinate[3] Or $LastCoordinate[0] <> $SingleCoordinate[0]) Then
							_ArrayDelete($aAllResults, $j)
						EndIf
					EndIf
				Next
			EndIf
		Next
	EndIf
	
	Return (UBound($aAllResults) > 0) ? ($aAllResults) : (-1)
EndFunc   ;==>findMultipleQuick2
