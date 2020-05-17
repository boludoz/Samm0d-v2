Global $g_iXYOCRTR[4] = [0, 0, 0, 0]

Global $g_hChkModTrain, $lblMyQuickTrain, $cmbMyQuickTrain, $grpOtherTroops, $chkMyTroopsOrder, $cmbTroopSetting, $btnResetTroops, $btnResetOrder, $btnResetSpells, $btnResetSpellOrder, $lblTotalCapacityOfMyTroops, $idProgressbar, _
		$chkDisablePretrainTroops, $chkEnableDeleteExcessTroops, $lblStickToTrainWindow, $txtStickToTrainWindow, $chkForcePreTrainTroops, $txtForcePreTrainStrength
Global $grpSpells, $lblTotalSpell, $txtTotalCountSpell2

Global $lblLightningIcon, $lblHealIcon, $lblRageIcon, $lblJumpSpellIcon, $lblFreezeIcon, $lblCloneIcon, $lblPoisonIcon, $lblEarthquakeIcon, $lblHasteIcon, $lblSkeletonIcon, $lblBatIcon
Global $lblLightningSpell, $lblHealSpell, $lblRageSpell, $lblJumpSpell, $lblFreezeSpell, $lblCloneSpell, $lblPoisonSpell, $lblEarthquakeSpell, $lblHasteSpell, $lblSkeletonSpell, $lblBatSpell
Global $txtNumLightningSpell, $txtNumHealSpell, $txtNumRageSpell, $txtNumJumpSpell, $txtNumFreezeSpell, $txtNumCloneSpell, $txtNumPoisonSpell, $txtNumEarthSpell, $txtNumHasteSpell, $txtNumSkeletonSpell, $txtNumBatSpell
Global $lblTimesLightS, $lblTimesHealS, $lblTimesRageS, $lblTimesJumpS, $lblFreezeS, $lblCloneS, $lblTimesPoisonS, $lblTimesEarthquakeS, $lblTimesHasteS, $lblTimesSkeletonS, $lblTimesBatS

Global $g_bChkModTrain = False
Global $g_aiTroopsMaxCamp[2] = [0, 0]
Global $g_aiSpellsMaxCamp[2] = [0, 0]

Global $COLOR_ELIXIR = 0xDE1AC0
Global $COLOR_DARKELIXIR = 0x301D38

Global $bTempDisAddIdleTime = False ;disable add train idle when train finish soon

Global $ichkMyTroopsOrder = 0
Global $g_sSamM0dImageLocation = @ScriptDir & "\COCBot\SamM0d\Images"
Global $ichkDisablePretrainTroops = 0
Global $g_bDoPrebrewspell = 1
Global $ichkEnableDeleteExcessTroops = 1
Global $ichkForcePreTrainTroops = 1
Global $itxtForcePreTrainStrength = 25
Global $bRestartCustomTrain = False

Global $icmbTroopSetting = 0
Global $icmbMyQuickTrain = 0

Global $txtMyBarb, $txtMyArch, $txtMyGiant, $txtMyGobl, $txtMyWall, $txtMyBall, $txtMyWiza, $txtMyHeal, $txtMyDrag, $txtMyPekk, $txtMyBabyD, $txtMyMine, $txtMyEDrag, $txtMyYeti, _
$txtMyMini, $txtMyHogs, $txtMyValk, $txtMyGole, $txtMyWitc, $txtMyLava, $txtMyBowl, $txtMyIceG

; Ejercito|Tipo de tropa|Setting
Global $g_aMyTroopsSetting[3][22][2]= _
[[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]], _
 [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]], _
 [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]]

; Ejercito|Tipo de tropa|Setting
Global $g_aMySpellsetting[3][11][3] = _
		[[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]], _
		[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]], _
		[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]]
;----------------------
Global $g_iCurElixir = 0
Global $g_iCurDarkElixir = 0
Global $g_iCurGemAmount = 0
; ---------------------
Global $g_iTotalSiegeValue = 0

Global $btnResetSieges, $btnResetSiegeOrder
Global $g_bDoPreSiegebreSiege = 0

Global $grpSieges, $lblTotalSiege

;WallW - BattleB - StoneS - SiegeB
Global $lblWallWIcon, $lblBattleBIcon, $lblStoneSIcon, $lblSiegeBIcon
Global $lblWallWSiege, $lblBattleBSiege, $lblStoneSSiege, $lblSiegeBSiege
Global $txtNumSiegeWallWSiege, $txtNumSiegeBattleBSiege, $txtNumSiegeStoneSSiege, $txtNumSiegeSiegeBSiege
Global $lblTimesWallW, $lblTimesBattleB, $lblTimesStoneS, $lblTimesSiegeB
Global $chkPreSiegeWallW, $chkPreSiegeBattleB, $chkPreSiegeStoneS, $chkPreSiegeSiegeB

Global $g_hTxtTotalCountSiege, $txtTotalCountSiege
Global $chkMySiegesSiegeOrder, $ichkMySiegesSiegeOrder
Global $chkEnableDeleteExcessSieges, $ichkEnableDeleteExcessSieges
Global $chkForcePreSiegeBrewSiege, $ichkForcePreSiegeBrewSiege
Global $chkForcePreciseSiegeBrew, $ichkForcePreciseSiegeBrew
Global $cmbMySiegeWallWSiegeOrder, $cmbMySiegeBattleBSiegeOrder, $cmbMySiegeStoneSSiegeOrder
Global $chkMySiegesOrder, $ichkMySiegesOrder

; Ejercito|Tipo de tropa|Settings
Global $MySiegeSetting[3][4][3] = _
		[[[0, 0, 0], [0, 0, 0], [0, 0, 0]], _
		[[0, 0, 0], [0, 0, 0], [0, 0, 0]], _
		[[0, 0, 0], [0, 0, 0], [0, 0, 0]]]
		
Global $g_bDoPreSiegebrewSiege = 0
Global $g_iMySiegesSize = 0
Global $MySieges[4][5] = _
[["WallW",1,1,0,0], _
["BattleB",2,1,0,0], _
["StoneS",3,1,0,0], _
["SiegeB",4,1,0,0]]

Global $tempDisableBrewSiege = False
Global $g_iTotalSiegeCampSpace = 0

Global $ichkPreSiegeWallW
Global $ichkPreSiegeBattleB
Global $ichkPreSiegeStoneS
; ---------------------

Global $g_iMyTroopsSize = 0
Global $iDarkFixTroop = 13
Global $g_aMyTroopsIcon[22] = [$eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, $eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner, $eIcnElectroDragon, $eIcnYeti, $eIcnMinion, $eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler, $eIcnIceGolem]
Global $g_aMyTroops[22][5] = _
		[["Barb", 1, 1, 0, 0], _
		["Arch", 2, 1, 0, 0], _
		["Giant", 3, 5, 16, 0], _
		["Gobl", 4, 1, 0, 0], _
		["Wall", 5, 2, 0, 0], _
		["Ball", 6, 5, 0, 0], _
		["Wiza", 7, 4, 0, 0], _
		["Heal", 8, 14, 0, 0], _
		["Drag", 9, 20, 0, 0], _
		["Pekk", 10, 25, 0, 0], _
		["BabyD", 11, 10, 0, 0], _
		["Mine", 12, 6, 0, 0], _
		["EDrag", 13, 30, 0, 0], _
		["Yeti", 14, 18, 0, 0], _
		["Mini", 15, 2, 0, 0], _
		["Hogs", 16, 5, 0, 0], _
		["Valk", 17, 8, 0, 0], _
		["Gole", 18, 30, 0, 0], _
		["Witc", 19, 12, 0, 0], _
		["Lava", 20, 30, 0, 0], _
		["Bowl", 21, 6, 0, 0], _
		["IceG", 22, 15, 0, 0]]
;name,order,size,unit quantity,train cost

; Vars
Global $cmbMyBarbOrder, $cmbMyArchOrder, $cmbMyGiantOrder, $cmbMyGoblOrder, $cmbMyWallOrder, $cmbMyBallOrder, $cmbMyWizaOrder, $cmbMyHealOrder, $cmbMyDragOrder, $cmbMyPekkOrder, $cmbMyBabyDOrder, $cmbMyMineOrder, $cmbMyEDragOrder, _
$cmbMyMiniOrder, $cmbMyHogsOrder, $cmbMyValkOrder, $cmbMyGoleOrder, $cmbMyWitcOrder, $cmbMyOrder, $cmbMyLavaOrder, $cmbMyBowlOrder, $cmbMyIceGOrder, $cmbMyYetiOrder

Global $CurBarb = 0, $CurArch = 0, $CurGiant = 0, $CurGobl = 0, $CurWall = 0, $CurBall = 0, $CurWiza = 0, $CurHeal = 0
Global $CurMini = 0, $CurHogs = 0, $CurValk = 0, $CurGole = 0, $CurWitc = 0, $CurLava = 0, $CurBowl = 0, $CurDrag = 0, $CurPekk = 0, $CurBabyD = 0, $CurMine = 0, $CurDrag = 0, $CurIceG = 0, $CurYeti = 0

Global $OnQBarb = 0, $OnQArch = 0, $OnQGiant = 0, $OnQGobl = 0, $OnQWall = 0, $OnQBall = 0, $OnQWiza = 0, $OnQHeal = 0
Global $OnQMini = 0, $OnQHogs = 0, $OnQValk = 0, $OnQGole = 0, $OnQWitc = 0, $OnQLava = 0, $OnQBowl = 0, $OnQDrag = 0, $OnQPekk = 0, $OnQBabyD = 0, $OnQMine = 0, $OnQEDrag = 0, $OnQIceG = 0, $OnQYeti = 0

Global $OnTBarb = 0, $OnTArch = 0, $OnTGiant = 0, $OnTGobl = 0, $OnTWall = 0, $OnTBall = 0, $OnTWiza = 0, $OnTHeal = 0
Global $OnTMini = 0, $OnTHogs = 0, $OnTValk = 0, $OnTGole = 0, $OnTWitc = 0, $OnTLava = 0, $OnTBowl = 0, $OnTDrag = 0, $OnTPekk = 0, $OnTBabyD = 0, $OnTMine = 0, $OnTEDrag = 0, $OnTIceG = 0, $OnTYeti = 0

Global $ReadyBarb = 0, $ReadyArch = 0, $ReadyGiant = 0, $ReadyGobl = 0, $ReadyWall = 0, $ReadyBall = 0, $ReadyWiza = 0, $ReadyHeal = 0
Global $ReadyMini = 0, $ReadyHogs = 0, $ReadyValk = 0, $ReadyGole = 0, $ReadyWitc = 0, $ReadyLava = 0, $ReadyBowl = 0, $ReadyDrag = 0, $ReadyPekk = 0, $ReadyBabyD = 0, $ReadyMine = 0, $ReadyEDrag = 0, $ReadyIceG = 0, $ReadyYeti = 0

; SuperTroops
Global $g_aMySuperTroops[4][5] = _
		[["SuperBarb", 23, 5, 0, 0], _
		["SuperGiant", 24, 10, 0, 0], _
		["SuperGobl", 25, 3, 0, 0], _
		["SuperWall", 26, 8, 0, 0]]

;name,order,size,unit quantity,train cost

; Vars
Global $cmbMySuperBarbOrder, $cmbMySuperGiantOrder, $cmbMySuperGoblOrder, $cmbMySuperWallOrder

Global $CurSuperBarb = 0, $CurSuperGiant = 0, $CurSuperGobl = 0, $CurSuperWall = 0

Global $OnQSuperBarb = 0, $OnQSuperGiant = 0, $OnQSuperGobl = 0, $OnQSuperWall = 0

Global $OnTSuperBarb = 0, $OnTSuperGiant = 0, $OnTSuperGobl = 0, $OnTSuperWall = 0

Global $ReadySuperBarb = 0, $ReadySuperGiant = 0, $ReadySuperGobl = 0, $ReadySuperWall = 0

Global $eSuperGobl = $eSuperBarb + 2 ; fix super gobl

Global $g_aMyTroopsButton[22][3] = _
		[["Barb", 0, 0], _
		["Arch", 1, 0], _
		["Giant", 0, 1], _
		["Gobl", 1, 1], _
		["Wall", 0, 2], _
		["Ball", 1, 2], _
		["Wiza", 0, 3], _
		["Heal", 1, 3], _
		["Drag", 0, 4], _
		["Pekk", 1, 4], _
		["BabyD", 0, 5], _
		["Mine", 1, 5], _
		["EDrag", 0, 6], _
		["Yeti", 1, 7], _
		["Mini", 0, 7], _
		["Hogs", 1, 7], _
		["Valk", 2, 0], _
		["Gole", 3, 0], _
		["Witc", 2, 1], _
		["Lava", 3, 1], _
		["Bowl", 2, 2], _
		["IceG", 2, 2]]
		
Global Enum $eTrainBarb, $eTrainArch, $eTrainGiant, $eTrainGobl, $eTrainWall, $eTrainBall, $eTrainWiza, $eTrainHeal, $eTrainDrag, $eTrainPekk, $eTrainBabyD, $eTrainMine, $eTrainEDrag, _
		$eTrainYeti, $eTrainMini, $eTrainHogs, $eTrainValk, $eTrainGole, $eTrainWitc, $eTrainLava, $eTrainBowl, $eTrainIceG

Global $iDarkFixSpell = 6
Global Enum $eBrewLightning, $eBrewHeal, $eBrewRage, $eBrewJump, $eBrewFreeze, $eBrewClone, $eBrewPoison, $eBrewEarth, $eBrewHaste, $eBrewSkeleton, $eBrewBat
Global $g_aMySpellsButton[11][3] = _
		[["Lightning", 0, 0], _
		["Heal", 1, 0], _
		["Rage", 0, 1], _
		["Jump", 1, 1], _
		["Freeze", 0, 2], _
		["Clone", 1, 2], _
		["Poison", 0, 3], _
		["Earth", 1, 3], _
		["Haste", 0, 4], _
		["Skeleton", 1, 4], _
		["Bat", 1, 4]]

; updated Jun 2018
Global $g_aMyTroopsCost[21][10] = _
		[[8, 25, 40, 60, 100, 150, 200, 250, 300], _                     ; Barbarian
		[8, 50, 80, 120, 200, 300, 400, 500, 600], _                     ; Archer
		[9, 250, 750, 1250, 1750, 2250, 3000, 3500, 4000, 4500], _         ; Giant
		[7, 25, 40, 60, 80, 100, 150, 200], _                              ; Goblin
		[8, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750], _          ; WallBreaker
		[8, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500], _             ; Balloon
		[9, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500], _    ; Wizard
		[5, 5000, 6000, 8000, 10000, 15000], _                            ; Healer
		[7, 18000, 20000, 22000, 24000, 26000, 28000, 30000], _         ; Dragon
		[8, 21000, 24000, 27000, 30000, 33000, 35000, 37000, 39000], _  ; Pekka
		[6, 10000, 11000, 12000, 13000, 14000, 15000], _                 ; BabyDragon
		[6, 4200, 4800, 5200, 5600, 6000, 6400], _                      ; Miner
		[3, 36000, 40000, 44000], _                                       ; ElectroDragon
		[8, 6, 7, 8, 9, 10, 11, 12, 13], _                                 ; Minion
		[8, 40, 45, 52, 58, 65, 90, 115, 140], _                        ; HogRider
		[7, 70, 100, 130, 160, 190, 220, 250], _                          ; Valkyrie
		[8, 300, 375, 450, 525, 600, 675, 750, 825], _                     ; Golem
		[4, 175, 225, 275, 325], _                                          ; Witch
		[5, 390, 450, 510, 570, 630], _                                  ; Lavahound
		[4, 110, 130, 150, 170], _                                         ; Bowler
		[4, 220, 240, 260, 280]]                                         ; IceGolem

Global Enum $enumLightning, $enumHeal, $enumRage, $enumJump, $enumFreeze, $enumClone, $enumPoison, $enumEarth, $enumHaste, $enumSkeleton, $enumBat

Global $CurLightningSpell = 0, $CurHealSpell = 0, $CurRageSpell = 0, $CurJumpSpell = 0, $CurFreezeSpell = 0, $CurCloneSpell = 0, $CurPoisonSpell = 0, $CurHasteSpell = 0, $CurEarthSpell = 0, $CurSkeletonSpell = 0, $CurBatSpell = 0
Global $OnQLightningSpell = 0, $OnQHealSpell = 0, $OnQRageSpell = 0, $OnQJumpSpell = 0, $OnQFreezeSpell = 0, $OnQCloneSpell = 0, $OnQPoisonSpell = 0, $OnQHasteSpell = 0, $OnQEarthSpell = 0, $OnQSkeletonSpell = 0, $OnQBatSpell = 0
Global $OnTLightningSpell = 0, $OnTHealSpell = 0, $OnTRageSpell = 0, $OnTJumpSpell = 0, $OnTFreezeSpell = 0, $OnTCloneSpell = 0, $OnTPoisonSpell = 0, $OnTHasteSpell = 0, $OnTEarthSpell = 0, $OnTSkeletonSpell = 0, $OnTBatSpell = 0
Global $ReadyLightningSpell = 0, $ReadyHealSpell = 0, $ReadyRageSpell = 0, $ReadyJumpSpell = 0, $ReadyFreezeSpell = 0, $ReadyCloneSpell = 0, $ReadyPoisonSpell = 0, $ReadyHasteSpell = 0, $ReadyEarthSpell = 0, $ReadySkeletonSpell = 0, $ReadyBatSpell = 0

Global $chkPreLightning, $chkPreHeal, $chkPreRage, $chkPreJump, $chkPreFreeze, $chkPreClone, $chkPrePoison, $chkPreEarth, $chkPreHaste, $chkPreSkeleton, $chkPreBat

Global $chkMySpellsOrder, $ichkMySpellsOrder
Global $chkEnableDeleteExcessSpells, $ichkEnableDeleteExcessSpells = 1
Global $chkForcePreBrewSpell, $ichkForcePreBrewSpell = 1
Global $cmbMyLightningSpellOrder, $cmbMyHealSpellOrder, $cmbMyRageSpellOrder, $cmbMyJumpSpellOrder, $cmbMyFreezeSpellOrder, $cmbMyCloneSpellOrder, $cmbMyPoisonSpellOrder, $cmbMyEarthSpellOrder, $cmbMyHasteSpellOrder, $cmbMySkeletonSpellOrder, $cmbMyBatSpellOrder

Global $g_iMySpellsSize = 0
Global $g_aMySpells[11][6] = _
		[["Lightning", 1, 2, 0, 0, "LSpell"], _
		["Heal", 2, 2, 0, 0, "HSpell"], _
		["Rage", 3, 2, 0, 0, "RSpell"], _
		["Jump", 4, 2, 0, 0, "JSpell"], _
		["Freeze", 5, 1, 0, 0, "FSpell"], _
		["Clone", 6, 3, 0, 0, "CSpell"], _
		["Poison", 7, 1, 0, 0, "PSpell"], _
		["Earth", 8, 1, 0, 0, "ESpell"], _
		["Haste", 9, 1, 0, 0, "HaSpell"], _
		["Skeleton", 10, 1, 0, 0, "SkSpell"], _
		["Bat", 11, 1, 0, 0, "BtSpell"]]

; updated 28 Jun 2017
Global $g_aMySpellsCost[11][8] = _
		[[7, 15000, 16500, 18000, 20000, 22000, 24000, 26000], _  ;LightningSpell
		[7, 15000, 16500, 18000, 19000, 21000, 23000, 25000], _  ;HealSpell
		[5, 23000, 25000, 27000, 30000, 33000], _                  ;RageSpell
		[3, 23000, 27000, 31000], _                                 ;JumpSpell
		[7, 12000, 13000, 14000, 15000, 16000, 17000, 18000], _  ;FreezeSpell
		[5, 38000, 39000, 41000, 43000, 45000], _                 ;CloneSpell
		[5, 95, 110, 125, 140, 155], _                              ;PoisonSpell
		[4, 125, 140, 160, 180], _                                 ;EarthquakeSpell
		[4, 80, 85, 90, 95], _                                     ;HasteSpell
		[5, 110, 120, 130, 140, 150], _                          ;SkeletonSpell
		[5, 110, 120, 130, 140, 150]]                              ;BatSpell

Global $g_iTroopButtonX = 0
Global $g_iTroopButtonY = 0

Global $ichkPreLightning = 0
Global $ichkPreRage = 0
Global $ichkPreJump = 0
Global $ichkPreHeal = 0
Global $ichkPreFreeze = 0
Global $ichkPreClone = 0
Global $ichkPrePoison = 0
Global $ichkPreHaste = 0
Global $ichkPreSkeleton = 0
Global $ichkPreEarth = 0
Global $ichkPreBat = 0

Global $tempDisableBrewSpell = False
Global $tempDisableTrain = False
Global $g_iTotalSpellCampSpace = 0

Global $g_bRestartCheckTroop = False

Global Const $g_iArmy_EnlargeRegionSizeForScan = 30
Global Const $g_iArmy_RegionSizeForScan = 20
Global Const $g_iArmy_ImageSizeForScan = 16
Global Const $g_iArmy_QtyWidthForScan = 60
Global Const $g_iArmy_OnTrainQtyWidthForScan = 40

Global Const $g_iArmy_Av_Slot_Width = 74
Global Const $g_iArmy_Av_CC_Slot_Width = 74
Global Const $g_iArmy_Av_CC_Spell_Slot_Width = 74
Global Const $g_iArmy_Av_Spell_Slot_Width = 74
Global Const $g_iArmy_Av_Troop_Slot_Width = 74

Global Const $g_iArmy_OnT_Troop_Slot_Width = 70.5

Global $g_aiArmyCap[4] = [113, 167, 193, 181]
Global $g_aiSpellCap[4] = [103, 314, 183, 328]

Global $g_aiArmyAvailableCCSlot[4] = [25, 532, 389, 548]
Global $g_aiArmyAvailableCCSlotQty[4] = [27, 497, 389, 513]
Global $g_aiArmyAvailableCCSpellSlot[4] = [456, 529, 601, 544]
Global $g_aiArmyAvailableCCSpellSlotQty[4] = [458, 497, 601, 513]

Global $g_aiTrainCap[4] = [45, 161, 115, 174]
Global $g_aiArmyOnTrainSlot[4] = [65, 212, 838, 228]
Global $g_aiArmyOnTrainSlotQty[4] = [67, 190, 838, 206]
Global $g_aiArmyAvailableSlot[4] = [22, 230, 840, 246]
Global $g_aiArmyAvailableSlotQty[4] = [24, 198, 840, 213]


Global $g_aiBrewCap[4] = [45, 161, 90, 174]
Global $g_aiArmyOnBrewSlot[4] = [65, 212, 838, 228]
Global $g_aiArmyOnBrewSlotQty[4] = [67, 190, 838, 206]
Global $g_aiArmyAvailableSpellSlot[4] = [22, 372, 840, 388]
Global $g_aiArmyAvailableSpellSlotQty[4] = [24, 343, 840, 358]

