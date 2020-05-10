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
			Local $aFakeA[1][4] = [[$sTroopDummy, Int($aOnlyOne[$i2][1] - 40), Int($aOnlyOne[$i2][1] + 40), getMyOcrSoft(Int($aOnlyOne[$i2][1] -5), 342, Int($aOnlyOne[$i2][1] + 35), 342+19, Default, "SpellQTY", True)]]
			
			If $aOnlyOne[$i2][1] <= $aFakeA[0][1] And $aOnlyOne[$i2][1] >= $aFakeA[0][2] Then $aFakeA[0][0] = ""
			
			_ArrayAdd($vArray, $aFakeA)
			ExitLoop
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

	Local $aiSpellsInfo[7][3]
	Local $AvailableCamp = 0
	Local $bDeletedExcess = False
	
	Local $aSlotAuto = $g_vIntercomCheckAvailableSpellUnit
	
	Local $aArraySuperDel[0][2] ; Name - Exceess
	
	For $i = 0 To UBound($aSlotAuto) -1
		
		If $i <= (UBound($aSlotAuto) - 1) Then 
		
			If $aSlotAuto[$i][0] <> "NotRecognized" Then
				$aiSpellsInfo[$i][0] = $aSlotAuto[$i][0] ; objectname
				$aiSpellsInfo[$i][1] = $aSlotAuto[$i][3]
				Setlog("Detected: " & $aSlotAuto[$i][0], $COLOR_INFO)
				$aiSpellsInfo[$i][2] = $i + 1
			Else
				$aiSpellsInfo[$i][0] = $aSlotAuto[$i][0] ; objectname
				$aiSpellsInfo[$i][2] = $i + 1
				SetLog("Error: Cannot detect what spells on slot: " & $i + 1, $COLOR_ERROR)
				ContinueLoop
			EndIf

			If $aiSpellsInfo[$i][1] <> 0 And $aiSpellsInfo[$i][0] <> "NotRecognized" Then
				SetLog(" - No. of Available " & GetTroopName(Eval("enum" & $aiSpellsInfo[$i][0]) + $eLSpell, $aiSpellsInfo[$i][1]) & ": " & $aiSpellsInfo[$i][1], (Eval("enum" & $aiSpellsInfo[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				Assign("cur" & $aiSpellsInfo[$i][0] & "Spell", $aiSpellsInfo[$i][1])

				$AvailableCamp += ($aiSpellsInfo[$i][1] * $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][2])

				If $ichkEnableDeleteExcessSpells = 1 Then
					If $aiSpellsInfo[$i][1] > $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][3] Then
						$bDeletedExcess = True
						SetLog(" >>> Excess: " & $aiSpellsInfo[$i][1] - $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][3], $COLOR_RED)
						
						Local $aArraySuperDelFake[1][2] = [[$aiSpellsInfo[$i][0], $aiSpellsInfo[$i][1] - $g_aMySpells[Eval("enum" & $aiSpellsInfo[$i][0])][3]]]
						_ArrayAdd($aArraySuperDel, $aArraySuperDelFake)
						; _ArrayDisplay($aArraySuperDel)
						If $g_iSamM0dDebug = 1 Then SetLog("Set Remove Slot: " & $aiSpellsInfo[$i][2])
					EndIf
				EndIf
			ElseIf $aiSpellsInfo[$i][0] = "NotRecognized" Then
				Local $aArraySuperDelFake[1][2] = [[$aiSpellsInfo[$i][0], $aiSpellsInfo[$i][1]]]
				_ArrayAdd($aArraySuperDel, $aArraySuperDelFake)
				; _ArrayDisplay($aArraySuperDel)
			Else
				SetLog("Error detect quantity no. On Spell: " & GetTroopName(Eval("enum" & $aiSpellsInfo[$i][0]) + $eLSpell, $aiSpellsInfo[$i][1]), $COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	Next
	
	If $AvailableCamp <> $g_iCurrentSpells Then
		SetLog("Error: Spells size for all available Unit: " & $AvailableCamp & "  -  Camp: " & $g_iCurrentSpells, $COLOR_RED)
		$g_bRestartCheckTroop = True
		Return False
	Else
		If $bDeletedExcess Then
			$bDeletedExcess = False
			
			If gotoTrainTroops() = False Then Return
			If Not _ColorCheck(_GetPixelColor(823, 175 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) Then
				SetLog(" >>> Stop train troops.", $COLOR_RED)
				RemoveAllTroopAlreadyTrain()
				Return False
			EndIf
	
			If gotoArmy() = False Then Return
			SetLog(" >>> Remove excess troops.", $COLOR_RED)
			
			If Not _CheckPixel($aButtonEditArmy, True) Then ; If no 'Edit Army' Button found in army tab to edit troops
				SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_WARNING)
				Return False ; Exit function
			EndIf
			
			If Not $g_bRunState Then Return
			ClickP($aButtonEditArmy, 1) ; Click Edit Army Button
			If _Sleep(150) Then Return
			
			; Restaurante pobre
			For $i2 = UBound($aArraySuperDel) -1 To 0 Step -1
				Local $vReturn = False
				Local $vDelete = findMultipleQuick($g_sSamM0dImageLocation & "\CustomT\Army\", 0, "20, 406, 526, 426", "Delete", True, True, 25)
				; _ArrayDisplay($vDelete)
				If IsArray($vDelete) Then
					For $i = UBound($vDelete) -1 To 0 Step -1
				
						Local $aDel[2] = [($vDelete[$i][1] - 57) ? ($vDelete[$i][1] - 57) : (0), $vDelete[$i][1] + 13]
						; _ArrayDisplay($aDel)
						Local $sArea = $aDel[0] & "," & 335 & "," & $aDel[1] & "," & 438
						;Setlog($sArea)
						Local $aOnlyOne = findMultipleQuick($g_sSamM0dImageLocation & "\Spells\", 0, $sArea, Default, False, True, 5, False)
						; _ArrayDisplay($aOnlyOne)

						If not IsArray($aOnlyOne) And $aArraySuperDel[$i2][0] = "NotRecognized" Then
							Click($vDelete[$i][1] + Random(0, 2, 1), $vDelete[$i][2] + Random(0, 2, 1), $aArraySuperDel[$i2][1])
							; _ArrayDisplay($vDelete, $i)
							If UBound($vDelete) - 1 < 1 Then ExitLoop 3
							; _ArrayDisplay($aArraySuperDel, $i2)
							If UBound($aArraySuperDel) - 1 < 1 Then ExitLoop 3
							ContinueLoop 3
						ElseIf IsArray($aOnlyOne) Then
							For $i3 = UBound($aOnlyOne) - 1 To 0 Step -1
								If $aArraySuperDel[$i2][0] = $aOnlyOne[$i3][0] Then 
									Click($vDelete[$i][1] + Random(0, 2, 1), $vDelete[$i][2] + Random(0, 2, 1), $aArraySuperDel[$i2][1])
									; _ArrayDisplay($vDelete, $i)
									If UBound($vDelete) - 1 < 1 Then ExitLoop 3
									; _ArrayDisplay($aArraySuperDel, $i2)
									If UBound($aArraySuperDel) - 1 < 1 Then ExitLoop 3
									ContinueLoop 3
								EndIf
							Next
						EndIf
						
					Next
				EndIf
			Next
	
			If Not $g_bRunState Then Return 
			ClickP($aButtonRemoveTroopsOK1, 1) ; Click on 'Okay' button to save changes
	
			ClickOkay()
			$g_bRestartCheckTroop = True
			
			If _CheckPixel($aButtonEditArmy, True) Or _Sleep(500) Then Return False
			
			Return False
		EndIf
	EndIf
	Return True
EndFunc   ;==>CheckAvailableSpellUnit
