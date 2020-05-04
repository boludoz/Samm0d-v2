; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOnBrewUnit
; Description ...: Reads current quanitites/type of spells from brew spell window, updates $OnTXXXXSpell (On Train unit and quantity), $OnQXXXXXSpell (On Queue unit and quantity)
;                  Check spells brew correctly, will remove what un need.
; Syntax ........: CheckOnBrewUnit
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
Func CheckOnBrewUnit()
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckOnBrewUnit ============")
	SetLog("Start check on brew unit...", $COLOR_INFO)
	; reset variable
	For $i = 0 To UBound($MySpells) - 1
		Assign("OnT" & $MySpells[$i][0] & "Spell", 0)
		Assign("OnQ" & $MySpells[$i][0] & "Spell", 0)
		Assign("Ready" & $MySpells[$i][0] & "Spell", 0)
		Assign("RemoveSpellUnitOfOnT" & $MySpells[$i][0], 0)
		Assign("RemoveSpellUnitOfOnQ" & $MySpells[$i][0], 0)
	Next

	Local $aiSpellInfo[11][4]
	Local $iAvailableCamp = 0
	Local $iMySpellsCampSize = 0

	Local $iOnQueueCamp = 0
	Local $iMyPreBrewSpellSize = 0

	Local $bDeletedExcess = False
	Local $bGotOnBrewFlag = False
	Local $bGotOnQueueFlag = False

	; Name, qty, IsPre, IsReady
	Local $aSumPreTra = GetTrainedAndPreDetect("Spells")
	;_ArrayDisplay($aSumPreTra)
	If IsArray($aSumPreTra) Then
		For $i = UBound($aSumPreTra) -1 To 0 Step -1

			If $aSumPreTra[$i][0] = "NotRecognized" Then
				SetLog("Error: Cannot detect what Spells on slot: " & $i + 1, $COLOR_ERROR)
				$aiSpellInfo[$i][0] = "NotRecognized"
				$aiSpellInfo[$i][1] = $aSumPreTra[$i][1]
				$aiSpellInfo[$i][2] = Abs(11 - $i) 
				$aiSpellInfo[$i][3] = $aSumPreTra[$i][2]
				ContinueLoop
			EndIf

			If $aSumPreTra[$i][1] <> 0 Then

				$aiSpellInfo[$i][0] = $aSumPreTra[$i][0] ; Name
				$aiSpellInfo[$i][1] = $aSumPreTra[$i][1] ; Qty
				$aiSpellInfo[$i][2] = Abs(11 - $i) 
				;SetLog($aiSpellInfo[$i][2] & " : " & "Slot", $COLOR_INFO)
				$aiSpellInfo[$i][3] = $aSumPreTra[$i][2] ;IsQueueSpell
				If $aSumPreTra[$i][2] Then
					Assign("OnQ" & $aSumPreTra[$i][0] & "Spell", Eval("OnQ" & $aSumPreTra[$i][0] & "Spell") + $aSumPreTra[$i][1])

					If $aSumPreTra[$i][3] = True Then
						Assign("Ready" & $aSumPreTra[$i][0] & "Spell", Eval("Ready" & $aSumPreTra[$i][0] & "Spell") + $aSumPreTra[$i][1])
					EndIf

				Else
					Assign("OnT" & $aSumPreTra[$i][0] & "Spell", Eval("OnT" & $aSumPreTra[$i][0] & "Spell") + $aSumPreTra[$i][1])
				EndIf
			Else
				SetLog("Error detect quantity no. On Spell: " & $aSumPreTra[$i][0], $COLOR_RED)
				ExitLoop
			EndIf
		Next

	Else
		SetLog("No Army On Brew.", $COLOR_ERROR)
		Return True
	EndIf

	$bGotOnBrewFlag = False
	For $i = 0 To UBound($MySpells) - 1
		Local $itempTotal = Eval("cur" & $MySpells[$i][0] & "Spell") + Eval("OnT" & $MySpells[$i][0] & "Spell")
		If Eval("OnT" & $MySpells[$i][0] & "Spell") > 0 Then
			SetLog(" - No. of On Brew " & GetTroopName(Eval("enum" & $MySpells[$i][0]) + $eLSpell, Eval("OnT" & $MySpells[$i][0] & "Spell")) & ": " & Eval("OnT" & $MySpells[$i][0] & "Spell"), (Eval("enum" & $MySpells[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
			$bGotOnBrewFlag = True
		EndIf
		If $MySpells[$i][3] < $itempTotal Then
			If $ichkEnableDeleteExcessSpells = 1 And not BitAND($g_iTotalSpellValue - $g_iMySpellsSize = 1, $ichkForcePreBrewSpell = 1) = True Then ; MOD
				SetLog("Error: " & GetTroopName(Eval("enum" & $MySpells[$i][0] + $eLSpell), Eval("OnT" & $MySpells[$i][0] & "Spell")) & " need " & $MySpells[$i][3] & " only, and i made " & $itempTotal)
				Assign("RemoveSpellUnitOfOnT" & $MySpells[$i][0], $itempTotal - $MySpells[$i][3])
				$bDeletedExcess = True
			EndIf
		EndIf
		If $itempTotal > 0 Then
			$iAvailableCamp += $itempTotal * $MySpells[$i][2]
		EndIf
		If $MySpells[$i][3] > 0 Then
			$iMySpellsCampSize += $MySpells[$i][3] * $MySpells[$i][2]
		EndIf
	Next

	If $bDeletedExcess Then
		$bDeletedExcess = False
		If gotoBrewSpells() = False Then Return
		SetLog(" >>> Some Spells over train, stop and remove Spells.", $COLOR_RED)
		RemoveAllPreTrainTroops()
		_ArraySort($aiSpellInfo, 0, 0, 0, 2) ; sort to make remove start from left to right
		For $i = 0 To 10
			If $aiSpellInfo[$i][1] <> 0 And $aiSpellInfo[$i][3] = False Then
				; Comprueba si esta tropa va a ser eliminada.
				Local $iUnitToRemove = Eval("RemoveSpellUnitOfOnT" & $aiSpellInfo[$i][0])
				If $iUnitToRemove > 0 Then
					If $aiSpellInfo[$i][1] > $iUnitToRemove Then
						SetLog("Remove " & GetTroopName(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell, $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
						RemoveTrainTroops($aiSpellInfo[$i][2] - 1, $iUnitToRemove)
						$iUnitToRemove = 0
						Assign("RemoveSpellUnitOfOnT" & $aiSpellInfo[$i][0], $iUnitToRemove)
					Else
						SetLog("Remove " & GetTroopName(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell, $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $aiSpellInfo[$i][1], $COLOR_ACTION)
						RemoveTrainTroops($aiSpellInfo[$i][2] - 1, $aiSpellInfo[$i][1])
						$iUnitToRemove -= $aiSpellInfo[$i][1]
						Assign("RemoveSpellUnitOfOnT" & $aiSpellInfo[$i][0], $iUnitToRemove)
					EndIf
				EndIf
			EndIf
		Next
		$g_bRestartCheckTroop = True
		Return False
	Else
		$bDeletedExcess = False
		$bGotOnQueueFlag = False
		For $i = 0 To UBound($MySpells) - 1
			Local $itempTotal = Eval("OnQ" & $MySpells[$i][0] & "Spell")
			If $itempTotal > 0 Then
				SetLog(" - No. of On Queue " & GetTroopName(Eval("enum" & $MySpells[$i][0]) + $eLSpell, Eval("OnQ" & $MySpells[$i][0] & "Spell")) & ": " & Eval("OnQ" & $MySpells[$i][0] & "Spell"), (Eval("enum" & $MySpells[$i][0]) > $iDarkFixSpell ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				$bGotOnQueueFlag = True
				If Eval("ichkPre" & $MySpells[$i][0]) = 1 Then
					If $MySpells[$i][3] < $itempTotal Then
						If $ichkEnableDeleteExcessSpells = 1 And not BitAND($g_iTotalSpellValue - $g_iMySpellsSize = 1, $ichkForcePreBrewSpell = 1) = True Then
							SetLog("Error: " & GetTroopName(Eval("enum" & $MySpells[$i][0]) + $eLSpell, Eval("OnQ" & $MySpells[$i][0] & "Spell")) & " need " & $MySpells[$i][3] & " only, and i made " & $itempTotal)
							Assign("RemoveSpellUnitOfOnQ" & $MySpells[$i][0], $itempTotal - $MySpells[$i][3])
							$bDeletedExcess = True
						EndIf
					EndIf
					$iMyPreBrewSpellSize += $itempTotal * $MySpells[$i][2]
				Else
					SetLog("Error: " & GetTroopName(Eval("enum" & $MySpells[$i][0]) + $eLSpell, Eval("OnQ" & $MySpells[$i][0] & "Spell")) & " not needed to pre brew, remove all.")
					Assign("RemoveSpellUnitOfOnQ" & $MySpells[$i][0], $itempTotal)
					$bDeletedExcess = True
				EndIf
				$iOnQueueCamp += $itempTotal * $MySpells[$i][2]
			EndIf
		Next

		If $bGotOnQueueFlag And Not $bGotOnBrewFlag Then
			If $iAvailableCamp < $iMySpellsCampSize Or $g_bDoPrebrewspell = 0 Then
				If $g_bDoPrebrewspell = 0 Then
					SetLog("Pre-Brew spells disable by user, remove all pre-train spells.", $COLOR_ERROR)
				Else
					SetLog("Error: Spells size not correct but pretrain already.", $COLOR_ERROR)
					SetLog("Error: Detected Spells size = " & $iAvailableCamp & ", My Spells size = " & $iMySpellsCampSize, $COLOR_ERROR)
				EndIf
				If gotoBrewSpells() = False Then Return
				RemoveAllPreTrainTroops()
				$g_bRestartCheckTroop = True
				Return False
			EndIf
		EndIf

		If $bDeletedExcess Then
			$bDeletedExcess = False
			If gotoBrewSpells() = False Then Return
			SetLog(" >>> Some spells over train, stop and remove pre-train Spells.", $COLOR_RED)
			_ArraySort($aiSpellInfo, 0, 0, 0, 2) ; sort to make remove start from left to right
			For $i = 0 To 10
				If $aiSpellInfo[$i][1] <> 0 And $aiSpellInfo[$i][3] = True Then
					Local $iUnitToRemove = Eval("RemoveSpellUnitOfOnQ" & $aiSpellInfo[$i][0])
					If $iUnitToRemove > 0 Then
						If $aiSpellInfo[$i][1] > $iUnitToRemove Then
							SetLog("Remove " & GetTroopName(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell, $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
							RemoveTrainTroops($aiSpellInfo[$i][2] - 1, $iUnitToRemove)
							$iUnitToRemove = 0
							Assign("RemoveSpellUnitOfOnQ" & $aiSpellInfo[$i][0], $iUnitToRemove)
						Else
							SetLog("Remove " & GetTroopName(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell, $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $aiSpellInfo[$i][1], $COLOR_ACTION)
							RemoveTrainTroops($aiSpellInfo[$i][2] - 1, $aiSpellInfo[$i][1])
							$iUnitToRemove -= $aiSpellInfo[$i][1]
							Assign("RemoveSpellUnitOfOnQ" & $aiSpellInfo[$i][0], $iUnitToRemove)
						EndIf
					EndIf
				EndIf
			Next
			$g_bRestartCheckTroop = True
			Return False
		EndIf

		; if don't have on brew spell then i check the pre brew spell size
		If $bGotOnQueueFlag And Not $bGotOnBrewFlag Then
			If $aiSpellInfo[0][1] > 0 Then
				If $iOnQueueCamp <> $iMyPreBrewSpellSize Then
					SetLog("Error: Pre-Brew Spells size not correct.", $COLOR_ERROR)
					SetLog("Error: Detected Pre-Brew Spells size = " & $iOnQueueCamp & ", My Spells size = " & $iMyPreBrewSpellSize, $COLOR_ERROR)
					If gotoBrewSpells() = False Then Return
					RemoveAllPreTrainTroops()
					$g_bRestartCheckTroop = True
					Return False
				EndIf
			EndIf

			If $g_bDoPrebrewspell = 0 Then
				SetLog("Pre-brew spell disable by user, remove all pre-brew spell.", $COLOR_INFO)
				If gotoBrewSpells() = False Then Return
				RemoveAllPreTrainTroops()
			EndIf
		Else
			If $ichkMySpellsOrder Then
				Local $tempSpells[10][5]
				$tempSpells = $MySpells
				_ArraySort($tempSpells, 0, 0, 0, 1)
				For $i = 0 To UBound($tempSpells) - 1
					If $tempSpells[$i][3] > 0 Then
						$tempSpells[0][0] = $tempSpells[$i][0]
						$tempSpells[0][3] = $tempSpells[$i][3]
						ExitLoop
					EndIf
				Next
				_ArraySort($aiSpellInfo, 1, 0, 0, 2)
				For $i = 0 To UBound($aiSpellInfo) - 1
					If $aiSpellInfo[$i][3] = True Then
						If $aiSpellInfo[$i][0] <> $tempSpells[0][0] Then
							SetLog("Pre-Brew Spell first slot: " & GetTroopName(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell, $aiSpellInfo[$i][1]), $COLOR_ERROR)
							SetLog("My first order spells: " & GetTroopName(Eval("enum" & $tempSpells[0][0]) + $eLSpell, $tempSpells[0][3]), $COLOR_ERROR)
							SetLog("Remove and re-brew by order.", $COLOR_ERROR)
							RemoveAllPreTrainTroops()
							$g_bRestartCheckTroop = True
							Return False
						Else
							If $aiSpellInfo[$i][1] < $tempSpells[0][3] Then
								SetLog("Pre-Brew Spell first slot: " & GetTroopName(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell, $aiSpellInfo[$i][1]) & " - Units: " & $aiSpellInfo[$i][1], $COLOR_ERROR)
								SetLog("My first order spells: " & GetTroopName(Eval("enum" & $tempSpells[0][0]) + $eLSpell, $tempSpells[0][3]) & " - Units: " & $tempSpells[0][3], $COLOR_ERROR)
								SetLog("Not enough quantity, remove and re-brew again.", $COLOR_ERROR)
								RemoveAllPreTrainTroops()
								$g_bRestartCheckTroop = True
								Return False
							EndIf
						EndIf
						ExitLoop
					EndIf
				Next
			EndIf
		EndIf
	EndIf

	If $g_abAttackTypeEnable[$DB] = True And $g_abSearchSpellsWaitEnable[$DB] = True Then
		For $i = 0 To UBound($MySpells) -1
			If Eval("Cur" & $MySpells[$i][0] & "Spell") < $MySpells[$i][3] Then
				SETLOG(" Dead Base - Waiting " & GetTroopName($i + $eLSpell, $MySpells[$i][3] - Eval("Cur" & $MySpells[$i][0] & "Spell")) & _
						" to brew finish before start next attack.", $COLOR_ACTION)
			EndIf
		Next
	EndIf

	If $g_abAttackTypeEnable[$LB] = True And $g_abSearchSpellsWaitEnable[$LB] = True Then
		For $i = 0 To UBound($MySpells) -1
			If Eval("Cur" & $MySpells[$i][0] & "Spell") < $MySpells[$i][3] Then
				SETLOG(" Live Base - Waiting " & GetTroopName($i + $eLSpell + $eLSpell, $MySpells[$i][3] - Eval("Cur" & $MySpells[$i][0] & "Spell")) & _
						" to brew finish before start next attack.", $COLOR_ACTION)
			EndIf
		Next
	EndIf

	If $g_iSamM0dDebug = 1 Then SETLOG("$bFullArmySpells: " & $g_bFullArmySpells & ", $iTotalSpellSpace:$iMyTotalTrainSpaceSpell " & $iAvailableCamp & "|" & $g_iMySpellsSize, $COLOR_DEBUG)

	Return True
EndFunc   ;==>CheckOnBrewUnit
