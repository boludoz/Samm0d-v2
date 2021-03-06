; #FUNCTION# ====================================================================================================================
; Name ..........: DoRevampSpells
; Description ...: Brewing full spells or revamp missing spells with what information get from CheckOnBrewUnit() And CheckAvailableSpellUnit()
;
; Syntax ........: DoRevampSpells()
; Parameters ....: $bDoPreTrain
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
Func DoRevampSpells($bDoPreTrain = False, $bDbg = False)
	If _Sleep(500) Then Return
	Local $bReVampFlag = False
	; start brew
	Local $aTempSpells[UBound($g_aMySpells)][5]
	$aTempSpells = $g_aMySpells

	If $ichkMySpellsOrder Then
		_ArraySort($aTempSpells, 0, 0, 0, 1)
	EndIf

	For $i = 0 To UBound($aTempSpells) - 1
		If $g_iSamM0dDebug = 1 Then SetLog("$aTempSpells[" & $i & "]: " & $aTempSpells[$i][0] & " - " & $aTempSpells[$i][1])
		; reset variable
		Assign("Dif" & $aTempSpells[$i][0] & "Spell", 0)
		Assign("Add" & $aTempSpells[$i][0] & "Spell", 0)
	Next

	If $bDoPreTrain = False Then
		For $i = 0 To UBound($aTempSpells) - 1
			Local $tempCurComp = $aTempSpells[$i][3]
			Local $tempCur = Eval("Cur" & $aTempSpells[$i][0] & "Spell") + Eval("OnT" & $aTempSpells[$i][0] & "Spell")
			If $g_iSamM0dDebug = 1 Then SetLog("$tempMySpells: " & $tempCurComp)
			If $g_iSamM0dDebug = 1 Then SetLog("$tempCur: " & $tempCur)
			If $tempCurComp <> $tempCur Then
				Assign("Dif" & $aTempSpells[$i][0] & "Spell", $tempCurComp - $tempCur)
			EndIf
		Next
	Else
		For $i = 0 To UBound($aTempSpells) - 1
			If Eval("ichkPre" & $aTempSpells[$i][0]) = 1 Then
				If $aTempSpells[$i][3] <> Eval("OnQ" & $aTempSpells[$i][0] & "Spell") Then
					Assign("Dif" & $aTempSpells[$i][0] & "Spell", $aTempSpells[$i][3] - Eval("OnQ" & $aTempSpells[$i][0] & "Spell"))
				EndIf
			EndIf
		Next
	EndIf

	For $i = 0 To UBound($aTempSpells) - 1
		If Eval("Dif" & $aTempSpells[$i][0] & "Spell") > 0 Then
			If $g_iSamM0dDebug = 1 Then SetLog("Some spells haven't train: " & $aTempSpells[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("Setting Qty Of " & $aTempSpells[$i][0] & " spells: " & $aTempSpells[$i][3])
			Assign("Add" & $aTempSpells[$i][0] & "Spell", Eval("Dif" & $aTempSpells[$i][0] & "Spell"))
			$bReVampFlag = True
		ElseIf Eval("Dif" & $aTempSpells[$i][0] & "Spell") < 0 Then
			If $g_iSamM0dDebug = 1 Then SetLog("Some spells over train: " & $aTempSpells[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("Setting Qty Of " & $aTempSpells[$i][0] & " spells: " & $aTempSpells[$i][3])
			If $g_iSamM0dDebug = 1 Then SetLog("Current Qty Of " & $aTempSpells[$i][0] & " spells: " & $aTempSpells[$i][3] - Eval("Dif" & $aTempSpells[$i][0] & "Spell"))
		EndIf
	Next

	If $bReVampFlag Then
		If gotoBrewSpells() = False Then Return

		If _sleep(100) Then Return
		; starttrain
		Local $iRemainSpellsCapacity = 0
		Local $iCreatedSpellsCapacity = 0
		Local $bFlagOutOfResource = False
		If $bDoPreTrain Then
			If Not IsArray($g_aiSpellsMaxCamp) Then $g_aiSpellsMaxCamp = getTrainArmyCapacity(True)
			$iRemainSpellsCapacity = $g_aiSpellsMaxCamp[1] - $g_aiSpellsMaxCamp[0]
			If $iRemainSpellsCapacity <= 0 Then
				SetLog("Spells full with pre-train.", $COLOR_INFO)
				Return
			EndIf
		Else
			$iRemainSpellsCapacity = $g_iTotalSpellValue - $g_aiSpellsMaxCamp[0]
			If $iRemainSpellsCapacity <= 0 Then
				SetLog("Spells full.", $COLOR_ERROR)
				Return
			EndIf
		EndIf

		For $i = 0 To UBound($aTempSpells) - 1
			Local $iOnQQty = Eval("Add" & $aTempSpells[$i][0] & "Spell")
			If $iOnQQty > 0 Then
				SetLog($CustomTrain_MSG_10 & " " & GetTroopName(Eval("enum" & $aTempSpells[$i][0]) + $eLSpell, $iOnQQty) & " x" & $iOnQQty, $COLOR_ACTION)
			EndIf
		Next

		Local $iCurElixir = ($bDbg = False) ? ( $g_aiCurrentLoot[$eLootElixir] ) : 999999
		Local $iCurDarkElixir = ($bDbg = False) ? ( $g_aiCurrentLoot[$eLootDarkElixir] ) : 999999
		Local $iCurGemAmount = ($bDbg = False) ? ( $g_iGemAmount ) : 999999

		SetLog("Elixir: " & $iCurElixir & "   Dark Elixir: " & $iCurDarkElixir & "   Gem: " & $iCurGemAmount, $COLOR_INFO)

		For $i = 0 To UBound($aTempSpells) - 1
			Local $tempSpell = Eval("Add" & $aTempSpells[$i][0] & "Spell")
			If $tempSpell > 0 And $iRemainSpellsCapacity > 0 Then

				If LocateTroopButton($aTempSpells[$i][0], True) Then
					Local $iCost
					; check train cost before click, incase use gem

					If $ichkEnableMySwitch = 0 Then
						If $aTempSpells[$i][4] = 0 Then
							$iCost = getMyOcr(0, $g_iTroopButtonX - 55, $g_iTroopButtonY + 26, 68, 18, "troopcost", True, False, True)
							If $iCost = 0 Or $iCost >= $g_aMySpellsCost[Eval("enum" & $aTempSpells[$i][0])][0] Then
								; cannot read train cost, use max level train cost
								$iCost = $g_aMySpellsCost[Eval("enum" & $aTempSpells[$i][0])][0]
							EndIf
							$g_aMySpells[Eval("enum" & $aTempSpells[$i][0])][4] = $iCost
						Else
							$iCost = $aTempSpells[$i][4]
						EndIf
					Else
						$iCost = getMyOcr(0, $g_iTroopButtonX - 55, $g_iTroopButtonY + 26, 68, 18, "troopcost", True, False, True)
						If $iCost = 0 Or $iCost >= $g_aMySpellsCost[Eval("enum" & $aTempSpells[$i][0])][0] Then
							; cannot read train cost, use max level train cost
							$iCost = $g_aMySpellsCost[Eval("enum" & $aTempSpells[$i][0])][0]
						EndIf
					EndIf

					If $g_iSamM0dDebug = 1 Then SetLog("$iCost: " & $iCost)
					;Local $iBuildCost = (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? getMyOcrCurDEFromTrain() : getMyOcrCurElixirFromTrain())
					Local $iBuildCost = (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? $iCurDarkElixir : $iCurElixir)

					If $g_iSamM0dDebug = 1 Then SetLog("$BuildCost: " & $iBuildCost)
					If $g_iSamM0dDebug = 1 Then SetLog("Total need: " & ($tempSpell * $iCost))

					;SetLog($CustomTrain_MSG_11 & " " & (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir) & ": " & $iBuildCost, (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
					;SetLog($CustomTrain_MSG_13 & ": " & $iCost, (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If ($tempSpell * $iCost) > $iBuildCost Then
						$bFlagOutOfResource = True
						; use eval and not $i to compare because of maybe after array sort $aTempTroops
						Setlog("Not enough " & (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? "Dark" : "") & " Elixir to brew " & GetTroopName(Eval("enum" & $aTempSpells[$i][0]) + $eLSpell, 0), $COLOR_ERROR)
						SetLog("Current " & (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? "Dark" : "") & " Elixir: " & $iBuildCost, $COLOR_ERROR)
						SetLog("Total need: " & $tempSpell * $iCost, $COLOR_ERROR)
					EndIf
					If $bFlagOutOfResource Then
						$g_bOutOfElixir = 1
						Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
						$g_bChkBotStop = True ; set halt attack variable
						$g_icmbBotCond = 18 ; set stay online
						If Not ($g_bfullarmy = True) Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
						Return ; We are out of Elixir stop training.
					EndIf

					SetLog($CustomTrain_MSG_14 & " " & GetTroopName(Eval("enum" & $aTempSpells[$i][0]) + $eLSpell, $tempSpell) & " x" & $tempSpell & " with total " & (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir) & ": " & ($tempSpell * $iCost), (Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If ($aTempSpells[$i][2] * $tempSpell) <= $iRemainSpellsCapacity Then
						If MyTrainClick($g_iTroopButtonX, $g_iTroopButtonY, $tempSpell, $g_iTrainClickDelay, "#BS01", True) Then
							If Eval("enum" & $aTempSpells[$i][0]) > $iDarkFixSpell Then
								$iCurDarkElixir -= ($tempSpell * $iCost)
							Else
								$iCurElixir -= ($tempSpell * $iCost)
							EndIf
							$iRemainSpellsCapacity -= ($aTempSpells[$i][2] * $tempSpell)
						EndIf
					Else
						SetLog("Error: remaining space cannot fit to brew " & GetTroopName(Eval("enum" & $aTempSpells[$i][0]) + $eLSpell, 0), $COLOR_ERROR)
					EndIf

				Else
					SetLog("Cannot find button: " & $aTempSpells[$i][0] & " for click", $COLOR_ERROR)
				EndIf
			EndIf
		Next
	EndIf
	If $bDoPreTrain Then
		; all spells and pre-brew spells already made, temparary disable check the spells until the spell donate make.
		$tempDisableBrewSpell = True
	EndIf
EndFunc   ;==>DoRevampSpells

