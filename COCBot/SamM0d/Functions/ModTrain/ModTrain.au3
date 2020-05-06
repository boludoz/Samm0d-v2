; #FUNCTION# ====================================================================================================================
; Name ..........: ModTrain
; Description ...: SamM0d - Train Troops and Spells System
; Syntax ........: ModTrain()
; Parameters ....: $bDoPreTrain = False
; Return values .: None
; Author ........: Samkie (25 Jun, 2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the term
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ModTrain($ForcePreTrain = False)
	Local $bJustMakeDonateFlag = $bJustMakeDonate
	$bJustMakeDonate = False

	Local $bFullArmyCC = False, $iTotalSpellsToBrew = 0, $bFullArmyHero = False, $aHeroesRegenTime[4]

	If $g_iSamM0dDebug = 1 Then SetLog("Func Train ", $COLOR_DEBUG)
	If $g_bTrainEnabled = False Then Return
	If $g_iMyTroopsSize = 0 Then
		SetLog($CustomTrain_MSG_15, $COLOR_ERROR)
		Return
	EndIf

	Local $bNotStuckJustOnBoost = False
	Local $iCount = 0

	StartGainCost()

	SetLog($CustomTrain_MSG_1, $COLOR_INFO)
	If _Sleep(100) Then Return
	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep(200) Then Return

	If _Sleep(50) Then Return
	checkAttackDisable($g_iTaBChkIdle)
	If $g_bRestart = True Then Return

	If _Wait4Pixel($aButtonOpenTrainArmy[4], $aButtonOpenTrainArmy[5], $aButtonOpenTrainArmy[6], $aButtonOpenTrainArmy[7]) Then
		If $g_iSamM0dDebug = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If IsMainPage() Then
			If $g_bUseRandomClick = False Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf
	EndIf

	If _Sleep(250) Then Return

	; 紧贴着造兵视窗
	$iCount = 0
	While 1
		; 读取造兵剩余时间
		CheckIfArmyIsReadyMod($bFullArmyCC, $iTotalSpellsToBrew, $bFullArmyHero, $aHeroesRegenTime)
		;Setlog($bFullArmyCC & " " & $iTotalSpellsToBrew & " " & $bFullArmyHero)
		;_ArrayDisplay($aHeroesRegenTime)
		;getArmySpellTime()
		If _Sleep(50) Then Return
		; getArmyTroopTime() 读取后会保存造兵时间在变量 $g_aiTimeTrain[0]
		If $ForcePreTrain = False Then
			If $g_aiTimeTrain[0] > $itxtStickToTrainWindow Or $g_aiTimeTrain[0] <= 0 Then
				ExitLoop
			Else
				Local $iStickDelay
				If $g_aiTimeTrain[0] < 1 Then
					$iStickDelay = Int($g_aiTimeTrain[0] * 60000)
				ElseIf $g_aiTimeTrain[0] >= 2 Then
					$iStickDelay = 60000
				Else
					$iStickDelay = 30000
				EndIf
				SetLog($CustomTrain_MSG_2, $COLOR_INFO)
				If _Sleep($iStickDelay) Then Return
			EndIf
		Else
			ExitLoop
		EndIf
		$iCount += 1
		If $iCount > (10 + $itxtStickToTrainWindow) Then ExitLoop
	WEnd
	If $g_iSamM0dDebug = 1 Then SetLog("Before $tempDisableTrain: " & $tempDisableTrain)
	If $g_iSamM0dDebug = 1 Then SetLog("Before $tempDisableBrewSpell: " & $tempDisableBrewSpell)

	TroopsAndSpellsChecker($tempDisableTrain, $tempDisableBrewSpell, $ForcePreTrain)

	If $g_iSamM0dDebug = 1 Then SetLog("After $tempDisableTrain: " & $tempDisableTrain)
	If $g_iSamM0dDebug = 1 Then SetLog("After $tempDisableBrewSpell: " & $tempDisableBrewSpell)

	If gotoArmy() = False Then Return

	If $ichkEnableMySwitch = 1 Then
		Local $aMax[0]


		_ArrayAdd($aMax, $g_aiTimeTrain[0])
		If $g_abSearchSpellsWaitEnable[$DB] Or $g_abSearchSpellsWaitEnable[$LB] Then
			getArmySpellTime()
			_ArrayAdd($aMax, $g_aiTimeTrain[1])
		EndIf
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing Then
			_ArrayAdd($aMax, $aHeroesRegenTime[0])
		EndIf
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen Then
			_ArrayAdd($aMax, $aHeroesRegenTime[1])
		EndIf
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden Then
			_ArrayAdd($aMax, $aHeroesRegenTime[2])
		EndIf
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion Then
			_ArrayAdd($aMax, $aHeroesRegenTime[3])
		EndIf

		Local $iMaxV = _ArrayMax($aMax, 1)
		If $g_iSamM0dDebug = 1 Then SetLog("$iMaxV: " & $iMaxV)
		Local $bIsAttackType = False
		If $iCurActiveAcc <> -1 Then
			For $i = 0 To UBound($aSwitchList) - 1
				If $aSwitchList[$i][4] = $iCurActiveAcc Then
					$aSwitchList[$i][0] = _DateAdd('n', $iMaxV, _NowCalc())
					If _ArrayMax($aMax, 1) Then
						SetLog("Army Ready Time: " & $aSwitchList[$i][0], $COLOR_INFO)
					EndIf
					If $aSwitchList[$i][2] <> 1 Then
						$bIsAttackType = True
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf

		If $ichkEnableContinueStay = 1 Then
			If $bIsAttackType Then
				If $g_iSamM0dDebug = 1 Then SetLog("$itxtTrainTimeLeft: " & $itxtTrainTimeLeft)
				;If $g_iSamM0dDebug = 1 Then SetLog("$iKTime[0]: " & $iKTime[0])
				If $g_iSamM0dDebug = 1 Then SetLog("$iMaxV: " & $iMaxV)
				If $g_iSamM0dDebug = 1 Then SetLog("Before $bAvoidSwitch: " & $bAvoidSwitch)
				$bAvoidSwitch = False
				If $iMaxV <= 0 Then
					$bAvoidSwitch = True
				Else
					If $itxtTrainTimeLeft >= $iMaxV Then
						$bAvoidSwitch = True
					EndIf
				EndIf
				If $g_iSamM0dDebug = 1 Then SetLog("After $bAvoidSwitch: " & $bAvoidSwitch)
			EndIf
		EndIf
	EndIf

	;getArmyCCStatus()
	;If _Sleep(50) Then Return ; 50ms improve pause button response

	If $g_iSamM0dDebug = 1 Then Setlog("Fullarmy = " & $g_bFullArmy & " CurCamp = " & $g_CurrentCampUtilization & " TotalCamp = " & $g_iTotalCampSpace & " - result = " & ($g_bFullArmy = True And $g_CurrentCampUtilization = $g_iTotalCampSpace), $COLOR_DEBUG)
	If $g_bFullArmy = True Then
		SetLog($CustomTrain_MSG_4, $COLOR_SUCCESS, "Times New Roman", 10)
		If $g_bNotifyTGEnable And $g_bNotifyAlertCampFull Then PushMsg("CampFull")
	EndIf

	If _Sleep(200) Then Return
	ClickP($aAway, 1, 250, "#0504")
	If _Sleep(250) Then Return

	$g_bFirstStart = False

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	If _Sleep(200) Then Return

	EndGainCost("Train")
	UpdateStats()

	If $g_bFullArmy And $g_bFullArmySpells And $bFullArmyHero And $bFullArmyCC Then
		$g_bIsFullArmywithHeroesAndSpells = True
	Else
		If $g_bDebugSetlog Then
			SetDebugLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
			SetDebugLog(" $g_bFullArmySpells: " & String($g_bFullArmySpells), $COLOR_DEBUG)
			SetDebugLog(" $bFullArmyHero: " & String($bFullArmyHero), $COLOR_DEBUG)
			SetDebugLog(" $bFullArmyCC: " & String($bFullArmyCC), $COLOR_DEBUG)
		EndIf
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf
	If $g_bFullArmy And $g_bFullArmySpells And $bFullArmyHero Then ; Force Switch while waiting for CC in SwitchAcc
		If Not $bFullArmyCC Then $g_bWaitForCCTroopSpell = True
		If $ichkEnableMySwitch = 1 Then
			; If waiting for cc or cc spell, ignore stay to the account, cause you don't know when the cc or spell will be ready.
			If $g_iSamM0dDebug = 1 Then SetLog("Disable Avoid Switch cause of waiting cc or cc spell enable.")
			$bAvoidSwitch = False
		EndIf
	EndIf

	Local $sLogText = ""
	If Not $g_bFullArmy Then $sLogText &= " Troops,"
	If Not $g_bFullArmySpells Then $sLogText &= " Spells,"
	If Not $bFullArmyHero Then $sLogText &= " Heroes,"
	If Not $bFullArmyCC Then $sLogText &= " Clan Castle,"
	If StringRight($sLogText, 1) = "," Then $sLogText = StringTrimRight($sLogText, 1) ; Remove last "," as it is not needed

	If $g_bIsFullArmywithHeroesAndSpells Then
		If $g_bNotifyTGEnable And $g_bNotifyAlertCampFull Then PushMsg("CampFull")
		SetLog("Chief, is your Army ready? Yes, it is!", $COLOR_SUCCESS)
	Else
		SetLog("Chief, is your Army ready? No, not yet!", $COLOR_ACTION)
		If $sLogText <> "" Then SetLog(@TAB & "Waiting for " & $sLogText, $COLOR_ACTION)
	EndIf

	; Force to Request CC troops or Spells
	If Not $bFullArmyCC Then $g_bCanRequestCC = True
	If $g_bDebugSetlog Then
		SetDebugLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
		SetDebugLog(" $bCheckCC: " & String($bFullArmyCC), $COLOR_DEBUG)
		SetDebugLog(" $g_bIsFullArmywithHeroesAndSpells: " & String($g_bIsFullArmywithHeroesAndSpells), $COLOR_DEBUG)
		SetDebugLog(" $g_iTownHallLevel: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
	EndIf

	If $g_iSamM0dDebug = 1 Then SetLog("$g_bIsFullArmywithHeroesAndSpells: " & $g_bIsFullArmywithHeroesAndSpells)

EndFunc   ;==>ModTrain

Func CheckArmyCampMod($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bGetHeroesTime = False, $bSetLog = True)
	If $g_bDebugFuncTime Then StopWatchStart("checkArmyCamp")

	If $g_bDebugSetlogTrain Then SetLog("Begin checkArmyCamp:", $COLOR_DEBUG1)

	If $g_bDebugFuncTime Then StopWatchStart("IsTrainPage/openArmyOverview")

	If $g_bDebugFuncTime Then StopWatchStart("getArmyTroopTime")
	getArmyTroopTime(False, False, False, $bSetLog) ; Last parameter is to check the Army Window
	If $g_bDebugFuncTime Then StopWatchStopLog()
	If _Sleep($DELAYCHECKARMYCAMP6) Then Return ; 10ms improve pause button response

	Local $HeroesRegenTime
	If $g_bDebugFuncTime Then StopWatchStart("getArmyHeroCount")
	getArmyHeroCount(False, False, False, $bSetLog) ; Last parameter is to check the Army Window
	If $g_bDebugFuncTime Then StopWatchStopLog()
	If _Sleep($DELAYCHECKARMYCAMP6) Then Return ; 10ms improve pause button response

	If $bGetHeroesTime Then
		If $g_bDebugFuncTime Then StopWatchStart("getArmyHeroTime")
		$HeroesRegenTime = getArmyHeroTime("all")
		If $g_bDebugFuncTime Then StopWatchStopLog()
		If _Sleep($DELAYCHECKARMYCAMP6) Then Return ; 10ms improve pause button response
	EndIf

	If $g_bDebugFuncTime Then StopWatchStart("getArmySpellCapacity")
	getArmySpellCapacity(False, False, False, $bSetLog) ; Last parameter is to check the Army Window
	If $g_bDebugFuncTime Then StopWatchStopLog()
	If _Sleep($DELAYCHECKARMYCAMP6) Then Return ; 10ms improve pause button response

	If $g_bDebugFuncTime Then StopWatchStart("getArmySpellTime")
	getArmySpellTime(False, False, False, $bSetLog) ; Last parameter is to check the Army Window
	If $g_bDebugFuncTime Then StopWatchStopLog()
	If _Sleep($DELAYCHECKARMYCAMP6) Then Return ; 10ms improve pause button response

	If $g_bDebugFuncTime Then StopWatchStart("getArmySiegeMachines")
	getArmySiegeMachines(False, False, False, $bSetLog) ; Last parameter is to check the Army Window
	If $g_bDebugFuncTime Then StopWatchStopLog()
	If _Sleep($DELAYCHECKARMYCAMP6) Then Return ; 10ms improve pause button response

	If $g_bDebugSetlogTrain Then SetLog("End checkArmyCamp: canRequestCC= " & $g_bCanRequestCC & ", fullArmy= " & $g_bFullArmy, $COLOR_DEBUG)

	If $g_bDebugFuncTime Then StopWatchStopLog()
	Return $HeroesRegenTime

EndFunc   ;==>checkArmyCamp

Func CheckIfArmyIsReadyMod(ByRef $bFullArmyCC, ByRef $iTotalSpellsToBrew, ByRef $bFullArmyHero, ByRef $aHeroesRegenTime)

	If Not $g_bRunState Then Return
	
	Local $aFakeArray[4]
	
	$g_bWaitForCCTroopSpell = False ; reset for waiting CC in SwitchAcc

	$aHeroesRegenTime = CheckArmyCampMod(False, False, True, True)
	
	If not IsArray($aHeroesRegenTime) Then $aHeroesRegenTime = $aFakeArray

	; add to the hereos available, the ones upgrading so that it ignores them... we need this logic or the bitwise math does not work out correctly
	$g_iHeroAvailable = BitOR($g_iHeroAvailable, $g_iHeroUpgradingBit)
	$bFullArmyHero = (BitAND($g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$DB] And $g_abAttackTypeEnable[$DB]) Or _
			(BitAND($g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$LB] And $g_abAttackTypeEnable[$LB]) Or _
			($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone)

	If $g_bDebugSetlogTrain Then
		Setlog("Heroes are Ready: " & String($bFullArmyHero))
		Setlog("Heroes Available Num: " & $g_iHeroAvailable) ;  	$eHeroNone = 0, $eHeroKing = 1, $eHeroQueen = 2, $eHeroWarden = 4, $eHeroChampion = 5
		Setlog("Search Hero Wait Enable [$DB] Num: " & $g_aiSearchHeroWaitEnable[$DB]) ; 	what you are waiting for : 1 is King , 3 is King + Queen , etc etc
		Setlog("Search Hero Wait Enable [$LB] Num: " & $g_aiSearchHeroWaitEnable[$LB])
		Setlog("Dead Base BitAND: " & BitAND($g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable))
		Setlog("Live Base BitAND: " & BitAND($g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable))
		Setlog("Are you 'not' waiting for Heroes: " & String($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone))
		Setlog("Is Wait for Heroes Active : " & IsWaitforHeroesActive())
	EndIf

	$bFullArmyCC = IsFullClanCastle()

	; If Drop Trophy with Heroes is checked and a Hero is Available or under the trophies range, then set $g_bFullArmyHero to True
	If Not IsWaitforHeroesActive() And $g_bDropTrophyUseHeroes Then $bFullArmyHero = True
	If Not IsWaitforHeroesActive() And Not $g_bDropTrophyUseHeroes And Not $bFullArmyHero Then
		If $g_iHeroAvailable > 0 Or Number($g_aiCurrentLoot[$eLootTrophy]) <= Number($g_iDropTrophyMax) Then
			$bFullArmyHero = True
		Else
			SetLog("Waiting for Heroes to drop trophies!", $COLOR_ACTION)
		EndIf
	EndIf

EndFunc   ;==>CheckIfArmyIsReadyMod

Func TroopsAndSpellsChecker($bDisableTrain = True, $bDisableBrewSpell = True, $bForcePreTrain = False)
	If $g_iSamM0dDebug = 1 Then SETLOG("Begin TroopsAndSpellsChecker:", $COLOR_DEBUG1)

	Local $hTimer = __TimerInit()
	Local $iCount = 0

	While 1
		Local $iCount2 = 0
		Local $bTroopCheckOK = False
		Local $bSpellCheckOK = False

		$g_bRestartCheckTroop = False

		; 预防进入死循环
		$iCount += 1
		If $iCount > 8 Then
			ExitLoop
		EndIf

		; 首先截获列队中的图像，然后去造兵界面截获排队中的图像
		;---------------------------------------------------
		If gotoArmy() = False Then ExitLoop
		If _Sleep(250) Then ExitLoop
		$iCount2 = 0
		While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
			If _Sleep(1000) Then ExitLoop
			$iCount2 += 1
			If $iCount2 >= 30 Then
				ExitLoop
			EndIf
		WEnd
		
		getMySpellCapacityMini()
		ArrayCheckAvailableSpell() ; exbit

		If $bDisableBrewSpell = False Then
			; reset Global variables
			For $i = 0 To UBound($g_aMySpells) - 1
				Assign("Cur" & $g_aMySpells[$i][0] & "Spell", 0)
				Assign("OnQ" & $g_aMySpells[$i][0] & "Spell", 0)
				Assign("OnT" & $g_aMySpells[$i][0] & "Spell", 0)
				Assign("Ready" & $g_aMySpells[$i][0] & "Spell", 0)
			Next

			If gotoBrewSpells() = False Then ExitLoop
			If _Sleep(500) Then Return
			
			$iCount2 = 0
			While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
				If _Sleep(1000) Then ExitLoop
				$iCount2 += 1
				If $iCount2 >= 30 Then
					ExitLoop
				EndIf
			WEnd

			_CaptureRegion2()
			getBrewSpellCapacityMini()

			If $g_aiSpellsMaxCamp[0] = 0 Then
				DoRevampSpells()
				If $bForcePreTrain Then
					ContinueLoop
				EndIf
			Else
				If CheckAvailableSpellUnit() Then
					If CheckOnBrewUnit() Then

						Local $iId = 0
						Select
							Case $g_iCurrentSpells >= $g_iMySpellsSize And $g_aiSpellsMaxCamp[0] >= $g_iMySpellsSize
								$iId = 1
								If $g_bDoPrebrewspell = 0 And not BitAND($g_iTotalSpellValue - $g_iMySpellsSize = 1, $ichkForcePreBrewSpell = 1) = True Then
									SetLog("Pre-brew spell disable by user.", $COLOR_INFO)
									$tempDisableBrewSpell = True
								Else
									DoRevampSpells(True)
								EndIf
							Case $g_iCurrentSpells < $g_iMySpellsSize And $g_aiSpellsMaxCamp[0] >= $g_iMySpellsSize
								$iId = 2
								If $bForcePreTrain Or $ichkForcePreBrewSpell Then
									If $g_bDoPrebrewspell = 0 And not BitAND($g_iTotalSpellValue - $g_iMySpellsSize = 1, $ichkForcePreBrewSpell = 1) = True Then
										SetLog("Pre-brew spell disable by user.", $COLOR_INFO)
										$tempDisableBrewSpell = True
									Else
										DoRevampSpells(True)
									EndIf
								EndIf
							Case $g_iCurrentSpells < $g_iMySpellsSize And $g_aiSpellsMaxCamp[0] < $g_iMySpellsSize
								$iId = 3
								DoRevampSpells()
								If $bForcePreTrain Or $ichkForcePreBrewSpell Then
									ContinueLoop
								EndIf
							Case Else
								SetLog("Error: cannot meet any condition to Do Revamp Spells.", $COLOR_RED)
						EndSelect
						If $g_iSamM0dDebug = 1 Then
							Setlog("$iId: " & $iId)
							SetLog("$g_iCurrentSpells: " & $g_iCurrentSpells, $COLOR_RED)
							SetLog("$g_iMySpellsSize: " & $g_iMySpellsSize, $COLOR_RED)
							SetLog("$g_aiSpellsMaxCamp[0]: " & $g_aiTroopsMaxCamp[0], $COLOR_RED)
							SetLog("$g_aiSpellsMaxCamp[1]: " & $g_aiTroopsMaxCamp[1], $COLOR_RED)
						EndIf
						$bSpellCheckOK = True
					EndIf
				EndIf
			EndIf
			If $g_bRestartCheckTroop Then ContinueLoop
		Else
			$bSpellCheckOK = True
		EndIf

		If gotoArmy() = False Then ExitLoop ; exbit
		If _Sleep(1000) Then Return
		
		Local $aTempTroops = $g_aMyTroops
		SuperTroopsCorrectArray($aTempTroops)
		
		getMyArmyCapacityMini() ; exbit
		ArrayCheckAvailableUnit() ; exbit

		If $bDisableTrain = False Then
			;====Reset the variable======
			For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
				$g_avDTtroopsToBeUsed[$i][1] = 0
			Next

			; reset Global variables for Super Troops
			For $i = 0 To UBound($aTempTroops) - 1
				Assign("cur" & $aTempTroops[$i][0], 0)
				Assign("OnQ" & $aTempTroops[$i][0], 0)
				Assign("OnT" & $aTempTroops[$i][0], 0)
				Assign("Ready" & $aTempTroops[$i][0], 0)
			Next
			;============================

			If gotoTrainTroops() = False Then ExitLoop
			If _Sleep(500) Then Return
			$iCount2 = 0
			While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
				If _Sleep(1000) Then ExitLoop
				$iCount2 += 1
				If $iCount2 >= 30 Then
					ExitLoop
				EndIf
			WEnd
			_CaptureRegion2()
			getTrainArmyCapacityMini()

			If $g_aiTroopsMaxCamp[0] = 0 Then
				DoRevampTroops()
				If $bForcePreTrain Then
					ContinueLoop
				EndIf
			Else
				If CheckAvailableUnit() Then
					If CheckOnTrainUnit() Then
						Local $bPreTrainFlag = $bForcePreTrain
						If $ichkForcePreTrainTroops Then
							If $g_iArmyCapacity >= $itxtForcePreTrainStrength Then
								$bPreTrainFlag = True
							EndIf
						EndIf

						Local $iFullArmyCamp = Int(($g_iMyTroopsSize * $g_iTrainArmyFullTroopPct) / 100)
						Select
							Case $g_CurrentCampUtilization = $iFullArmyCamp And $g_aiTroopsMaxCamp[0] = $iFullArmyCamp
								If $icmbMyQuickTrain = 0 Then
									If $ichkDisablePretrainTroops = 1 Then
										SetLog("Pre-train troops disable by user.", $COLOR_INFO)
										$tempDisableTrain = True
									Else
										DoRevampTroops(True)
									EndIf
								ElseIf $icmbMyQuickTrain = 4 Then
									DoMyQuickTrain(1)
									DoMyQuickTrain(2)
									DoMyQuickTrain(3)
								Else
									DoMyQuickTrain($icmbMyQuickTrain)
								EndIf
							Case $g_CurrentCampUtilization >= $iFullArmyCamp And $g_aiTroopsMaxCamp[0] > $iFullArmyCamp
								If $ichkDisablePretrainTroops = 1 Then
									SetLog("Pre-train troops disable by user.", $COLOR_INFO)
									$tempDisableTrain = True
								Else
									DoRevampTroops(True)
								EndIf
							Case $g_CurrentCampUtilization < $iFullArmyCamp And $g_aiTroopsMaxCamp[0] > $iFullArmyCamp
								If $bPreTrainFlag Then
									If $ichkDisablePretrainTroops = 1 Then
										SetLog("Pre-train troops disable by user.", $COLOR_INFO)
										$tempDisableTrain = True
									Else
										DoRevampTroops(True)
									EndIf
								EndIf
							Case $g_CurrentCampUtilization < $iFullArmyCamp And $g_aiTroopsMaxCamp[0] = $iFullArmyCamp
								If $bPreTrainFlag Then
									If $icmbMyQuickTrain = 0 Then
										If $ichkDisablePretrainTroops = 1 Then
											SetLog("Pre-train troops disable by user.", $COLOR_INFO)
											$tempDisableTrain = True
										Else
											DoRevampTroops(True)
										EndIf
									ElseIf $icmbMyQuickTrain = 4 Then
										DoMyQuickTrain(1)
										DoMyQuickTrain(2)
										DoMyQuickTrain(3)
									Else
										DoMyQuickTrain($icmbMyQuickTrain)
									EndIf
								EndIf
							Case $g_CurrentCampUtilization < $iFullArmyCamp And $g_aiTroopsMaxCamp[0] < $iFullArmyCamp
								DoRevampTroops()
								If $bPreTrainFlag Then
									ContinueLoop
								EndIf
							Case Else
								SetLog("Error: cannot meet any condition to Do Revamp Troops.", $COLOR_RED)
								If $g_iSamM0dDebug = 1 Then
									SetLog("$g_CurrentCampUtilization: " & $g_CurrentCampUtilization, $COLOR_RED)
									SetLog("$iFullArmyCamp: " & $iFullArmyCamp, $COLOR_RED)
									SetLog("$g_aiTroopsMaxCamp[0]: " & $g_aiTroopsMaxCamp[0], $COLOR_RED)
									SetLog("$g_aiTroopsMaxCamp[1]: " & $g_aiTroopsMaxCamp[1], $COLOR_RED)
								EndIf
						EndSelect
						$bTroopCheckOK = True
					EndIf
				EndIf
			EndIf
			If $g_bRestartCheckTroop Then ContinueLoop
		Else
			$bTroopCheckOK = True
		EndIf

		If $bTroopCheckOK And $bSpellCheckOK Then ExitLoop
	WEnd

	;If $g_iSamM0dDebugImage = 1 Then SaveAndDebugTrainImage()

	If $g_iSamM0dDebug = 1 Then SetLog("$hTimer: " & Round(__TimerDiff($hTimer) / 1000, 2))
EndFunc   ;==>TroopsAndSpellsChecker

Func IsQueueBlockByMsg($iCount)
	ForceCaptureRegion()
	_CaptureRegion()
	Select
		; Msg: Troops removed
		Case _ColorCheck(_GetPixelColor(391, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(487, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(1)
			; Msg: Spells removed
		Case _ColorCheck(_GetPixelColor(392, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(458, 209, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(2)

			; Msg: Gold storages full (red text)
		Case _ColorCheck(_GetPixelColor(242, 209, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(317, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(3)
			; Msg: Elixir storages full (red text)
		Case _ColorCheck(_GetPixelColor(318, 213, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(391, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(4)
			; Msg: Dark Elixir storages full (red text)
		Case _ColorCheck(_GetPixelColor(168, 214, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(242, 214, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(5)

			; Msg: The request was sent!
		Case _ColorCheck(_GetPixelColor(316, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(462, 209, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(6)

			; Msg: Army added to training queues!
		Case _ColorCheck(_GetPixelColor(324, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(460, 209, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(7)

			; Msg: Not enough space in training queues (red text)
		Case _ColorCheck(_GetPixelColor(258, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(485, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(8)

			; Msg: Not enough storage space (red text)
		Case _ColorCheck(_GetPixelColor(319, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(537, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(9)

			; donate message
;~ 		Case _ColorCheck(_GetPixelColor(245, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(301, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(360, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
;~ 			Return SetLogAndReturn(99)
		Case Else
			For $i = 130 To 330 Step +2
				If _ColorCheck(_GetPixelColor($i, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor($i + 42, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) Then
					If $iCount = 0 And ($g_iChkWait4CC Or $g_iChkWait4CCSpell) Then
						Local $hClone = _GDIPlus_BitmapCloneArea($g_hBitmap, 20, 198, 820, 24, $GDIP_PXF24RGB)
						Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
						Local $Time = @HOUR & "." & @MIN & "." & @SEC
						Local $filename = String(@ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\SamM0d Debug\Images\Msg Block_" & $Date & "_" & $Time & ".png")
						_GDIPlus_ImageSaveToFile($hClone, $filename)
						_GDIPlus_BitmapDispose($hClone)
					EndIf
					Return SetLogAndReturn(99)
				EndIf
			Next
	EndSelect
	If _Sleep(1000) Then Return False
	Return False
EndFunc   ;==>IsQueueBlockByMsg

Func SetLogAndReturn($iMsg)
	Local $sMsg
	Switch $iMsg
		Case 1
			$sMsg = "Troops removed"
		Case 2
			$sMsg = "Spells removed"
		Case 3
			$sMsg = "Gold Storages Full"
		Case 4
			$sMsg = "Elixir Storages Full"
		Case 5
			$sMsg = "Dark Elixir Storages Full"
		Case 6
			$sMsg = "The request was sent!"
		Case 7
			$sMsg = "Army added to training queues!"
		Case 8
			$sMsg = "Not enough space in training queues"
		Case 9
			$sMsg = "Not enough storage space"
		Case Else
			$sMsg = "Donate or other message"
	EndSwitch
	If $g_iSamM0dDebug = 1 Then SetLog("[" & $sMsg & "] - block for detection troops or spells.", $COLOR_RED)
	Return True
EndFunc   ;==>SetLogAndReturn
