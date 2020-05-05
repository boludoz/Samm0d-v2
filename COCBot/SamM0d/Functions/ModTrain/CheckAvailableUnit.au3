; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAvailableUnit
; Description ...: Reads current quanitites/type of troops from Training window, updates $CurXXXXX (Current available unit)
;                  and also update $g_avDTtroopsToBeUsed for drop trophy
;                  remove excess unit will be done by here if enable by user at GUI
; Syntax ........: CheckAvailableUnit
; Parameters ....:
;
; Return values .: None
; Author ........: Samkie (27 Jun 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_vIntercomCheckAvailableUnit = -1

Func ArrayCheckAvailableUnit()
	$g_vIntercomCheckAvailableUnit = -1
	Local $vReturn = -1
	Local $vXWhiteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Troops\IsTrainOrEmpty\", 0, "18,194,589,216", "x", True, True, 10)
	If not IsArray($vXWhiteSymbol) Then Return $vReturn

	Local $sDirectory = $g_sSamM0dImageLocation & "\Troops\"
	Local $aOnlyOne = findMultipleQuick($sDirectory, 0, "22,196,587,291", Default, False, True, 40, False)
	If not IsArray($aOnlyOne) Then Return $vReturn

	Local $vArray[0][4]
	
	For $i2 = 0 To UBound($aOnlyOne) -1
		
		Local $sTroopDummy = $aOnlyOne[$i2][0]
	
		For $i = 0 To UBound($vXWhiteSymbol) -1
			;Local $sSlot = ($vXWhiteSymbol[$i][1] - 23 >= 20) ? ($vXWhiteSymbol[$i][1] - 23) : (23) & "," & 195 & "," & $vXWhiteSymbol[$i][1]-7 & "," & 215
			;If not IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\Troops\IsTrainOrEmpty\", 1, $sSlot, "Is", True, True, 0)) Then
			
					Local $aFakeA[1][4] = [[$sTroopDummy, Int($aOnlyOne[$i2][1] - 40), Int($aOnlyOne[$i2][1] + 40), getMyOcrSoft(Int($aOnlyOne[$i2][1] - 43), 195, Int($aOnlyOne[$i2][1] + 38), 214, Default, "armyqty", True)]]
					If $aOnlyOne[$i2][1] <= $aFakeA[0][1] And $aOnlyOne[$i2][1] >= $aFakeA[0][2] Then $aFakeA[0][0] = ""
					
					_ArrayAdd($vArray, $aFakeA)
					ExitLoop
				
			;	Else
			;		Setlog("Troops check finished", $COLOR_INFO)
			;		ExitLoop 2
			;	
			;EndIf
		Next
	Next
	$g_vIntercomCheckAvailableUnit = (UBound($vArray) > 0) ? ($vArray) :($vReturn)
	Return $g_vIntercomCheckAvailableUnit
EndFunc   ;==>ArrayCheckAvailableUnit

Func CheckAvailableUnit()
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckAvailableUnit ============")
	SetLog("Start check available unit...", $COLOR_INFO)

	Local $aTempTroops = $g_aMyTroops
	SuperTroopsCorrectArray($aTempTroops)
	
	; reset variable
	For $i = 0 To UBound($aTempTroops) - 1
		Assign("cur" & $aTempTroops[$i][0], 0)
	Next
	For $i = 0 To 6
		Assign("RemSlot" & $i + 1, 0)
	Next

	Local $aiTroopsInfo[7][3]
	Local $AvailableCamp = 0
	Local $bDeletedExcess = False
	
	Local $aSlotAuto = $g_vIntercomCheckAvailableUnit
	Local $iTroopIndex = -1
	Local $sTroopName = ""

	;_ArrayDisplay($aSlotAuto)
	For $i = 0 To UBound($aSlotAuto) - 1

		If $aSlotAuto[$i][0] <> "" Then
			$aiTroopsInfo[$i][0] = $aSlotAuto[$i][0] ; objectname
			$aiTroopsInfo[$i][2] = $i + 1
			Setlog("Detected: " & $aSlotAuto[$i][0], $COLOR_INFO)
		Else
			SetLog("Error: Cannot detect what troops on slot: " & $i + 1, $COLOR_ERROR)
			ContinueLoop
		EndIf

		$aiTroopsInfo[$i][1] = $aSlotAuto[$i][3] ;getMyOcrSoft($aSlotAuto[$i][1], 196, $aSlotAuto[$i][2], 215, Default, "SpellQTY", True)

		;_ArrayDisplay($aiSpellsInfo)

		If $aiTroopsInfo[$i][1] <> 0 Then
			$iTroopIndex = TroopIndexLookup($aiTroopsInfo[$i][0])
			$sTroopName = GetTroopName($iTroopIndex, $aiTroopsInfo[$i][1])

			SetLog(" - No. of Available " & $sTroopName & ": " & $aiTroopsInfo[$i][1], ($iTroopIndex > $iDarkFixTroop ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
			Assign("cur" & $aiTroopsInfo[$i][0], $aiTroopsInfo[$i][1])

			; assign variable for drop trophy troops type
			For $j = 0 To UBound($g_avDTtroopsToBeUsed) - 1
				If $g_avDTtroopsToBeUsed[$j][0] = $aiTroopsInfo[$i][0] Then
					$g_avDTtroopsToBeUsed[$j][1] = $aiTroopsInfo[$i][1]
					ExitLoop
				EndIf
			Next

			$AvailableCamp += ($aiTroopsInfo[$i][1] * $aTempTroops[Eval("e" & $aiTroopsInfo[$i][0])][2])

			If $ichkEnableDeleteExcessTroops = 1 Then
				If $aiTroopsInfo[$i][1] > $aTempTroops[Eval("e" & $aiTroopsInfo[$i][0])][3] Then
					$bDeletedExcess = True
					SetLog(" >>> excess: " & $aiTroopsInfo[$i][1] - $aTempTroops[Eval("e" & $aiTroopsInfo[$i][0])][3], $COLOR_RED)
					Assign("RemSlot" & $aiTroopsInfo[$i][2], $aiTroopsInfo[$i][1] - $aTempTroops[Eval("e" & $aiTroopsInfo[$i][0])][3])
					If $g_iSamM0dDebug = 1 Then SetLog("Set Remove Slot: " & $aiTroopsInfo[$i][2])
				EndIf
			EndIf

			; assign variable for drop trophy troops type
			For $j = 0 To UBound($g_avDTtroopsToBeUsed) - 1
				If $g_avDTtroopsToBeUsed[$j][0] = $aiTroopsInfo[$i][0] Then
					$g_avDTtroopsToBeUsed[$j][1] = $aiTroopsInfo[$i][1]
					ExitLoop
				EndIf
			Next
		Else
			SetLog("Error detect quantity no. On Troop: " & GetTroopName(Eval("e" & $aiTroopsInfo[$i][0]), $aiTroopsInfo[$i][1]), $COLOR_RED)
			ExitLoop
		EndIf
	Next

	If $AvailableCamp <> $g_CurrentCampUtilization Then
		If $ichkEnableDeleteExcessTroops = 1 Then
			SetLog("Error: Troops size for all available Unit: " & $AvailableCamp & "  -  Camp: " & $g_CurrentCampUtilization, $COLOR_RED)
			$g_bRestartCheckTroop = True
			Return False
		EndIf
	EndIf

	If $bDeletedExcess Then
		$bDeletedExcess = False
		If gotoTrainTroops() = False Then Return
		If Not _ColorCheck(_GetPixelColor(823, 175 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) Then
			SetLog(" >>> stop train troops.", $COLOR_RED)
			RemoveAllTroopAlreadyTrain()
			Return False
		EndIf

		If gotoArmy() = False Then Return
		SetLog(" >>> remove excess troops.", $COLOR_RED)
		If WaitforPixel($aButtonEditArmy2[4], $aButtonEditArmy2[5], $aButtonEditArmy2[4] + 1, $aButtonEditArmy2[5] + 1, Hex($aButtonEditArmy2[6], 6), $aButtonEditArmy2[7], 20) Then
			Click($aButtonEditArmy2[0], $aButtonEditArmy2[1], 1, 0, "#EditArmy")
		Else
			Return False
		EndIf

		If WaitforPixel($aButtonEditCancel[4], $aButtonEditCancel[5], $aButtonEditCancel[4] + 1, $aButtonEditCancel[5] + 1, Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7], 20) Then
			For $i = 10 To 0 Step -1
				Local $RemoveSlotQty = Eval("RemSlot" & $i + 1)
				If $g_iSamM0dDebug = 1 Then SetLog($i & " $RemoveSlotQty: " & $RemoveSlotQty)
				If $RemoveSlotQty > 0 Then
					Local $iRx = (80 + ($g_iArmy_Av_Troop_Slot_Width * $i))
					Local $iRy = 240 + $g_iMidOffsetY
					For $j = 1 To $RemoveSlotQty
						Click(Random($iRx - 2, $iRx + 2, 1), Random($iRy - 2, $iRy + 2, 1))
						If _Sleep($g_iTrainClickDelay) Then Return
					Next
					Assign("RemSlot" & $i + 1, 0)
				EndIf
			Next
		Else
			Return False
		EndIf

		If WaitforPixel($aButtonEditOkay[4], $aButtonEditOkay[5], $aButtonEditOkay[4] + 1, $aButtonEditOkay[5] + 1, Hex($aButtonEditOkay[6], 6), $aButtonEditOkay[7], 20) Then
			Click($aButtonEditOkay[0], $aButtonEditOkay[1], 1, 0, "#EditArmyOkay")
		Else
			Return False
		EndIf

		ClickOkay()
		$g_bRestartCheckTroop = True
		If WaitforPixel($aButtonEditArmy2[4], $aButtonEditArmy2[5], $aButtonEditArmy2[4] + 1, $aButtonEditArmy2[5] + 1, Hex($aButtonEditArmy2[6], 6), $aButtonEditArmy2[7], 20) Then
			Return False
		Else
			If _Sleep(1000) Then Return False
		EndIf
		Return False
	EndIf
	Return True

	Return False
EndFunc   ;==>CheckAvailableUnit
