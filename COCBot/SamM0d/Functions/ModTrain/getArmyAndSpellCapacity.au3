; #FUNCTION# ====================================================================================================================
; Name ..........: getCCCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getCCCapacity()
; Parameters ....:
;
; Return values .: None
; Author ........:
; Modified ......: Samkie (19 JUN 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getMyArmyCCCapacity()
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("Begin getCCCapacity:", $COLOR_DEBUG1)
	; reset global variable
	$g_FullCCTroops = False

	Local $aGetCCSize[3] = ["", "", ""]
	Local $sCCInfo = ""
	Local $iCount

	$iCount = 0 ; reset loop safety exit counter
	While 1
		$sCCInfo = getMyOcrCCCap()
		If $g_iSamM0dDebug = 1 Then Setlog("$sCCInfo = " & $sCCInfo, $COLOR_DEBUG)
		$aGetCCSize = StringSplit($sCCInfo, "#")
		If IsArray($aGetCCSize) Then
			If $aGetCCSize[0] > 1 Then
				If Number($aGetCCSize[2]) < 10 Or Mod(Number($aGetCCSize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_iSamM0dDebug = 1 Then Setlog(" OCR value is not valid cc camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$CurTotalCCCamp = Number($aGetCCSize[2])
				$CurCCCamp = Number($aGetCCSize[1])
				$CCCapacity = Int($CurCCCamp / $CurTotalCCCamp * 100)
				SetLog("Clan Castle troops: " & $CurCCCamp & "/" & $CurTotalCCCamp & " (" & $CCCapacity & "%)")
				ExitLoop
			Else
				$CurCCCamp = 0
				$CurTotalCCCamp = 0
			EndIf
		Else
			$CurCCCamp = 0
			$CurTotalCCCamp = 0
		EndIf
		$iCount += 1
		If $iCount > 30 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
		If _Sleep(250) Then Return
	WEnd

	If $CurCCCamp = 0 And $CurTotalCCCamp = 0 Then
		Setlog("CC Troop size read error...", $COLOR_ERROR) ; log if there is read error
		$g_FullCCTroops = False
		Return
	EndIf

	If ($CurCCCamp >= ($CurTotalCCCamp * $CCStrength / 100)) Then
		$g_FullCCTroops = True
	EndIf

	If $g_iChkWait4CC = 1 Then
		If $g_FullCCTroops = False Then
			SETLOG(" All mode - Waiting clan castle troops before start attack.", $COLOR_ACTION)
		EndIf
	Else
		If $g_FullCCTroops = False Then
			Local $i
			Local $bIsWaitForCCTroopsEnable = False
			For $i = $DB To $LB
				If $g_abAttackTypeEnable[$i] Then
;~ 					If $g_abSearchCastleTroopsWaitEnable[$i] Then
;~ 						SETLOG(" " & $g_asModeText[$i] & " Setting - Waiting for Clan Castle Troops.", $COLOR_ACTION)
;~ 						$bIsWaitForCCTroopsEnable = True
;~ 					EndIf
				EndIf
			Next
			If $bIsWaitForCCTroopsEnable = False Then
				SETLOG("Not waiting for clan castle troop.", $COLOR_ACTION)
				$g_FullCCTroops = True
			EndIf
		EndIf
	EndIf
	If $ichkRequestCC4Troop = 1 Then
		$g_bNeedRequestCCTroop = $CurCCCamp < ($CurTotalCCCamp * $itxtRequestCC4Troop / 100)
	EndIf
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("End getCCCapacity:", $COLOR_DEBUG1)
EndFunc   ;==>getMyArmyCCCapacity

Func getMyArmyCCSpellCapacity()
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("Begin getMyArmyCCSpellCapacity:", $COLOR_DEBUG1)
	; reset global variable
	$g_bFullCCSpells = False

	Local $aGetCCSpellSize[3] = ["", "", ""]
	Local $sCCSpellInfo = ""
	Local $iCount

	$iCount = 0 ; reset loop safety exit counter
	While 1
		$sCCSpellInfo = getMyOcrCCSpellCap()
		If $g_iSamM0dDebug = 1 Then Setlog("$sCCSpellInfo = " & $sCCSpellInfo, $COLOR_DEBUG)
		If $sCCSpellInfo = "" And $iCount > 1 Then ExitLoop
		$aGetCCSpellSize = StringSplit($sCCSpellInfo, "#")
		If IsArray($aGetCCSpellSize) Then
			If $aGetCCSpellSize[0] > 1 Then
				If Number($aGetCCSpellSize[2]) > 2 And $aGetCCSpellSize[2] = 0 Then
					If $g_iSamM0dDebug = 1 Then Setlog(" OCR value is not valid cc spell camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$g_iCurTotalCCSpellCamp = Number($aGetCCSpellSize[2])
				$g_iCurCCSpellCamp = Number($aGetCCSpellSize[1])
				SetLog("Clan Castle spells: " & $g_iCurCCSpellCamp & "/" & $g_iCurTotalCCSpellCamp)
				ExitLoop
			Else
				$g_iCurCCSpellCamp = 0
				$g_iCurTotalCCSpellCamp = 0
			EndIf
		Else
			$g_iCurCCSpellCamp = 0
			$g_iCurTotalCCSpellCamp = 0
		EndIf
		$iCount += 1
		If $iCount > 30 Then ExitLoop
		If _Sleep(250) Then Return
	WEnd
	If $g_iCurCCSpellCamp = 0 And $g_iCurTotalCCSpellCamp = 0 Then
		If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then Setlog("CC Spell size read error or maybe not available.", $COLOR_ERROR) ; log if there is read error
	EndIf
	If $g_iCurCCSpellCamp >= $g_iCurTotalCCSpellCamp Then
		$g_bFullCCSpells = True
	EndIf
	If $g_iChkWait4CCSpell = 1 Then
		If $g_bFullCCSpells = False Then
			SETLOG(" All mode - Waiting clan castle spells before start attack.", $COLOR_ACTION)
		EndIf
	Else
		If $g_bFullCCSpells = False Then
			Local $i
			Local $bIsWaitForCCSpellsEnable = False
			For $i = $DB To $LB
				If $g_abAttackTypeEnable[$i] Then
;~ 					If $g_abSearchCastleSpellsWaitEnable[$i] Then
;~ 						SETLOG(" " & $g_asModeText[$i] & " Setting - Waiting for Clan Castle Spells.", $COLOR_ACTION)
;~ 						$bIsWaitForCCSpellsEnable = True
;~ 					EndIf
				EndIf
			Next
			If $bIsWaitForCCSpellsEnable = False Then
				SETLOG("Not waiting for clan castle spell.", $COLOR_ACTION)
				$g_bFullCCSpells = True
			EndIf
		EndIf
	EndIf
	If $ichkRequestCC4Spell = 1 Then
		$g_bNeedRequestCCSpell = $g_iCurCCSpellCamp < $itxtRequestCC4Spell
	EndIf
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("End getMyArmyCCSpellCapacity:", $COLOR_DEBUG1)
EndFunc   ;==>getMyArmyCCSpellCapacity


Func getMyArmyCCSeigeMachineCapacity()
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("Begin getMyArmyCCSeigeMachineCapacity:", $COLOR_DEBUG1)
	; reset global variable
	$g_bFullCCSeigeMachine = False

	Local $aGetCCSeigeMachineSize[3] = ["", "", ""]
	Local $sCCSeigeMachineInfo = ""
	Local $iCount

	$iCount = 0 ; reset loop safety exit counter
	While 1
		$sCCSeigeMachineInfo = getMyOcrCCSeigeMachineCap()
		If $g_iSamM0dDebug = 1 Then Setlog("$sCCSeigeMachineInfo = " & $sCCSeigeMachineInfo, $COLOR_DEBUG)
		If $sCCSeigeMachineInfo = "" And $iCount > 1 Then ExitLoop
		$aGetCCSeigeMachineSize = StringSplit($sCCSeigeMachineInfo, "#")
		If IsArray($aGetCCSeigeMachineSize) Then
			If $aGetCCSeigeMachineSize[0] > 1 Then
				If Number($aGetCCSeigeMachineSize[2]) > 2 And $aGetCCSeigeMachineSize[2] = 0 Then
					If $g_iSamM0dDebug = 1 Then Setlog(" OCR value is not valid cc seige machine camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$g_iCurTotalCCSeigeMachineCamp = Number($aGetCCSeigeMachineSize[2])
				$g_iCurCCSeigeMachineCamp = Number($aGetCCSeigeMachineSize[1])
				SetLog("Clan Castle seige machine: " & $g_iCurCCSeigeMachineCamp & "/" & $g_iCurTotalCCSeigeMachineCamp)
				ExitLoop
			Else
				$g_iCurCCSeigeMachineCamp = 0
				$g_iCurTotalCCSeigeMachineCamp = 0
			EndIf
		Else
			$g_iCurCCSeigeMachineCamp = 0
			$g_iCurTotalCCSeigeMachineCamp = 0
		EndIf
		$iCount += 1
		If $iCount > 30 Then ExitLoop
		If _Sleep(250) Then Return
	WEnd
	If $g_iCurCCSeigeMachineCamp = 0 And $g_iCurTotalCCSeigeMachineCamp = 0 Then
		If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then Setlog("CC Seige Machine size read error or maybe not available.", $COLOR_ERROR) ; log if there is read error
	EndIf
	If $g_iCurCCSeigeMachineCamp >= $g_iCurTotalCCSeigeMachineCamp Then
		$g_bFullCCSeigeMachine = True
	EndIf
	If $ichkRequestCC4SeigeMachine = 1 Then
		$g_bNeedRequestCCSeigeMachine = $g_iCurCCSeigeMachineCamp < $itxtRequestCC4SeigeMachine
	EndIf
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("End getMyArmyCCSeigeMachineCapacity:", $COLOR_DEBUG1)
EndFunc   ;==>getMyArmyCCSeigeMachineCapacity

Func getTrainArmyCapacity($bSpellFlag = False)
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("Begin getTrainArmyCapacity:", $COLOR_DEBUG1)

	Local $aGetFactorySize[2] = [0,0]
	Local $aTempSize
	Local $iCount
	Local $sArmyInfo = ""
	Local $CurBrewSFactory = 0
	Local $tempCurS = 0
	Local $tempCurT = 0
	Local $tmpTotalCamp = 0

	$iCount = 0
	While 1
		$sArmyInfo = getMyOcrTrainArmyOrBrewSpellCap()
		$aTempSize = StringSplit($sArmyInfo, "#", $STR_NOCOUNT)
		If IsArray($aTempSize) Then
			If UBound($aTempSize) = 2 Then
				If Number($aTempSize[1]) < 20 Or Mod(Number($aTempSize[1]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_iSamM0dDebug = 1 Then Setlog(" OCR value is not valid camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$tmpTotalCamp = Number($aTempSize[1])
				$tempCurS = Number($aTempSize[0])
				If $tempCurT = 0 Then $tempCurT = $tmpTotalCamp
				If $g_iSamM0dDebug = 1 Then Setlog("$tempCurS = " & $tempCurS & ", $tempCurT = " & $tempCurT, $COLOR_DEBUG)
				ExitLoop
			Else
				$tempCurS = 0
				$tmpTotalCamp = 0
			EndIf
		Else
			$tempCurS = 0
			$tmpTotalCamp = 0
		EndIf
		$iCount += 1
		If $iCount > 30 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
		If _Sleep(250) Then Return ; Wait 250ms
	WEnd
	$aGetFactorySize[0] = $tempCurS
	$aGetFactorySize[1] = $tempCurT
	If $bSpellFlag = False Then
		If $g_iTotalCampSpace <> ($tempCurT / 2) Then ; if Total camp size is still not set or value not same as read use forced value
			If $g_bTotalCampForced = False Then ; check if forced camp size set in expert tab
				Local $proposedTotalCamp = ($tempCurT / 2)
				If $g_iTotalCampSpace > ($tempCurT / 2) Then $proposedTotalCamp = $g_iTotalCampSpace
				Local $sInputbox = InputBox("Question", _
									  "Enter your total Army Camp capacity." & @CRLF & @CRLF & _
									  "Please check it matches with total Army Camp capacity" & @CRLF & _
									  "you see in Army Overview right now in Android Window:" & @CRLF & _
									  $g_sAndroidTitle & @CRLF & @CRLF & _
									  "(This window closes in 2 Minutes with value of " & $proposedTotalCamp & ")", $proposedTotalCamp, "", 330, 220, Default, Default, 120, $g_hFrmBotEx)
				Local $error = @error
				If $error = 1 Then
				   Setlog("Army Camp User input cancelled, still using " & $g_iTotalCampSpace, $COLOR_ACTION)
				Else
				   If $error = 2 Then
					  ; Cancelled, using proposed value
					  $g_iTotalCampSpace = $proposedTotalCamp
				   Else
					  $g_iTotalCampSpace = Number($sInputbox)
				   EndIf
				   If $error = 0 Then
					  $g_iTotalCampForcedValue = $g_iTotalCampSpace
					  $g_bTotalCampForced = True
					  Setlog("Army Camp User input = " & $g_iTotalCampSpace, $COLOR_INFO)
				   Else
					  ; timeout
					  Setlog("Army Camp proposed value = " & $g_iTotalCampSpace, $COLOR_ACTION)
				   EndIf
				EndIF
			Else
				$g_iTotalCampSpace = $g_iTotalCampForcedValue
			EndIf
		EndIf
	Else
		If ($tempCurT / 2) <> $g_iTotalSpellValue Then
			Setlog("Note: Spell Factory Size read not same User Input Value.", $COLOR_WARNING) ; log if there difference between user input and OCR
		EndIf
	EndIf
	Return $aGetFactorySize
EndFunc   ;==>getTrainArmyCapacity

Func getMyArmyCapacityMini($bShowLog = True) ; Done
	Local $aGetArmySize[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $tmpTotalCamp

	; reset Global Variable
	$g_CurrentCampUtilization = 0
	$g_iTotalCampSpace = 0

	$sArmyInfo = getMyOcrArmyCap()
	UpdSam($sArmyInfo) ; Mod
	If $g_iSamM0dDebug = 1 Then Setlog("getMyArmyCapacityMini $sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
	$aGetArmySize = StringSplit($sArmyInfo, "#")
	If IsArray($aGetArmySize) Then
		If $aGetArmySize[0] > 1 Then
			If Number($aGetArmySize[2]) < 20 Or Mod(Number($aGetArmySize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
				If $g_iSamM0dDebug = 1 Then Setlog(" OCR value is not valid camp size", $COLOR_DEBUG)
			Else
				$g_CurrentCampUtilization = Number($aGetArmySize[1])
				$g_iTotalCampSpace = Number($aGetArmySize[2])
			EndIf
		EndIf
	EndIf

	If $g_bTotalCampForced And $g_iTotalCampSpace = 0 Then $g_iTotalCampSpace = $g_iTotalCampForcedValue

	If $g_iTotalCampSpace <> 0 Then
		$g_iArmyCapacity = Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
		If $bShowLog Then SetLog("Troops: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & " (" & $g_iArmyCapacity & "%)")
	EndIf

	If $g_CurrentCampUtilization >= Int(($g_iMyTroopsSize * $g_iTrainArmyFullTroopPct) / 100) Then
		$g_bfullArmy = True
	Else
		$g_bfullArmy = False
	EndIf
EndFunc

Func getTrainArmyCapacityMini($bShowLog = True)
	Local $aTempSize
	Local $sArmyInfo = ""

	; reset Global Variable
	$g_aiTroopsMaxCamp[0] = 0
	$g_aiTroopsMaxCamp[1] = 0

	$sArmyInfo = getArmyCapacityOnTrainTroops(48, 160)
	If $g_iSamM0dDebug = 1 Then Setlog("getTrainArmyCapacityMini $sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
	$aTempSize = StringSplit($sArmyInfo, "#", $STR_NOCOUNT)
	If IsArray($aTempSize) Then
		If UBound($aTempSize) = 2 Then
			If Number($aTempSize[1]) < 20 Or Mod(Number($aTempSize[1]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
				If $g_iSamM0dDebug = 1 Then Setlog(" OCR value is not valid camp size", $COLOR_DEBUG)
			Else
				$g_aiTroopsMaxCamp[0] = Number($aTempSize[0])
				$g_aiTroopsMaxCamp[1] = Number($aTempSize[1])
			EndIf
		EndIf
	EndIf
	If $g_iTotalCampSpace <> ($g_aiTroopsMaxCamp[1] / 2) Then
		If $g_bTotalCampForced Then
			$g_iTotalCampSpace = $g_iTotalCampForcedValue
		Else
			Local $proposedTotalCamp = ($g_aiTroopsMaxCamp[1] / 2)
			If $g_iTotalCampSpace > ($g_aiTroopsMaxCamp[1] / 2) Then $proposedTotalCamp = $g_iTotalCampSpace
			Local $sInputbox = InputBox("Question", _
								  "Enter your total Army Camp capacity." & @CRLF & @CRLF & _
								  "Please check it matches with total Army Camp capacity" & @CRLF & _
								  "you see in Army Overview right now in Android Window:" & @CRLF & _
								  $g_sAndroidTitle & @CRLF & @CRLF & _
								  "(This window closes in 2 Minutes with value of " & $proposedTotalCamp & ")", $proposedTotalCamp, "", 330, 220, Default, Default, 120, $g_hFrmBotEx)
			Local $error = @error
			If $error = 1 Then
			   Setlog("Army Camp User input cancelled, still using " & $g_iTotalCampSpace, $COLOR_ACTION)
			Else
			   If $error = 2 Then
				  ; Cancelled, using proposed value
				  $g_iTotalCampSpace = $proposedTotalCamp
			   Else
				  $g_iTotalCampSpace = Number($sInputbox)
			   EndIf
			   If $error = 0 Then
				  $g_iTotalCampForcedValue = $g_iTotalCampSpace
				  $g_bTotalCampForced = True
				  Setlog("Army Camp User input = " & $g_iTotalCampSpace, $COLOR_INFO)
			   Else
				  ; timeout
				  Setlog("Army Camp proposed value = " & $g_iTotalCampSpace, $COLOR_ACTION)
			   EndIf
			EndIF
		EndIf
	EndIf
	If $g_aiTroopsMaxCamp[1] <> 0 Then
		If $bShowLog Then SetLog("Max Troops: " & $g_aiTroopsMaxCamp[0] & "/" & $g_aiTroopsMaxCamp[1])
	EndIf
EndFunc

Func getMySpellCapacityMini($bShowLog = True)
	Local $aGetSpellSize[3] = ["", "", ""]
	Local $sSpellInfo = ""
	Local $tmpTotalCamp

	; reset Global Variable
	$g_iCurrentSpells = 0
	$g_iTotalSpellCampSpace = 0

	$sSpellInfo = getMyOcrSpellCap()
	UpdSam($sSpellInfo) ; Mod
	If $g_iSamM0dDebug = 1 Then Setlog("getMySpellCapacityMini $sSpellInfo = " & $sSpellInfo, $COLOR_DEBUG)
	$aGetSpellSize = StringSplit($sSpellInfo, "#")
	If IsArray($aGetSpellSize) Then
		If $aGetSpellSize[0] > 1 Then
			$g_iCurrentSpells = Number($aGetSpellSize[1])
			$g_iTotalSpellCampSpace = Number($aGetSpellSize[2])
		EndIf
	EndIf
	If $g_iTotalSpellCampSpace <> 0 Then
		If $bShowLog Then SetLog("Spells: " & $g_iCurrentSpells & "/" & $g_iTotalSpellCampSpace)
	EndIf
	$g_bFullArmySpells = $g_iCurrentSpells >= $g_iMySpellsSize

	If $g_bFullArmySpells = False Then
		Local $bIsWaitForSpellEnable = False

		For $i = $DB To $LB
			If $g_abAttackTypeEnable[$i] Then
				If $g_abSearchSpellsWaitEnable[$i] Then
					SETLOG(" " & $g_asModeText[$i] & " Setting - Waiting for spells ready.", $COLOR_ACTION)
					$bIsWaitForSpellEnable = True
				EndIf
			EndIf
		Next

		If $bIsWaitForSpellEnable = False Then
			SETLOG("Not waiting for spell.", $COLOR_ACTION)
			$g_bFullArmySpells = True
		EndIf
	EndIf
EndFunc

Func getBrewSpellCapacityMini($bShowLog = True)
	Local $aTempSize
	Local $sSpellInfo = ""

	; reset Global Variable
	$g_aiSpellsMaxCamp[0] = 0
	$g_aiSpellsMaxCamp[1] = 0

	$sSpellInfo = getArmyCapacityOnTrainTroops(48, 160)
	If $g_iSamM0dDebug = 1 Then Setlog("getBrewSpellCapacityMini $sSpellInfo = " & $sSpellInfo, $COLOR_DEBUG)
	$aTempSize = StringSplit($sSpellInfo, "#", $STR_NOCOUNT)
	If IsArray($aTempSize) Then
		If UBound($aTempSize) = 2 Then
			$g_aiSpellsMaxCamp[0] = Number($aTempSize[0])
			$g_aiSpellsMaxCamp[1] = Number($aTempSize[1])
		EndIf
	EndIf
	If $g_aiSpellsMaxCamp[1] <> 0 Then
		If $bShowLog Then SetLog("Max Spells: " & $g_aiSpellsMaxCamp[0] & "/" & $g_aiSpellsMaxCamp[1])
	EndIf
EndFunc