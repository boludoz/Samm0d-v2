; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........:
; Parameters ....:
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ ; Pause tray tip
;~ GUICtrlSetState($chkDisablePauseTrayTip, ($ichkDisablePauseTrayTip = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
; bot log
GUICtrlSetState($chkBotLogLineLimit, ($ichkBotLogLineLimit = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtLogLineLimit, $itxtLogLineLimit)
chkBotLogLineLimit()

; use Event troop
GUICtrlSetState($chkEnableUseEventTroop, ($ichkEnableUseEventTroop = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; donate only when troop pre train ready
GUICtrlSetState($chkEnableDonateWhenReady, ($ichkEnableDonateWhenReady = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; stop bot when low battery
GUICtrlSetState($chkEnableStopBotWhenLowBattery, ($ichkEnableStopBotWhenLowBattery = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; prevent over donate
GUICtrlSetState($chkEnableLimitDonateUnit, ($ichkEnableLimitDonateUnit = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtLimitDonateUnit, $itxtLimitDonateUnit)
chkEnableLimitDonateUnit()

; max logout time
GUICtrlSetState($chkEnableLogoutLimit, ($ichkEnableLogoutLimit = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtLogoutLimitTime, $itxtLogoutLimitTime)
chkEnableLogoutLimit()

; Unit Wave Factor
GUICtrlSetState($chkUnitFactor, ($ichkUnitFactor = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtUnitFactor, $itxtUnitFactor)
GUICtrlSetState($chkWaveFactor, ($ichkWaveFactor = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtWaveFactor, $itxtWaveFactor)
chkUnitFactor()
chkWaveFactor()

; SmartZap from ChaCalGyn (LunaEclipse) - DEMEN
; ExtremeZap - Added by TheRevenor

GUICtrlSetState($chkUseSamM0dZap, ($ichkUseSamM0dZap = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkSmartZapDB, ($ichkSmartZapDB = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkSmartZapSaveHeroes, ($ichkSmartZapSaveHeroes = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

If $itxtMinDE <= 0 Then
	$itxtMinDE = 400
EndIf
GUICtrlSetData($txtMinDark2, $itxtMinDE)

; samm0d zap
GUICtrlSetState($chkSmartZapRnd, ($ichkSmartZapRnd = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkDrillExistBeforeZap, ($ichkDrillExistBeforeZap = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkPreventTripleZap, ($ichkPreventTripleZap = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtMinDEGetFromDrill, $itxtMinDEGetFromDrill)
cmbZapMethod()

; Check Collectors Outside - Added by TheRevenor
GUICtrlSetState($chkDBMeetCollOutside, ($ichkDBMeetCollOutside = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkDBCollectorsNearRedline, ($ichkDBCollectorsNearRedline = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
_GUICtrlComboBox_SetCurSel($cmbRedlineTiles,$icmbRedlineTiles)
GUICtrlSetState($chkSkipCollectorCheckIF, ($ichkSkipCollectorCheckIF = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtDBMinCollOutsidePercent, $iDBMinCollOutsidePercent)
GUICtrlSetData($txtSkipCollectorGold, $itxtSkipCollectorGold)
GUICtrlSetData($txtSkipCollectorElixir, $itxtSkipCollectorElixir)
GUICtrlSetData($txtSkipCollectorDark, $itxtSkipCollectorDark)
GUICtrlSetState($chkSkipCollectorCheckIFTHLevel, ($ichkSkipCollectorCheckIFTHLevel = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtIFTHLevel, $itxtIFTHLevel)
chkDBMeetCollOutside()

; drop cc first
GUICtrlSetState($chkDropCCFirst, ($ichkDropCCFirst = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; Check League For DeadBase
GUICtrlSetState($chkDBNoLeague, ($iChkNoLeague[$DB] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkABNoLeague, ($iChkNoLeague[$LB] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; HLFClick By Samkie
GUICtrlSetState($chkEnableHLFClick, ($ichkEnableHLFClick = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($sldHLFClickDelayTime, $isldHLFClickDelayTime)
chkEnableHLFClick()
sldHLFClickDelayTime()
GUICtrlSetState($chkEnableHLFClickSetlog, ($EnableHMLSetLog = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; samm0d ocr
GUICtrlSetState($chkEnableCustomOCR4CCRequest, ($ichkEnableCustomOCR4CCRequest = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; auto dock
GUICtrlSetState($chkAutoDock, ($ichkAutoDock = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkAutoHideEmulator, ($g_bChkAutoHideEmulator = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkAutoMinimizeBot, ($g_bChkAutoMinimizeBot = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; CSV Deployment Speed Mod
GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
sldSelectedSpeedDB()
sldSelectedSpeedAB()


; check 4 cc
GUICtrlSetState($chkCheck4CC, ($ichkCheck4CC = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtCheck4CCWaitTime, $itxtCheck4CCWaitTime)
chkCheck4CC()

; global delay increse
GUICtrlSetState($chkIncreaseGlobalDelay, ($ichkIncreaseGlobalDelay = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtIncreaseGlobalDelay, $itxtIncreaseGlobalDelay)
chkIncreaseGlobalDelay()

; stick to train page
GUICtrlSetData($txtStickToTrainWindow, $itxtStickToTrainWindow)
txtStickToTrainWindow()

GUICtrlSetState($g_hChkModTrain, ($g_bChkModTrain = True ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkForcePreTrainTroops, ($ichkForcePreTrainTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetData($txtForcePreTrainStrength, $itxtForcePreTrainStrength)
_GUICtrlComboBox_SetCurSel($cmbTroopSetting,$icmbTroopSetting)
_GUICtrlComboBox_SetCurSel($cmbMyQuickTrain,$icmbMyQuickTrain)
GUICtrlSetState($chkDisablePretrainTroops, ($ichkDisablePretrainTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

; My Troops
GUICtrlSetState($chkMyTroopsOrder, ($ichkMyTroopsOrder = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkEnableDeleteExcessTroops, ($ichkEnableDeleteExcessTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

$g_iMyTroopsSize = 0
For $i = 0 To UBound($MyTroops)-1
	GUICtrlSetData(Eval("txtMy" & $MyTroops[$i][0]), $MyTroops[$i][3])
	_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MyTroops[$i][0] & "Order"), $MyTroops[$i][1]-1)
	$g_iMyTroopsSize += $MyTroops[$i][3] * $MyTroops[$i][2]
Next

UpdateTroopSize()

;cmbMyTroopOrder()

; Spells
GUICtrlSetState($chkMySpellsOrder, ($ichkMySpellsOrder = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkEnableDeleteExcessSpells, ($ichkEnableDeleteExcessSpells = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkForcePreBrewSpell, ($ichkForcePreBrewSpell = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

For $i = 0 To UBound($MySpells)-1
	GUICtrlSetState(Eval("chkPre" & $MySpells[$i][0]), (Eval("ichkPre" & $MySpells[$i][0]) = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	GUICtrlSetData(Eval("txtNum" & $MySpells[$i][0] & "Spell"), $MySpells[$i][3])
	_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder"), $MySpells[$i][1]-1)
Next

;cmbMySpellOrder()

GUICtrlSetData($txtTotalCountSpell2, $g_iTotalSpellValue)
lblMyTotalCountSpell()

; Sieges
_GUICtrlComboBox_SetCurSel($g_hTxtTotalCountSiege, $txtTotalCountSiege)

GUICtrlSetState($chkMySiegesSiegeOrder, ($ichkMySiegesSiegeOrder = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkEnableDeleteExcessSieges, ($ichkEnableDeleteExcessSieges = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
GUICtrlSetState($chkForcePreSiegeBrewSiege, ($ichkForcePreSiegeBrewSiege = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))

For $i = 0 To UBound($MySieges)-1
	GUICtrlSetState(Eval("chkPreSiege" & $MySieges[$i][0]), (Eval("ichkPreSiege" & $MySieges[$i][0]) = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	GUICtrlSetData(Eval("txtNumSiege" & $MySieges[$i][0] & "Siege"), $MySieges[$i][3])
	_GUICtrlComboBox_SetCurSel(Eval("cmbMySiege" & $MySieges[$i][0] & "SiegeOrder"), $MySieges[$i][1]-1)
Next

;cmbMySiegeOrder()

lblMyTotalCountSiege()
;
;  Friendly Challenge 
For $i = 0 To 23
	GUICtrlSetState($g_ahChkFriendlyChallengehours[$i], ($g_abFriendlyChallengehours[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
Next
For $i = 0 To 5
	GUICtrlSetState($chkFriendlyChallengeBase[$i], ($ichkFriendlyChallengeBase[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
Next
GUICtrlSetState($chkEnableFriendlyChallenge, $ichkEnableFriendlyChallenge = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
GUICtrlSetState($chkOnlyOnRequest, $ichkOnlyOnRequest = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
GUICtrlSetData($txtKeywordForRequest, $stxtKeywordForRequest)
GUICtrlSetData($txtChallengeText, $stxtChallengeText)
GUICtrlSetData($txtFriendlyChallengeCoolDownTime, $itxtFriendlyChallengeCoolDownTime)

_GUI_Value_STATE("HIDE",$g_aGroupListTHLevels)
If $g_iTownHallLevel >= 4 And $g_iTownHallLevel <= 11 Then
	GUICtrlSetState($g_ahPicTHLevels[$g_iTownHallLevel], $GUI_SHOW)
EndIf

GUICtrlSetData($g_hLblTHLevels, $g_iTownHallLevel)

applyFriendlyChallengeSetting()