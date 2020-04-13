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
	Local $tempSieges = $MySieges
	;Local $aOcrSg[2] = [63, 545]
	
	
	Local $aCapMedium = CapacitySieges()
	If not IsArray($aCapMedium) Then Return False
	
	Local $iTotal = 0
	For $i = 0 To UBound($tempSieges) -1
		If $tempSieges[$tempSieges][2] <> 0 Then $iTotal += Int($tempSieges[$i][2] * $tempSieges[$i][3])
		If $aCapMedium[1] = $iTotal Then 
			ExitLoop
		Else
			Setlog("Please configure sieges.", $COLOR_ERROR)
			Return False
		EndIf
	Next
	
	;If Int(_GUICtrlComboBox_GetCurSel($g_hTxtTotalCountSiege)) = 0 Then Return
	_GUICtrlComboBox_SetCurSel($g_hTxtTotalCountSiege, $aCapMedium[1])

	If not IsArray($aCapMedium) And $aCapMedium[0] > 0 Then 
		Setlog("Fail TrainSiegesM 0x1.", $COLOR_ERROR)
		_debugSaveHBitmapToImage($g_hHBitmap2, "Fail_findMultipleQuick_in_TrainSiegesM", True)
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
		For $i = 0 To UBound($aXTroops) -1
			Local $sAdd = "None"
			
			For $iA = 0 To UBound($aTroopsReadyIn) -1
				If Int($aXTroops[$i][1] - 27) < Int($aTroopsReadyIn[$iA][1]) And Int($aXTroops[$i][1] + 44) > Int($aTroopsReadyIn[$iA][1]) Then 
					$sAdd = $aTroopsReadyIn[$i][0]
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
	
	;Return $aIsIn ; For test
	Local $aIsIntTmp = $aIsIn
	
	Local $bPreciseOk = True
	If $ichkForcePreciseSiegeBrew = 1 Then
		For $i2 = 0 To UBound($tempSieges) -1
			For $i = 0 To UBound($aIsIntTmp) -1
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
	
	If ($aCapMedium[0] = $aCapMedium[1]) And $bPreciseOk And not $ichkEnableDeleteExcessSieges = 1 And not $ichkForcePreSiegeBrewSiege = 1 Then Return

	
	If $ichkMySiegesOrder Then
		_ArraySort($tempSieges, 0, 0, 0, 1)
	EndIf
	
	Setlog("Training sieges.", $COLOR_INFO)

	Click(604, 132)
	;Local $iTotalClickSiege = $g_aGetSiegeCap[0] - $g_aGetSiegeCap[1]
	Local $iMySiegesSizeToTrain = 0
	Local $iMySiegesSize = 0
	
	For $i = 0 To UBound($tempSieges) - 1
		$iMySiegesSizeToTrain += Int(GUICtrlRead(Eval("txtNumSiege" & $tempSieges[$i][0] & "Siege"))) * $tempSieges[$i][2]
	Next
	
	;$iTotalClickSiege = Abs($iTotalClickSiege)
	;$iTotalClickSiege -= Abs($iMySiegesSizeToTrain)
	;$iTotalClickSiege = $g_aGetSiegeCap[1] - Abs($iTotalClickSiege)
	;$iTotalClickSiege = Abs($iTotalClickSiege)
	;Setlog($iTotalClickSiege)
	 ;Local $aCap = Int(_ArrayMax(CapacitySiegesIn()) / 2)

	For $i = 0 To $iTotalClickSiege - 1
		;$aCap
		$iMySiegesSize = Int(GUICtrlRead(Eval("txtNumSiege" & $tempSieges[$i][0] & "Siege"))) * $tempSieges[$i][2]
		SiegeClick($tempSieges[$i][0], $iMySiegesSize)
		Setlog("- Training " & $iMySiegesSize & " " & $tempSieges[$i][0] & " Siege/s.", $COLOR_ACTION)
	Next
	
	If $ichkForcePreSiegeBrewSiege = 1 Then
		;$aCap
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
	If not IsArray($a) Then Return False
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
	$g_aGetSiegeCap = StringSplit(getArmyCampCap(761, 163, True), "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number

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
