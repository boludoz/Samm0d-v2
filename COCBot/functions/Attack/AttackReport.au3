; #FUNCTION# ====================================================================================================================
; Name ..........: AttackReport
; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
;                  It will also update the statistics to the GUI (Last Attack).
; Syntax ........: AttackReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (02-2015), Sardo (05-2015), Hervidero (12-2015)
; Modified ......: Sardo (05-2015), Hervidero (05-2015), Knowjack (07-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AttackReport()
	Static $iBonusLast = 0 ; last attack Bonus percentage
	Local $g_asLeagueDetailsShort = ""
	Local $iCount

	$iCount = 0 ; Reset loop counter
	While _CheckPixel($aEndFightSceneAvl, True) = False ; check for light gold pixle in the Gold ribbon in End of Attack Scene before reading values
		$iCount += 1
		If _Sleep($DELAYATTACKREPORT1) Then Return
		If $g_bDebugSetlog Then SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_DEBUG)
		If $iCount > 30 Then ExitLoop ; wait 30*500ms = 15 seconds max for the window to render
	WEnd
	If $iCount > 30 Then SetLog("End of Attack scene slow to appear, attack values my not be correct", $COLOR_INFO)

	$iCount = 0 ; reset loop counter
	While getResourcesLoot(290, 289 + $g_iMidOffsetY) = "" ; check for gold value to be non-zero before reading other values as a secondary timer to make sure all values are available
		$iCount += 1
		If _Sleep($DELAYATTACKREPORT1) Then Return
		If $g_bDebugSetlog Then SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_DEBUG)
		If $iCount > 20 Then ExitLoop ; wait 20*500ms = 10 seconds max before we have call the OCR read an error
	WEnd
	If $iCount > 20 Then SetLog("End of Attack scene read gold error, attack values my not be correct", $COLOR_INFO)

	If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], True), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
		$g_iStatsLastAttack[$eLootGold] = getResourcesLoot(290, 289 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootElixir] = getResourcesLoot(290, 328 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootDarkElixir] = getResourcesLootDE(365, 365 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 402 + $g_iMidOffsetY)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$g_iStatsLastAttack[$eLootTrophy] = -$g_iStatsLastAttack[$eLootTrophy]
		EndIf
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
	Else
		$g_iStatsLastAttack[$eLootGold] = getResourcesLoot(290, 289 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootElixir] = getResourcesLoot(290, 328 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 365 + $g_iMidOffsetY)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$g_iStatsLastAttack[$eLootTrophy] = -$g_iStatsLastAttack[$eLootTrophy]
		EndIf
		$g_iStatsLastAttack[$eLootDarkElixir] = ""
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
	EndIf

	If $g_iStatsLastAttack[$eLootTrophy] >= 0 Then
		$iBonusLast = Number(getResourcesBonusPerc(570, 309 + $g_iMidOffsetY))
		If $iBonusLast > 0 Then
			SetLog("Bonus Percentage: " & $iBonusLast & "%")
			Local $iCalcMaxBonus = 0, $iCalcMaxBonusDark = 0

			If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], True), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootGold] = getResourcesBonus(590, 340 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootGold] = StringReplace($g_iStatsBonusLast[$eLootGold], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootElixir] = getResourcesBonus(590, 371 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootElixir] = StringReplace($g_iStatsBonusLast[$eLootElixir], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootDarkElixir] = getResourcesBonus(621, 402 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootDarkElixir] = StringReplace($g_iStatsBonusLast[$eLootDarkElixir], "+", "")

				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]), $COLOR_SUCCESS)
				Else
					$iCalcMaxBonus = Ceiling($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
					$iCalcMaxBonusDark = Ceiling($g_iStatsBonusLast[$eLootDarkElixir] / ($iBonusLast / 100))

					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]) & " out of " & _NumberFormat($iCalcMaxBonusDark), $COLOR_SUCCESS)
				EndIf
			Else
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootGold] = getResourcesBonus(590, 340 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootGold] = StringReplace($g_iStatsBonusLast[$eLootGold], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootElixir] = getResourcesBonus(590, 371 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootElixir] = StringReplace($g_iStatsBonusLast[$eLootElixir], "+", "")
				$g_iStatsBonusLast[$eLootDarkElixir] = 0

				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]), $COLOR_SUCCESS)
				Else
					$iCalcMaxBonus = Number($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus), $COLOR_SUCCESS)
				EndIf
			EndIf

			$g_asLeagueDetailsShort = "--"
			For $i = 1 To 21 ; skip 0 = Bronze III, see "No Bonus" else section below
				If _Sleep($DELAYATTACKREPORT2) Then Return
				If $g_asLeagueDetails[$i][0] = $iCalcMaxBonus Then
					SetLog("Your league level is: " & $g_asLeagueDetails[$i][1])
					$g_asLeagueDetailsShort = $g_asLeagueDetails[$i][3]
					ExitLoop
				EndIf
			Next
		Else
			SetLog("No Bonus")

			$g_asLeagueDetailsShort = "--"
			If $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] >= 400 And $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] < 500 Then ; Bronze III has no League bonus
				SetLog("Your league level is: " & $g_asLeagueDetails[0][1])
				$g_asLeagueDetailsShort = $g_asLeagueDetails[0][3]
			EndIf
		EndIf
		;Display League in Stats ==>
		GUICtrlSetData($g_hLblLeague, "")

		If StringInStr($g_asLeagueDetailsShort, "1") > 1 Then
			GUICtrlSetData($g_hLblLeague, "1")
		ElseIf StringInStr($g_asLeagueDetailsShort, "2") > 1 Then
			GUICtrlSetData($g_hLblLeague, "2")
		ElseIf StringInStr($g_asLeagueDetailsShort, "3") > 1 Then
			GUICtrlSetData($g_hLblLeague, "3")
		EndIf
		_GUI_Value_STATE("HIDE", $g_aGroupLeague)
		If StringInStr($g_asLeagueDetailsShort, "B") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueBronze], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "S") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueSilver], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "G") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueGold], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "c", $STR_CASESENSE) > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueCrystal], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "M") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueMaster], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "C", $STR_CASESENSE) > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueChampion], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "T") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueTitan], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "LE") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueLegend], $GUI_SHOW)
		Else
			GUICtrlSetState($g_ahPicLeague[$eLeagueUnranked], $GUI_SHOW)
		EndIf
		;==> Display League in Stats
	Else
		$g_iStatsBonusLast[$eLootGold] = 0
		$g_iStatsBonusLast[$eLootElixir] = 0
		$g_iStatsBonusLast[$eLootDarkElixir] = 0
		$g_asLeagueDetailsShort = "--"
	EndIf

	; check stars earned
	Local $starsearned = 0
	If _ColorCheck(_GetPixelColor($aWonOneStarAtkRprt[0], $aWonOneStarAtkRprt[1], True), Hex($aWonOneStarAtkRprt[2], 6), $aWonOneStarAtkRprt[3]) Then $starsearned += 1
	If _ColorCheck(_GetPixelColor($aWonTwoStarAtkRprt[0], $aWonTwoStarAtkRprt[1], True), Hex($aWonTwoStarAtkRprt[2], 6), $aWonTwoStarAtkRprt[3]) Then $starsearned += 1
	If _ColorCheck(_GetPixelColor($aWonThreeStarAtkRprt[0], $aWonThreeStarAtkRprt[1], True), Hex($aWonThreeStarAtkRprt[2], 6), $aWonThreeStarAtkRprt[3]) Then $starsearned += 1
	SetLog("Stars earned: " & $starsearned)

	Local $AtkLogTxt
	$AtkLogTxt = "  " & String($g_iCurAccount + 1) & "|" & _NowTime(4) & "|"
	$AtkLogTxt &= StringFormat("%5d", $g_aiCurrentLoot[$eLootTrophy]) & "|"
	$AtkLogTxt &= StringFormat("%3d", $g_iSearchCount) & "|"
	$AtkLogTxt &= StringFormat("%2d", $g_iSidesAttack) & "|"
	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootGold]) & "|"
	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootElixir]) & "|"
	$AtkLogTxt &= StringFormat("%4d", $g_iStatsLastAttack[$eLootDarkElixir]) & "|"
	$AtkLogTxt &= StringFormat("%3d", $g_iStatsLastAttack[$eLootTrophy]) & "|"
	$AtkLogTxt &= StringFormat("%1d", $starsearned) & "|"
	$AtkLogTxt &= StringFormat("%3d", $g_iPercentageDamage) & "|"
	$AtkLogTxt &= StringFormat("%6d", $g_iStatsBonusLast[$eLootGold]) & "|"
	$AtkLogTxt &= StringFormat("%6d", $g_iStatsBonusLast[$eLootElixir]) & "|"
	$AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootDarkElixir]) & "|"
	$AtkLogTxt &= $g_asLeagueDetailsShort & "|"

	; Stats Attack
	$g_sTotalDamage = $g_iPercentageDamage
	$g_sAttacksides = $g_iSidesAttack
	$g_sLootGold = $g_iStatsLastAttack[$eLootGold]
	$g_sLootElixir = $g_iStatsLastAttack[$eLootElixir]
	$g_sLootDE = $g_iStatsLastAttack[$eLootDarkElixir]
	$g_sLeague = $g_asLeagueDetailsShort
	$g_sBonusGold = $g_iStatsBonusLast[$eLootGold]
	$g_sBonusElixir = $g_iStatsBonusLast[$eLootElixir]
	$g_sBonusDE = $g_iStatsBonusLast[$eLootDarkElixir]

	Local $AtkLogTxtExtend
	$AtkLogTxtExtend = "|"
	$AtkLogTxtExtend &= $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & "|"
	If Int($g_iStatsLastAttack[$eLootTrophy]) >= 0 Then
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_BLACK)
	Else
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_ERROR)
	EndIf

	; rename or delete zombie
	If $g_bDebugDeadBaseImage Then
		setZombie($g_iStatsLastAttack[$eLootElixir])
	EndIf

	; Share Replay
	If $g_bShareAttackEnable Then
		If (Number($g_iStatsLastAttack[$eLootGold]) >= Number($g_iShareMinGold)) And (Number($g_iStatsLastAttack[$eLootElixir]) >= Number($g_iShareMinElixir)) And (Number($g_iStatsLastAttack[$eLootDarkElixir]) >= Number($g_iShareMinDark)) Then
			SetLog("Reached miminum Loot values... Share Replay")
			$g_bShareAttackEnableNow = True
		Else
			SetLog("Below miminum Loot values... No Share Replay")
			$g_bShareAttackEnableNow = False
		EndIf
	EndIf

	If $g_iFirstAttack = 0 Then $g_iFirstAttack = 1
	$g_iStatsTotalGain[$eLootGold] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_aiTotalGoldGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_iStatsTotalGain[$eLootElixir] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	$g_aiTotalElixirGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
		$g_iStatsTotalGain[$eLootDarkElixir] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
		$g_aiTotalDarkGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
	EndIf
	$g_iStatsTotalGain[$eLootTrophy] += $g_iStatsLastAttack[$eLootTrophy]
	$g_aiTotalTrophyGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootTrophy]
	If $g_iMatchMode = $TS Then
		If $starsearned > 0 Then
			$g_iNbrOfTHSnipeSuccess += 1
		Else
			$g_iNbrOfTHSnipeFails += 1
		EndIf
	EndIf
	$g_aiAttackedVillageCount[$g_iMatchMode] += 1
	UpdateStats()
	UpdateSDataBase()
	If ProfileSwitchAccountEnabled() Then
		SetSwitchAccLog(" - Acc. " & $g_iCurAccount + 1 & ", Attack: " & $g_aiAttackedCount)
	EndIf
	$g_iActualTrainSkip = 0
	$g_iPercentageDamage = 0
	$g_iSidesAttack = 0

EndFunc   ;==>AttackReport

; *-/ to fix ; #FUNCTION# ====================================================================================================================
; *-/ to fix ; Name ..........: AttackReport
; *-/ to fix ; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
; *-/ to fix ;                  It will also update the statistics to the GUI (Last Attack).
; *-/ to fix ; Syntax ........: AttackReport()
; *-/ to fix ; Parameters ....: None
; *-/ to fix ; Return values .: None
; *-/ to fix ; Author ........: Hervidero (02-2015), Sardo (05-2015), Hervidero (12-2015)
; *-/ to fix ; Modified ......: Sardo (05-2015), Hervidero (05-2015), Knowjack (07-2015)
; *-/ to fix ; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
; *-/ to fix ;                  MyBot is distributed under the terms of the GNU GPL
; *-/ to fix ; Related .......:
; *-/ to fix ; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; *-/ to fix ; Example .......: No
; *-/ to fix ; ===============================================================================================================================
; *-/ to fix 
; *-/ to fix Func AttackReport()
; *-/ to fix 	Static $iBonusLast = 0 ; last attack Bonus percentage
; *-/ to fix 	Local $g_asLeagueDetailsShort = ""
; *-/ to fix 	Local $iCount
; *-/ to fix 
; *-/ to fix     ; samm0d
; *-/ to fix     ;==============================================================================================
; *-/ to fix     Local $iTempStatsLastAttack[UBound($g_iStatsLastAttack)]
; *-/ to fix     Local $iTempOldStatsLastAttack[UBound($g_iStatsLastAttack)]
; *-/ to fix     Local $iTempStatsBonusLast[UBound($g_iStatsBonusLast)]
; *-/ to fix     Local $iTempOldStatsBonusLast[UBound($g_iStatsBonusLast)]
; *-/ to fix     Local $iTempBonusLast, $iTempOldBonusLast
; *-/ to fix     Local $bRedo = True
; *-/ to fix 
; *-/ to fix 
; *-/ to fix     SetLog("Preparing attack report.", $COLOR_INFO)
; *-/ to fix 
; *-/ to fix     $iCount = 0
; *-/ to fix     While $bRedo
; *-/ to fix         $bRedo = False
; *-/ to fix 
; *-/ to fix         Local $wasForce = OcrForceCaptureRegion(False)
; *-/ to fix         _CaptureRegions()
; *-/ to fix 
; *-/ to fix         ; check gold loot got value change.
; *-/ to fix         $iTempStatsLastAttack[$eLootGold] = getResourcesLoot(333, 289 + $g_iMidOffsetY)
; *-/ to fix         If $iTempStatsLastAttack[$eLootGold] <> $iTempOldStatsLastAttack[$eLootGold] Then
; *-/ to fix             $iTempOldStatsLastAttack[$eLootGold] = $iTempStatsLastAttack[$eLootGold]
; *-/ to fix             $bRedo = True
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix         ; check elixir got change value or not
; *-/ to fix         $iTempStatsLastAttack[$eLootElixir] = getResourcesLoot(333, 328 + $g_iMidOffsetY)
; *-/ to fix         If $iTempStatsLastAttack[$eLootElixir] <> $iTempOldStatsLastAttack[$eLootElixir] Then
; *-/ to fix             $iTempOldStatsLastAttack[$eLootElixir] = $iTempStatsLastAttack[$eLootElixir]
; *-/ to fix             $bRedo = True
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix 	If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], True), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
; *-/ to fix 		$g_iStatsLastAttack[$eLootGold] = getResourcesLoot(290, 289 + $g_iMidOffsetY)
; *-/ to fix 		If _Sleep($DELAYATTACKREPORT2) Then Return
; *-/ to fix 		$g_iStatsLastAttack[$eLootElixir] = getResourcesLoot(290, 328 + $g_iMidOffsetY)
; *-/ to fix 		If _Sleep($DELAYATTACKREPORT2) Then Return
; *-/ to fix 		$g_iStatsLastAttack[$eLootDarkElixir] = getResourcesLootDE(365, 365 + $g_iMidOffsetY)
; *-/ to fix 		If _Sleep($DELAYATTACKREPORT2) Then Return
; *-/ to fix 		$g_iStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 402 + $g_iMidOffsetY)
; *-/ to fix             $iTempStatsLastAttack[$eLootDarkElixir] = getResourcesLootDE(365, 365 + $g_iMidOffsetY)
; *-/ to fix             If $iTempStatsLastAttack[$eLootDarkElixir] <> $iTempOldStatsLastAttack[$eLootDarkElixir] Then
; *-/ to fix                 $iTempOldStatsLastAttack[$eLootDarkElixir] = $iTempStatsLastAttack[$eLootDarkElixir]
; *-/ to fix                 $bRedo = True
; *-/ to fix             EndIf
; *-/ to fix             $iTempStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 402 + $g_iMidOffsetY)
; *-/ to fix         Else
; *-/ to fix             $iTempStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 365 + $g_iMidOffsetY)
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix         If $iTempStatsLastAttack[$eLootTrophy] <> $iTempOldStatsLastAttack[$eLootTrophy] Then
; *-/ to fix             $iTempOldStatsLastAttack[$eLootTrophy] = $iTempStatsLastAttack[$eLootTrophy]
; *-/ to fix             $bRedo = True
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix 
; *-/ to fix         If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], $g_bNoCapturePixel), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
; *-/ to fix             $iTempStatsLastAttack[$eLootTrophy] = -$iTempStatsLastAttack[$eLootTrophy]
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix         If $iTempStatsLastAttack[$eLootTrophy] >= 0 Then
; *-/ to fix             $iTempBonusLast = Number(getResourcesBonusPerc(570, 309 + $g_iMidOffsetY))
; *-/ to fix             If ($iTempBonusLast <> $iTempOldBonusLast) Or ($iTempBonusLast = 0) Then
; *-/ to fix                 $iTempOldBonusLast = $iTempBonusLast
; *-/ to fix                 $bRedo = True
; *-/ to fix             Else
; *-/ to fix                 If $iTempBonusLast > 0 Then
; *-/ to fix                     $iTempStatsBonusLast[$eLootGold] = getResourcesBonus(590, 340 + $g_iMidOffsetY)
; *-/ to fix                     $iTempStatsBonusLast[$eLootGold] = StringReplace($iTempStatsBonusLast[$eLootGold], "+", "")
; *-/ to fix                     If $iTempStatsBonusLast[$eLootGold] <> $iTempOldStatsBonusLast[$eLootGold] Then
; *-/ to fix                         $iTempOldStatsBonusLast[$eLootGold] = $iTempStatsBonusLast[$eLootGold]
; *-/ to fix                         $bRedo = True
; *-/ to fix                     EndIf
; *-/ to fix                     $iTempStatsBonusLast[$eLootElixir] = getResourcesBonus(590, 371 + $g_iMidOffsetY)
; *-/ to fix                     $iTempStatsBonusLast[$eLootElixir] = StringReplace($iTempStatsBonusLast[$eLootElixir], "+", "")
; *-/ to fix                     If $iTempStatsBonusLast[$eLootElixir] <> $iTempOldStatsBonusLast[$eLootElixir] Then
; *-/ to fix                         $iTempOldStatsBonusLast[$eLootElixir] = $iTempStatsBonusLast[$eLootElixir]
; *-/ to fix                         $bRedo = True
; *-/ to fix                     EndIf
; *-/ to fix 
; *-/ to fix 		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
; *-/ to fix 			$g_iStatsLastAttack[$eLootTrophy] = -$g_iStatsLastAttack[$eLootTrophy]
; *-/ to fix                         $iTempStatsBonusLast[$eLootDarkElixir] = getResourcesBonus(621, 402 + $g_iMidOffsetY)
; *-/ to fix                         $iTempStatsBonusLast[$eLootDarkElixir] = StringReplace($iTempStatsBonusLast[$eLootDarkElixir], "+", "")
; *-/ to fix                     Else
; *-/ to fix                         $iTempStatsBonusLast[$eLootDarkElixir] = 0
; *-/ to fix                     EndIf
; *-/ to fix                     If $iTempStatsBonusLast[$eLootDarkElixir] <> $iTempOldStatsBonusLast[$eLootDarkElixir] Then
; *-/ to fix                         $iTempOldStatsBonusLast[$eLootDarkElixir] = $iTempStatsBonusLast[$eLootDarkElixir]
; *-/ to fix                         $bRedo = True
; *-/ to fix                     EndIf
; *-/ to fix                 EndIf
; *-/ to fix             EndIf
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix         If $g_iSamM0dDebug = 1 Then
; *-/ to fix             SetLog("Attemp..." & $iCount+1)
; *-/ to fix             SetLog("$iTempStatsLastAttack[$eLootGold]: " & $iTempStatsLastAttack[$eLootGold])
; *-/ to fix             SetLog("$iTempStatsLastAttack[$eLootElixir]: " & $iTempStatsLastAttack[$eLootElixir])
; *-/ to fix             SetLog("$iTempStatsLastAttack[$eLootDarkElixir]: " & $iTempStatsLastAttack[$eLootDarkElixir])
; *-/ to fix             SetLog("$iTempStatsLastAttack[$eLootTrophy]: " & $iTempStatsLastAttack[$eLootTrophy])
; *-/ to fix 
; *-/ to fix             SetLog("$iTempBonusLast: " & $iTempBonusLast)
; *-/ to fix             SetLog("$iTempStatsBonusLast[$eLootGold]: " & $iTempStatsBonusLast[$eLootGold])
; *-/ to fix             SetLog("$iTempStatsBonusLast[$eLootElixir]: " & $iTempStatsBonusLast[$eLootElixir])
; *-/ to fix             SetLog("$iTempStatsBonusLast[$eLootDarkElixir]: " & $iTempStatsBonusLast[$eLootDarkElixir])
; *-/ to fix         EndIf
; *-/ to fix 
; *-/ to fix         OcrForceCaptureRegion($wasForce)
; *-/ to fix         If _Sleep(250) Then Return
; *-/ to fix         If $iCount > 40 Then
; *-/ to fix             Setlog("Return Home scene read loot value error, attack values may not be correct", $COLOR_INFO)
; *-/ to fix             ExitLoop
; *-/ to fix 		EndIf
; *-/ to fix     WEnd
; *-/ to fix     ;==============================================================================================
; *-/ to fix 
; *-/ to fix     ; check stars earned
; *-/ to fix     Local $starsearned = 0
; *-/ to fix     If _ColorCheck(_GetPixelColor($aWonOneStarAtkRprt[0], $aWonOneStarAtkRprt[1], True), Hex($aWonOneStarAtkRprt[2], 6), $aWonOneStarAtkRprt[3]) Then $starsearned += 1
; *-/ to fix     If _ColorCheck(_GetPixelColor($aWonTwoStarAtkRprt[0], $aWonTwoStarAtkRprt[1], True), Hex($aWonTwoStarAtkRprt[2], 6), $aWonTwoStarAtkRprt[3]) Then $starsearned += 1
; *-/ to fix     If _ColorCheck(_GetPixelColor($aWonThreeStarAtkRprt[0], $aWonThreeStarAtkRprt[1], True), Hex($aWonThreeStarAtkRprt[2], 6), $aWonThreeStarAtkRprt[3]) Then $starsearned += 1
; *-/ to fix     SetLog("Stars earned: " & $starsearned)
; *-/ to fix 
; *-/ to fix     $g_iStatsLastAttack[$eLootGold] = $iTempStatsLastAttack[$eLootGold]
; *-/ to fix     $g_iStatsLastAttack[$eLootElixir] = $iTempStatsLastAttack[$eLootElixir]
; *-/ to fix     $g_iStatsLastAttack[$eLootDarkElixir] = $iTempStatsLastAttack[$eLootDarkElixir]
; *-/ to fix     $g_iStatsLastAttack[$eLootTrophy] = $iTempStatsLastAttack[$eLootTrophy]
; *-/ to fix 
; *-/ to fix 
; *-/ to fix     If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], $g_bNoCapturePixel), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
; *-/ to fix 		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
; *-/ to fix 	Else
; *-/ to fix 		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
; *-/ to fix 	EndIf
; *-/ to fix 
; *-/ to fix 	If $g_iStatsLastAttack[$eLootTrophy] >= 0 Then
; *-/ to fix         $iBonusLast = $iTempBonusLast
; *-/ to fix         If $iBonusLast > 0 Then
; *-/ to fix             $g_iStatsBonusLast[$eLootGold] = $iTempStatsBonusLast[$eLootGold]
; *-/ to fix             $g_iStatsBonusLast[$eLootElixir] = $iTempStatsBonusLast[$eLootElixir]
; *-/ to fix             $g_iStatsBonusLast[$eLootDarkElixir] = $iTempStatsBonusLast[$eLootDarkElixir]
; *-/ to fix 
; *-/ to fix 			SetLog("Bonus Percentage: " & $iBonusLast & "%")
; *-/ to fix 			Local $iCalcMaxBonus = 0, $iCalcMaxBonusDark = 0
; *-/ to fix 
; *-/ to fix             If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], $g_bNoCapturePixel), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
; *-/ to fix 
; *-/ to fix 				If $iBonusLast = 100 Then
; *-/ to fix 					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
; *-/ to fix 					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]), $COLOR_SUCCESS)
; *-/ to fix 				Else
; *-/ to fix                     $iCalcMaxBonus = Number($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
; *-/ to fix                     $iCalcMaxBonusDark = Number($g_iStatsBonusLast[$eLootDarkElixir] / ($iBonusLast / 100))
; *-/ to fix 
; *-/ to fix 					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]) & " out of " & _NumberFormat($iCalcMaxBonusDark), $COLOR_SUCCESS)
; *-/ to fix 				EndIf
; *-/ to fix 			Else
; *-/ to fix 
; *-/ to fix 				If $iBonusLast = 100 Then
; *-/ to fix 					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
; *-/ to fix 					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]), $COLOR_SUCCESS)
; *-/ to fix 				Else
; *-/ to fix 					$iCalcMaxBonus = Number($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
; *-/ to fix 					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus), $COLOR_SUCCESS)
; *-/ to fix 				EndIf
; *-/ to fix 			EndIf
; *-/ to fix 
; *-/ to fix 			$g_asLeagueDetailsShort = "--"
; *-/ to fix 			For $i = 1 To 21 ; skip 0 = Bronze III, see "No Bonus" else section below
; *-/ to fix 				If $g_asLeagueDetails[$i][0] = $iCalcMaxBonus Then
; *-/ to fix 					SetLog("Your league level is: " & $g_asLeagueDetails[$i][1])
; *-/ to fix 					$g_asLeagueDetailsShort = $g_asLeagueDetails[$i][3]
; *-/ to fix 					ExitLoop
; *-/ to fix 				EndIf
; *-/ to fix 			Next
; *-/ to fix 		Else
; *-/ to fix             $g_iStatsBonusLast[$eLootGold] = 0
; *-/ to fix             $g_iStatsBonusLast[$eLootElixir] = 0
; *-/ to fix             $g_iStatsBonusLast[$eLootDarkElixir] = 0
; *-/ to fix 
; *-/ to fix 			$g_asLeagueDetailsShort = "--"
; *-/ to fix 			If $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] >= 400 And $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] < 500 Then ; Bronze III has no League bonus
; *-/ to fix 				SetLog("Your league level is: " & $g_asLeagueDetails[0][1])
; *-/ to fix 				$g_asLeagueDetailsShort = $g_asLeagueDetails[0][3]
; *-/ to fix 			EndIf
; *-/ to fix 		EndIf
; *-/ to fix         ;Display League in Stats ==>
; *-/ to fix         GUICtrlSetData($g_hLblLeague, "")
; *-/ to fix 
; *-/ to fix         ;samm0d
; *-/ to fix         If StringInStr($g_asLeagueDetailsShort, "1") > 1 Then
; *-/ to fix             GUICtrlSetData($g_hLblLeague, "1")
; *-/ to fix             $aProfileStats[27][$iCurActiveAcc+1] = 1
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "2") > 1 Then
; *-/ to fix             GUICtrlSetData($g_hLblLeague, "2")
; *-/ to fix             $aProfileStats[27][$iCurActiveAcc+1] = 2
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "3") > 1 Then
; *-/ to fix             GUICtrlSetData($g_hLblLeague, "3")
; *-/ to fix             $aProfileStats[27][$iCurActiveAcc+1] = 3
; *-/ to fix         EndIf
; *-/ to fix         _GUI_Value_STATE("HIDE", $g_aGroupLeague)
; *-/ to fix         If StringInStr($g_asLeagueDetailsShort, "B") > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueBronze], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "B"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "S") > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueSilver], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "S"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "G") > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueGold], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "G"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "c", $STR_CASESENSE) > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueCrystal], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "c"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "M") > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueMaster], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "M"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "C", $STR_CASESENSE) > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueChampion], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "C"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "T") > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueTitan], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "T"
; *-/ to fix         ElseIf StringInStr($g_asLeagueDetailsShort, "LE") > 0 Then
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueLegend], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = "LE"
; *-/ to fix         Else
; *-/ to fix             GUICtrlSetState($g_ahPicLeague[$eLeagueUnranked], $GUI_SHOW)
; *-/ to fix             $aProfileStats[26][$iCurActiveAcc+1] = 0
; *-/ to fix         EndIf
; *-/ to fix         ;==> Display League in Stats
; *-/ to fix     Else
; *-/ to fix 		$g_iStatsBonusLast[$eLootGold] = 0
; *-/ to fix 		$g_iStatsBonusLast[$eLootElixir] = 0
; *-/ to fix 		$g_iStatsBonusLast[$eLootDarkElixir] = 0
; *-/ to fix 		$g_asLeagueDetailsShort = "--"
; *-/ to fix 	EndIf
; *-/ to fix 
; *-/ to fix 	Local $AtkLogTxt
; *-/ to fix 
; *-/ to fix     ; samm0d
; *-/ to fix     If $ichkEnableMySwitch Then
; *-/ to fix         If $iCurActiveAcc <> - 1 Then
; *-/ to fix             $AtkLogTxt = $iCurActiveAcc + 1 & "#"
; *-/ to fix         Else
; *-/ to fix             $AtkLogTxt = "  "
; *-/ to fix         EndIf
; *-/ to fix     Else
; *-/ to fix         $AtkLogTxt = "  "
; *-/ to fix     EndIf
; *-/ to fix     $AtkLogTxt &= "|" & _NowTime(4) & "|"
; *-/ to fix 	$AtkLogTxt = "  " & String($g_iCurAccount + 1) & "|" & _NowTime(4) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%5d", $g_aiCurrentLoot[$eLootTrophy]) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%3d", $g_iSearchCount) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%2d", $g_iSidesAttack) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootGold]) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootElixir]) & "|"
; *-/ to fix     If $numLSpellDrop > 0 Then ;samm0d
; *-/ to fix         $AtkLogTxt &=  "z" & $numLSpellDrop & StringFormat("%5d",$g_iStatsLastAttack[$eLootDarkElixir]) & "|"
; *-/ to fix         $numLSpellDrop = 0
; *-/ to fix     Else
; *-/ to fix         $AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootDarkElixir]) & "|"
; *-/ to fix     EndIf
; *-/ to fix 	$AtkLogTxt &= StringFormat("%3d", $g_iStatsLastAttack[$eLootTrophy]) & "|"
; *-/ to fix     $AtkLogTxt &= StringFormat("%2d", $starsearned) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%3d", $g_iPercentageDamage) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%6d", $g_iStatsBonusLast[$eLootGold]) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%6d", $g_iStatsBonusLast[$eLootElixir]) & "|"
; *-/ to fix 	$AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootDarkElixir]) & "|"
; *-/ to fix     $AtkLogTxt &= $g_asLeagueDetailsShort & "  |"
; *-/ to fix 
; *-/ to fix     ; samm0d
; *-/ to fix     If $ichkEnableMySwitch Then
; *-/ to fix         If $iCurActiveAcc <> - 1 Then
; *-/ to fix             $AtkLogTxt &= " " & $icmbWithProfile[$iCurActiveAcc]
; *-/ to fix         EndIf
; *-/ to fix     EndIf
; *-/ to fix 
; *-/ to fix 	; Stats Attack
; *-/ to fix 	$g_sTotalDamage = $g_iPercentageDamage
; *-/ to fix 	$g_sAttacksides = $g_iSidesAttack
; *-/ to fix 	$g_sLootGold = $g_iStatsLastAttack[$eLootGold]
; *-/ to fix 	$g_sLootElixir = $g_iStatsLastAttack[$eLootElixir]
; *-/ to fix 	$g_sLootDE = $g_iStatsLastAttack[$eLootDarkElixir]
; *-/ to fix 	$g_sLeague = $g_asLeagueDetailsShort
; *-/ to fix 	$g_sBonusGold = $g_iStatsBonusLast[$eLootGold]
; *-/ to fix 	$g_sBonusElixir = $g_iStatsBonusLast[$eLootElixir]
; *-/ to fix 	$g_sBonusDE = $g_iStatsBonusLast[$eLootDarkElixir]
; *-/ to fix 
; *-/ to fix 	Local $AtkLogTxtExtend
; *-/ to fix 	$AtkLogTxtExtend = "|"
; *-/ to fix 	$AtkLogTxtExtend &= $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & "|"
; *-/ to fix 	If Int($g_iStatsLastAttack[$eLootTrophy]) >= 0 Then
; *-/ to fix 		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_BLACK)
; *-/ to fix 	Else
; *-/ to fix 		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_ERROR)
; *-/ to fix 	EndIf
; *-/ to fix 
; *-/ to fix 	; rename or delete zombie
; *-/ to fix 	If $g_bDebugDeadBaseImage Then
; *-/ to fix 		setZombie($g_iStatsLastAttack[$eLootElixir])
; *-/ to fix 	EndIf
; *-/ to fix 
; *-/ to fix 	; Share Replay
; *-/ to fix 	If $g_bShareAttackEnable Then
; *-/ to fix 		If (Number($g_iStatsLastAttack[$eLootGold]) >= Number($g_iShareMinGold)) And (Number($g_iStatsLastAttack[$eLootElixir]) >= Number($g_iShareMinElixir)) And (Number($g_iStatsLastAttack[$eLootDarkElixir]) >= Number($g_iShareMinDark)) Then
; *-/ to fix 			SetLog("Reached miminum Loot values... Share Replay")
; *-/ to fix 			$g_bShareAttackEnableNow = True
; *-/ to fix 		Else
; *-/ to fix 			SetLog("Below miminum Loot values... No Share Replay")
; *-/ to fix 			$g_bShareAttackEnableNow = False
; *-/ to fix 		EndIf
; *-/ to fix 	EndIf
; *-/ to fix 
; *-/ to fix 	If $g_iFirstAttack = 0 Then $g_iFirstAttack = 1
; *-/ to fix 	$g_iStatsTotalGain[$eLootGold] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
; *-/ to fix 	$g_aiTotalGoldGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
; *-/ to fix 	$g_iStatsTotalGain[$eLootElixir] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
; *-/ to fix 	$g_aiTotalElixirGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
; *-/ to fix 	If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
; *-/ to fix 		$g_iStatsTotalGain[$eLootDarkElixir] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
; *-/ to fix 		$g_aiTotalDarkGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
; *-/ to fix 	EndIf
; *-/ to fix 	$g_iStatsTotalGain[$eLootTrophy] += $g_iStatsLastAttack[$eLootTrophy]
; *-/ to fix 	$g_aiTotalTrophyGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootTrophy]
; *-/ to fix 	If $g_iMatchMode = $TS Then
; *-/ to fix 		If $starsearned > 0 Then
; *-/ to fix 			$g_iNbrOfTHSnipeSuccess += 1
; *-/ to fix 		Else
; *-/ to fix 			$g_iNbrOfTHSnipeFails += 1
; *-/ to fix 		EndIf
; *-/ to fix 	EndIf
; *-/ to fix 	$g_aiAttackedVillageCount[$g_iMatchMode] += 1
; *-/ to fix 	UpdateStats()
; *-/ to fix 	UpdateSDataBase()
; *-/ to fix 	If ProfileSwitchAccountEnabled() Then
; *-/ to fix 		SetSwitchAccLog(" - Acc. " & $g_iCurAccount + 1 & ", Attack: " & $g_aiAttackedCount)
; *-/ to fix 	EndIf
; *-/ to fix 	$g_iActualTrainSkip = 0
; *-/ to fix 	$g_iPercentageDamage = 0
; *-/ to fix 	$g_iSidesAttack = 0
; *-/ to fix 
; *-/ to fix EndFunc   ;==>AttackReport
