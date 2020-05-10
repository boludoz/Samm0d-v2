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
	Local $vXWhiteSymbol = findMultipleQuick($g_sSamM0dImageLocation & "\Troops\IsTrainOrEmpty\", 0, "18,194,589,216", "x", True, True, 25)
	If not IsArray($vXWhiteSymbol) Then Return $vReturn

	Local $sDirectory = $g_sSamM0dImageLocation & "\Troops\"
	Local $aOnlyOne = findMultipleQuick($sDirectory, 0, "22,196,587,291", Default, False, True, 25, False)
	If not IsArray($aOnlyOne) Then Return $vReturn

	Local $vArray[0][4]
	
	For $i2 = 0 To UBound($aOnlyOne) -1
		
		Local $sTroopDummy = $aOnlyOne[$i2][0]
	
		For $i = 0 To UBound($vXWhiteSymbol) -1
			Local $aFakeA[1][4] = [[$sTroopDummy, Int($aOnlyOne[$i2][1] - 40), Int($aOnlyOne[$i2][1] + 40), getMyOcrSoft(Int($aOnlyOne[$i2][1] - 40), 193, Int($aOnlyOne[$i2][1] + 42), 215, Default, "armyqty", True)]]
			If $aOnlyOne[$i2][1] <= $aFakeA[0][1] And $aOnlyOne[$i2][1] >= $aFakeA[0][2] Then $aFakeA[0][0] = ""
			
			_ArrayAdd($vArray, $aFakeA)
			ExitLoop
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

	Local $aiTroopsInfo[7][3]
	Local $AvailableCamp = 0
	Local $bDeletedExcess = False
	
	Local $aSlotAuto = $g_vIntercomCheckAvailableUnit
	Local $iTroopIndex = -1
	Local $sTroopName = ""
	
	Local $aArraySuperDel[0][2] ; Name - Exceess
	
	For $i = 0 To UBound($aSlotAuto) -1
	
		If $i <= (UBound($aSlotAuto) - 1) Then 

			If $aSlotAuto[$i][0] <> "NotRecognized" Then
				$aiTroopsInfo[$i][0] = $aSlotAuto[$i][0] ; objectname
				$aiTroopsInfo[$i][1] = $aSlotAuto[$i][3]
				Setlog("Detected: " & $aSlotAuto[$i][0], $COLOR_INFO)
				$aiTroopsInfo[$i][2] = $i + 1
			Else
				$aiTroopsInfo[$i][0] = $aSlotAuto[$i][0] ; objectname
				$aiTroopsInfo[$i][2] = $i + 1
				SetLog("Error: Cannot detect what spells on slot: " & $i + 1, $COLOR_ERROR)
				ContinueLoop
			EndIf

			If $aiTroopsInfo[$i][1] <> 0 Or $aiTroopsInfo[$i][0] <> "NotRecognized" Then
				;$iTroopIndex = TroopIndexLookup($aiTroopsInfo[$i][0])
				;$sTroopName = GetTroopName($iTroopIndex, $aiTroopsInfo[$i][1])

				;SetLog(" - No. of Available " & $sTroopName & ": " & $aiTroopsInfo[$i][1], ($iTroopIndex > $iDarkFixTroop ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				Assign("cur" & $aiTroopsInfo[$i][0], $aiTroopsInfo[$i][1])

				; assign variable for drop trophy troops type
				For $j = 0 To UBound($g_avDTtroopsToBeUsed) - 1
					If $g_avDTtroopsToBeUsed[$j][0] = $aiTroopsInfo[$i][0] Then
						$g_avDTtroopsToBeUsed[$j][1] = $aiTroopsInfo[$i][1]
						ExitLoop
					EndIf
				Next
				
				;;_ArrayDisplay($aTempTroops)
				Local $iLink = Number(SearchMulti($aTempTroops, $aiTroopsInfo[$i][0]))
				Setlog("Slot troop " & $iLink)
				
				$AvailableCamp += ($aiTroopsInfo[$i][1] * $aTempTroops[$iLink][2])

				If $ichkEnableDeleteExcessTroops = 1 Then
					If $aiTroopsInfo[$i][1] > $aTempTroops[$iLink][3] Then
						$bDeletedExcess = True
						SetLog(" >>> Excess: " & $aiTroopsInfo[$i][1] - $aTempTroops[$iLink][3], $COLOR_RED)

						Local $aArraySuperDelFake[1][2] = [$aiTroopsInfo[$i][0], $aiTroopsInfo[$i][1] - $aTempTroops[$iLink][3]]
						_ArrayAdd($aArraySuperDel, $aArraySuperDelFake)

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
				;SetLog("Error detect quantity no. On Troop: " & GetTroopName(Eval("e" & $aiTroopsInfo[$i][0]), $aiTroopsInfo[$i][1]), $COLOR_RED)
				ExitLoop
			EndIf
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

		For $i2 = 0 To UBound($aArraySuperDel) -1
		
			Local $vReturn = False
			Local $vDelete = findMultipleQuick($g_sSamM0dImageLocation & "\CustomT\Army\", 0, "16, 406, 526, 426", "Delete", True, True, 25)
			If not IsArray($vDelete) Then Return $vReturn
			
			Local $aDel[2] = [($vDelete[$i2][1] - 50), ($vDelete[$i2][1]+ 10)]
			
			For $i = 0 To UBound($vDelete) -1
				
					Local $aOnlyOne = findMultipleQuick($g_sSamM0dImageLocation & "\Troops\", 0, "22,196,587,291", Default, False, True, 25, False)
					If not IsArray($aOnlyOne) Then Return $vReturn
					
					For $i3 To UBound($aOnlyOne) - 1
					
						If $aArraySuperDel[$i2][0] Then 
							Click($vDelete[$i][1], $vDelete[$i][2], $aArraySuperDel[$i][1])
							_ArrayDelete($aArraySuperDel, $i2)
						EndIf
						
					Next
					
				Next
		Next

		If Not $g_bRunState Then Return 
		ClickP($aButtonRemoveTroopsOK1, 1) ; Click on 'Okay' button to save changes

		ClickOkay()
		$g_bRestartCheckTroop = True
		
		If _CheckPixel($aButtonEditArmy, True) Or _Sleep(500) Then Return False
		
		Return False
	EndIf
	
	Return True
EndFunc   ;==>CheckAvailableUnit
