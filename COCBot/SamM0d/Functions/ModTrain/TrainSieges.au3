; #FUNCTION# ====================================================================================================================
; Name ..........: Train Sieges
; Description ...:
; Syntax ........:
; Parameters ....:
;
; Return values .: None
; Author ........: BOLUDOZ (18/1/2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_bAlmostOneReady = False
Func TrainSiegesM()
return 
	Local $tempSieges = $MySieges
	;;_ArrayDisplay($tempSieges)
	;Local $aOcrSg[2] = [63, 545]

	Local $aCapMedium = CapacitySieges()
	If Not IsArray($aCapMedium) Then Return False

	Local $iTotal = 0
	For $i = 0 To UBound($tempSieges) - 1
		$iTotal += Int($tempSieges[$i][2] * $tempSieges[$i][3])
		If $aCapMedium[1] = $iTotal Then
			ExitLoop
		EndIf
	Next

	If $i > UBound($tempSieges) - 1 Then
		Setlog("Please configure sieges. Total troops : " & $iTotal & " Camps space : " & $aCapMedium[1], $COLOR_ERROR)
		Return False
	EndIf

	;If Int(_GUICtrlComboBox_GetCurSel($g_hTxtTotalCountSiege)) = 0 Then Return
	_GUICtrlComboBox_SetCurSel($g_hTxtTotalCountSiege, $aCapMedium[1])

	If Not IsArray($aCapMedium) And $aCapMedium[0] > 0 Then
		Setlog("Fail TrainSiegesM 0x1.", $COLOR_ERROR)
		Return False
	EndIf
	;Local $aCap = Int(_ArrayMax($aCapMedium))

	Local $aXTroops = findMultipleQuick($g_sSamM0dImageLocation & "\CustomT\", 0, "602,193,838,217", "x", True)
	_ArraySort($aXTroops, 0, 0, 0, 1)
	Local $aTroopsReadyIn = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Ready\", 0, "605,215,845,290", Default, False)
	_ArraySort($aTroopsReadyIn, 0, 0, 0, 1)

	Local $aIsIn[0][2]

	$g_bAlmostOneReady = False
	If IsArray($aTroopsReadyIn) Then
		; System for if don't recognize a troop
		For $i = 0 To UBound($aXTroops) - 1
			Local $sAdd = "None"

			For $iA = 0 To UBound($aTroopsReadyIn) - 1
				If Int($aXTroops[$i][1] - 27) < Int($aTroopsReadyIn[$iA][1]) And Int($aXTroops[$i][1] + 44) > Int($aTroopsReadyIn[$iA][1]) Then
					$sAdd = $aTroopsReadyIn[$iA][0]
					_ArrayDelete($aTroopsReadyIn, $iA) ; Optimization
					$g_bAlmostOneReady = True
					ExitLoop
				EndIf
			Next

			; Chilly-Chill code inspired.
			Local $aSlot[1][2] = [[$sAdd, Number(getTroopCountSmall($aXTroops[$i][1], 195))]]
			_ArrayAdd($aIsIn, $aSlot)
		Next
	EndIf

	; Force precise siege brew first part.
	Local $aIsIntTmp = $aIsIn
	Local $bPreciseOk = True
	If $ichkForcePreciseSiegeBrew = 1 Then
		For $i2 = 0 To UBound($tempSieges) - 1
			For $i = 0 To UBound($aIsIntTmp) - 1
				If $tempSieges[$i2][3] <> $aIsIntTmp[$i][1] And (StringInStr($tempSieges[$i2][0], $aIsIntTmp[$i][0]) <> 0) Then
					$bPreciseOk = False
					ExitLoop 2
				ElseIf (StringInStr($tempSieges[$i2][0], $aIsIntTmp[$i][0]) = 0) Then
					$bPreciseOk = False
					ExitLoop 2
				EndIf
			Next
		Next
	EndIf

	If ($aCapMedium[0] = $aCapMedium[1]) And $bPreciseOk And Not $ichkEnableDeleteExcessSieges = 1 And Not $ichkForcePreSiegeBrewSiege = 1 Then
		SetLog("Brew is OK.", $COLOR_INFO)
		Return "Brew OK."
	EndIf

	; Sieges order part.
	If $ichkMySiegesOrder Then
		_ArraySort($tempSieges, 0, 0, 0, 1)
	EndIf

	; Training sieges part.
	Click(Random(600, 610, 1), Random(128, 135, 1))
	If _Sleep(Random(100, 610, 1)) Then Return

	Setlog("Training sieges.", $COLOR_INFO)

	Local $vDeleteRedSymbol, $vDeleteWhiteSymbol
	Local $bIsPreSiegesOk = False
	Local $bBitsPreIsOk = True
	Local $iLoopW = 0
	Local $iQty
	Local $aReadyTroopsDel
	Local $sTmpBrew = ""
	Local $aTmpArray[2]
	Local $aIsTraining[0][2], $aIsPreTraining[0][2]
	
	; "AI" part.
	While 1
	
		;$vDeleteRedSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "DeleteR", True, True, 25)
		$vDeleteWhiteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "DeleteW", True, True, 25)
		
		; Precise sieges part.
		If Not $bPreciseOk Then
			$bIsPreSiegesOk = (Not IsArray($vDeleteWhiteSymbol))

			If $bIsPreSiegesOk Then
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

						$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Train\", 0, $sTmpBrew)

						$aTmpArray[1] = $iQty

						If IsArray($aReadyTroopsDel) Then
							$aTmpArray[0] = $aReadyTroopsDel[0][0]
							;ExitLoop
						Else
							$aTmpArray[0] = "NotRecognized"
							;ExitLoop
						EndIf
						;;_ArrayDisplay($aTmpArray)
						Local $aMatrix[1][2] = [[$aTmpArray[0], $aTmpArray[1]]]
						_ArrayAdd($aIsTraining, $aMatrix)
					Next

				EndIf
				
			EndIf

		EndIf

		;If $iLoopW = 0 Then Setlog(" - Is sieges ok? : " & $bIsPreSiegesOk)
		;$iLoopW += 1
	
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

				$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Queue\", 0, $sTmpBrew)

				$aTmpArray[1] = $iQty

				If IsArray($aReadyTroopsDel) Then
					$aTmpArray[0] = $aReadyTroopsDel[0][0]
					;ExitLoop
				Else
					$aTmpArray[0] = "NotRecognized"
					;ExitLoop
				EndIf
				;;_ArrayDisplay($aTmpArray)
				Local $aMatrix[1][2] = [[$aTmpArray[0], $aTmpArray[1]]]
				_ArrayAdd($aIsPreTraining, $aMatrix)
			Next

		EndIf


		; Concatenation system.
		; $aIsIntTmp   - In general army.
		; $aIsTraining - In brew training.
		; $aIsPreTraining - In brew training.
		; ----- $aIsTotal - $aIsIntTmp + $aIsTraining + $aIsPreTraining.

		Local $aIsTotal[0][8] 
		
		; Analize separated loops for optimize.
		For $ia = 0 To UBound($tempSieges) -1
		
			; Instruction block.
			Local $sSiegeName = $tempSieges[$ia][0]      ; [X][0] - Siege name / Or NotRecognized.
			Local $iSiegeGUITrain = $tempSieges[$ia][3]  ; [X][1] - Total to train from GUI. 
			Local $iDeleteInArmy = 0                     ; [X][2] - 0 < Is necesay delete in army general.
			Local $iSiegesToTrainDrag = 0                ; [X][3] - 0 < Is necesay delete in Siege specific tab. / 0 > Is necesay train or drag.
			Local $iIsTrained = 0                        ; [X][4] - Is trained.
			Local $iIsInTrainProcess = 0                 ; [X][5] - Is in train process.
			Local $iIsPreTrained = 0                     ; [X][6] - Is pre trained.
			Local $iIsForPreTrain = 0                    ; [X][7] - Is to pre train.
			
			
			; Is brew.
			For $i = 0 To UBound($aIsIntTmp) -1
				If (StringInStr($aIsIntTmp[$i][0], $sSiegeName) <> 0) Then
					$iIsTrained += $aIsIntTmp[$i][1]
					_ArrayDelete($aIsIntTmp, $i)
					ExitLoop
				EndIf
			Next

			; Is in training.
			For $i = 0 To UBound($aIsTraining) -1
				If (StringInStr($aIsTraining[$i][0], $sSiegeName) <> 0) Then
					$iIsInTrainProcess += $aIsTraining[$i][1]
					_ArrayDelete($aIsTraining, $i)
					ExitLoop
				EndIf
			Next
			
			; Is in PreTraining.
			For $i = 0 To UBound($aIsPreTraining) -1
				If (StringInStr($aIsPreTraining[$i][0], $sSiegeName) <> 0) Then
					$iIsPreTrained += $aIsPreTraining[$i][1]
					_ArrayDelete($aIsPreTraining, $i)
					ExitLoop
				EndIf
			Next
			
			; Rest
			;Local $iDeleteInArmy = 0                     ; [X][2] - 0 < Is necesay delete in army general.
			;Local $iSiegesToTrainDrag = 0                ; [X][3] - 0 < Is necesay delete in Siege specific tab. / 0 > Is necesay train or drag.
			;Local $iIsForPreTrain = 0                    ; [X][7] - Is to pre train.
			
			Local $aMatrix[1][8] = [[$sSiegeName, $iSiegeGUITrain, $iDeleteInArmy, $iSiegesToTrainDrag, $iIsTrained, $iIsInTrainProcess, $iIsPreTrained, $iIsForPreTrain]]
			_ArrayAdd($aIsTotal, $aMatrix)
		
		Next
		
		; NotRecognized
		For $i = 0 To UBound($aIsTraining) -1
			If (StringInStr($aIsTraining[$i][0], "NotRecognized") <> 0) Then 
				Local $aMatrix[1][8] = [["NotRecognized", 0, $aIsTraining[$i][1], 0, 0, $aIsTraining[$i][1], 0, 0]]
				_ArrayAdd($aIsTotal, $aMatrix)
			EndIf
		Next
		
		;_ArrayDisplay($aIsTotal)
		Return -23
		;Bits pre brew here.
		;...
		;------------------

		If Not $ichkEnableDeleteExcessSieges = 1 And Not $ichkForcePreSiegeBrewSiege = 1 And $bBitsPreIsOk And $bIsPreSiegesOk Then
			Return
		;Else
		EndIf


		If Not IsArray($vDeleteRedSymbol) Or $bBitsPreIsOk Then ExitLoop

		If $ichkForcePreSiegeBrewSiege = 1 Then

			For $i = 0 To UBound($vDeleteRedSymbol) - 1
				Local $iQty = getMyOcrSoft($vDeleteRedSymbol[$i][1] - 50, 190, $vDeleteRedSymbol[$i][1] + 12, 208, (True) ? ("spellqtypre") : ("spellqtybrew"), True)
				Local $a = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Queue\", 0, "16,178,838,265")

				;;editFor $iA = 0 To UBound($a) - 1
				;;edit	If Int($aXTroops[$i][1] - 27) < Int($aTroopsReadyIn[$iA][1]) And Int($aXTroops[$i][1] + 44) > Int($aTroopsReadyIn[$iA][1]) Then
				;;edit		$sAdd = $aTroopsReadyIn[$iA][0]
				;;edit		_ArrayDelete($aTroopsReadyIn, $iA) ; Optimization
				;;edit		$g_bAlmostOneReady = True
				;;edit		ExitLoop
				;;edit	EndIf
				;;editNext

				;If $tempSieges[$i2][3] <> $aIsIn[$i][1] And (StringInStr($tempSieges[$i2][0], $aIsIn[$i][0]) <> 0) Then
				;If ... ExitLoop 2
				;EndIf
			Next
		EndIf
		;$ichkForcePreSiegeBrewSiege = 1
	WEnd

	; Delete
	; x1 = -50 / y1 = 59 / x2 = 12 / y2 = -6

	;Local $iTotalClickSiege = $g_aGetSiegeCap[0] - $g_aGetSiegeCap[1]
	Local $iMySiegesSizeToTrain = 0
	Local $iMySiegesSize = 0

	For $i = 0 To UBound($tempSieges) - 1
		$iMySiegesSizeToTrain += Int(GUICtrlRead(Eval("txtNumSiege" & $tempSieges[$i][0] & "Siege"))) * $tempSieges[$i][2]
	Next

	For $i = 0 To $iTotalClickSiege - 1
		$iMySiegesSize = Int(GUICtrlRead(Eval("txtNumSiege" & $tempSieges[$i][0] & "Siege"))) * $tempSieges[$i][2]
		SiegeClick($tempSieges[$i][0], $iMySiegesSize)
		Setlog("- Training " & $iMySiegesSize & " " & $tempSieges[$i][0] & " Siege/s.", $COLOR_ACTION)
	Next

	If $ichkForcePreSiegeBrewSiege = 1 Then
		For $i = 0 To UBound($tempSieges) - 1
			$iMySiegesSize = Int(GUICtrlRead(Eval("txtNumSiege" & $tempSieges[$i][0] & "Siege"))) * $tempSieges[$i][2]
			SiegeClick($tempSieges[$i][0], $iMySiegesSize)
			Setlog("- Training " & $iMySiegesSize & " " & $tempSieges[$i][0] & " Siege/s.", $COLOR_ACTION)
		Next
	EndIf
EndFunc   ;==>TrainSiegesM

Func SiegeClick($sName, $iTimes = 1, $iSpeed = Random(750, 2000, 1))
	Local $sDirectory = $g_sSamM0dImageLocation & "\Siege\TrainBtn\"
	Local $a = findMultipleQuick($sDirectory, 0, "15,367,839,581", $sName, False, True)
	If Not IsArray($a) Then Return False
	MyTrainClick($a[0][1], $a[0][2], $iTimes, $iSpeed)
EndFunc   ;==>SiegeClick

; #FUNCTION# ====================================================================================================================
; Name ..........: Train Sieges Capacity In
; Description ...:
; Syntax ........:
; Parameters ....:
;
; Return values .: None
; Author ........: BOLUDOZ (11/4/2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CapacitySiegesIn()
	; Get CC Siege Capacities
	;If $g_bDebugSetlogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
	$g_aGetSiegeCapIn = StringSplit(getArmyCapacityOnTrainTroops(57, 160), "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number

	If UBound($g_aGetSiegeCapIn) = 2 Then
		If Number($g_aGetSiegeCapIn[1]) = 0 Then
			$g_aGetSiegeCapIn = 0
			Return 0
		Else
			Return $g_aGetSiegeCapIn
		EndIf
	Else
		$g_aGetSiegeCapIn = 0
		Return 0
	EndIf

EndFunc   ;==>CapacitySiegesIn

; #FUNCTION# ====================================================================================================================
; Name ..........: Train Sieges Capacity
; Description ...:
; Syntax ........:
; Parameters ....:
;
; Return values .: None
; Author ........: BOLUDOZ (18/1/2019-4/2/2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CapacitySieges()
	; Get CC Siege Capacities
	;If $g_bDebugSetlogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
	$g_aGetSiegeCap = StringSplit(getMyOcr(0,760,165,90,15,"armycap"), "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
	If UBound($g_aGetSiegeCap) = 2 Then
		If Number($g_aGetSiegeCap[1]) = 0 Then
			$g_aGetSiegeCap = 0
			Return 0
		Else
			Return $g_aGetSiegeCap
		EndIf
	Else
		$g_aGetSiegeCap = 0
		Return 0
	EndIf
EndFunc   ;==>CapacitySieges


Func asd123()
	; Enable delete excess sieges.
	Local $vDeleteRedSymbol, $vDeleteWhiteSymbol
	Local $bIsPreSiegesOk = False
	Local $bBitsPreIsOk = True
	Local $iLoopW = 0
	Local $iQty
	Local $aReadyTroopsDel
	Local $sTmpBrew = ""
	Local $aTmpArray[2]

	$vDeleteWhiteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Sprites\", 0, "17,190,842,199", "DeleteW", True)
	

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

			$aReadyTroopsDel = findMultipleQuick($g_sSamM0dImageLocation & "\Siege\Train\", 0, $sTmpBrew)

			$aTmpArray[1] = $iQty

			If IsArray($aReadyTroopsDel) Then
				$aTmpArray[0] = $aReadyTroopsDel[0][0]
				;ExitLoop
			Else
				$aTmpArray[0] = "None"
				;ExitLoop
			EndIf

			;_ArrayDisplay($aTmpArray)
		Next

	EndIf
EndFunc   ;==>asd123
