; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAvailableSpellUnit
; Description ...: Reads current quanitites/type of spells from Brew Spell window, updates $CurXXXXXSpell (Current available spells unit)
;                  remove excess unit will be done by here if enable by user at GUI
; Syntax ........: CheckAvailableSpellUnit
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
Global $g_vIntercomCheckAvailableSpellUnit = -1

Func ArrayCheckAvailableSpell()
	$g_vIntercomCheckAvailableSpellUnit = -1
	Local $vReturn = -1
	Local $vXWhiteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Spells\IsTrainOrEmpty\", 0, "17,340,526,358", "x", True, True, 10)
	If not IsArray($vXWhiteSymbol) Then Return $vReturn

	Local $sDirectory = $g_sSamM0dImageLocation & "\Spells\"
	Local $aOnlyOne = findMultipleQuick($sDirectory, 0, "20,339,524,433", Default, False, True, 40, False)
	If not IsArray($aOnlyOne) Then Return $vReturn

	Local $vArray[0][4]
	
	For $i2 = 0 To UBound($aOnlyOne) -1
		
		Local $sTroopDummy = $aOnlyOne[$i2][0]
	
		For $i = 0 To UBound($vXWhiteSymbol) -1
			;Local $sSlot = ($vXWhiteSymbol[$i][1] - 23 >= 20) ? ($vXWhiteSymbol[$i][1] - 23) : (23) & "," & 340 & "," & $vXWhiteSymbol[$i][1]-7 & "," & 358
			;If not IsArray(findMultipleQuick($g_sSamM0dImageLocation & "\Spells\IsTrainOrEmpty\", 1, $sSlot, "Is", True, True, 0)) Then
			
					Local $aFakeA[1][4] = [[$sTroopDummy, Int($aOnlyOne[$i2][1] - 40), Int($aOnlyOne[$i2][1] + 40), getMyOcrSoft(Int($aOnlyOne[$i2][1] -5), 342, Int($aOnlyOne[$i2][1] + 35), 342+19, Default, "SpellQTY", True)]]
					
					If $aOnlyOne[$i2][1] <= $aFakeA[0][1] And $aOnlyOne[$i2][1] >= $aFakeA[0][2] Then $aFakeA[0][0] = ""
					
					_ArrayAdd($vArray, $aFakeA)
					ExitLoop
				
			;	Else
			;		Setlog("Spell check finished", $COLOR_INFO)
			;		ExitLoop 2
			;	
			;EndIf
		Next
	Next
	$g_vIntercomCheckAvailableSpellUnit = (UBound($vArray) > 0) ? ($vArray) :($vReturn)
	Return $g_vIntercomCheckAvailableSpellUnit
EndFunc   ;==>ArrayCheckAvailableUnit


Func CheckAvailableSpellUnit()

	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckAvailableSpellUnit ============")
	SetLog("Start check available spell unit...", $COLOR_INFO)

	; reset variable
	For $i = 0 To UBound($g_aMySpells) - 1
		Assign("cur" & $g_aMySpells[$i][0] & "Spell", 0)
	Next
	For $i = 0 To 6
		Assign("RemSpellSlot" & $i + 1, 0)
	Next

	Local $aiSpellsInfo[7][3]
	Local $AvailableCamp = 0
	Local $bDeletedExcess = False
	
	Local $aSlotAuto = $g_vIntercomCheckAvailableSpellUnit
	
	;_ArrayDisplay($aSlotAuto)
	For $i = 0 To UBound($aSlotAuto) - 1
	
		If $aSlotAuto[$i][0] <> "" Then
			$aiSpellsInfo[$i][0] = $aSlotAuto[$i][0] ; objectname
			$aiSpellsInfo[$i][2] = $i + 1
			Setlog("Detected: " & $aSlotAuto[$i][0], $COLOR_INFO)
		Else
			SetLog("Error: Cannot detect what spells on slot: " & Abs(11 - $i), $COLOR_ERROR)
			ContinueLoop
		EndIf

		$aiSpellsInfo[$i][1] = $aSlotAuto[$i][3]
		
		;_ArrayDisplay($aiSpellsInfo)
		
		If $aiSpellsInfo[$i][1] <> 0 Then
			SetLog(" - No. of Available " & GetTroopName(Eval("enum" & $aiSpellsInfo[$i][0]) + $eLSpell, $aiSpellsInfo[$i][1]) & ": " & $aiSpellsInfo[$i][1], (Eval("enum" & $aiSpellsInfo[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
			Assign("cur" & $aiSpellsInfo[$i][0] & "Spell", $aiSpellsInfo[$i][1])

			$AvailableCamp += ($aiSpellsInfo[$i][1] * $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][2])

			If $ichkEnableDeleteExcessSpells = 1 Then
				If $aiSpellsInfo[$i][1] > $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][3] Then
					$bDeletedExcess = True
					SetLog(" >>> excess: " & $aiSpellsInfo[$i][1] - $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][3], $COLOR_RED)
					Assign("RemSpellSlot" & $aiSpellsInfo[$i][2], $aiSpellsInfo[$i][1] - $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][3])
					If $g_iSamM0dDebug = 1 Then SetLog("Set Remove Slot: " & $aiSpellsInfo[$i][2])
				EndIf
			EndIf
		Else
			SetLog("Error detect quantity no. On Spell: " & GetTroopName(Eval("enum" & $aiSpellsInfo[$i][0]) + $eLSpell, $aiSpellsInfo[$i][1]), $COLOR_RED)
			ExitLoop
		EndIf
	Next
	
	If $AvailableCamp <> $g_iCurrentSpells Then
		SetLog("Error: Spells size for all available Unit: " & $AvailableCamp & "  -  Camp: " & $g_iCurrentSpells, $COLOR_RED)
		$g_bRestartCheckTroop = True
		Return False
	Else
		If $bDeletedExcess = True Then
			$bDeletedExcess = False

			If gotoBrewSpells() = False Then Return False
			If Not _ColorCheck(_GetPixelColor(823, 175 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) Then
				SetLog(" >>> stop brew spell.", $COLOR_RED)
				RemoveAllTroopAlreadyTrain()
				Return False
			EndIf

			If gotoArmy() = False Then Return
			SetLog(" >>> remove excess spells.", $COLOR_RED)
			
			If WaitforPixel($aButtonEditArmy2[4], $aButtonEditArmy2[5], $aButtonEditArmy2[4] + 1, $aButtonEditArmy2[5] + 1, Hex($aButtonEditArmy2[6], 6), $aButtonEditArmy2[7], 20) Then
				Click($aButtonEditArmy2[0], $aButtonEditArmy2[1], 1, 0, "#EditArmy")
			Else
				Return
			EndIf

			If WaitforPixel($aButtonEditCancel[4], $aButtonEditCancel[5], $aButtonEditCancel[4] + 1, $aButtonEditCancel[5] + 1, Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7], 20) Then
				For $i = 6 To 0 Step -1
					Local $RemoveSlotQty = Eval("RemSpellSlot" & $i + 1)
					If $g_iSamM0dDebug = 1 Then SetLog($i & " $RemoveSlotQty: " & $RemoveSlotQty)
					If $RemoveSlotQty > 0 Then
						Local $iRx = (80 + ($g_iArmy_Av_Spell_Slot_Width * $i))
						Local $iRy = 386 + $g_iMidOffsetY
						For $j = 1 To $RemoveSlotQty
							Click(Random($iRx - 2, $iRx + 2, 1), Random($iRy - 2, $iRy + 2, 1))
							If _Sleep($g_iTrainClickDelay) Then Return
						Next
						Assign("RemSpellSlot" & $i + 1, 0)
					EndIf
				Next
			Else
				Return
			EndIf

			If WaitforPixel($aButtonEditOkay[4], $aButtonEditOkay[5], $aButtonEditOkay[4] + 1, $aButtonEditOkay[5] + 1, Hex($aButtonEditOkay[6], 6), $aButtonEditOkay[7], 20) Then
				Click($aButtonEditOkay[0], $aButtonEditOkay[1], 1, 0, "#EditArmyOkay")
			Else
				Return
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
	EndIf
	Return False
EndFunc   ;==>CheckAvailableSpellUnit
