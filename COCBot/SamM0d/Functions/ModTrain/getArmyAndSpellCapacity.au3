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

Func getTrainArmyCapacity($bSpellFlag = False)
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SETLOG("Begin getTrainArmyCapacity:", $COLOR_DEBUG1)

	Local $aGetFactorySize[2] = [0, 0]
	Local $sArmyInfo = "", $aTempSize

	For $i = 0 To 3
		$sArmyInfo = getArmyCapacityOnTrainTroops(48, 160)
		$aTempSize = StringSplit($sArmyInfo, "#", $STR_NOCOUNT)
		
		If IsArray($aTempSize) Then
			$aGetFactorySize = $aTempSize
			Return $aGetFactorySize
		EndIf
		If _Sleep(750) Then Return
	Next
	
	Return $aGetFactorySize
EndFunc   ;==>getTrainArmyCapacity

Func getMyArmyCapacityMini($hHBitmap, $bShowLog = True)
	Local $aGetArmySize[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $tmpTotalCamp

	; reset Global Variable
	$g_CurrentCampUtilization = 0
	$g_iTotalCampSpace = 0

	$sArmyInfo = getMyOcrArmyCap($hHBitmap)
	UpdSam($sArmyInfo)
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
;~ 	If $hHBitmap <> 0 Then
;~ 		SetLog("Delete $hHBitmap")
;~ 		GdiDeleteHBitmap($hHBitmap)
;~ 	EndIf
EndFunc   ;==>getMyArmyCapacityMini

Func getTrainArmyCapacityMini($hHBitmap, $bShowLog = True)
	Local $aTempSize
	Local $sArmyInfo = ""

	; reset Global Variable
	$g_aiTroopsMaxCamp[0] = 0
	$g_aiTroopsMaxCamp[1] = 0

	$sArmyInfo = getMyOcrTrainArmyOrBrewSpellCap($hHBitmap)
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
			EndIf
		EndIf
	EndIf
	If $g_aiTroopsMaxCamp[1] <> 0 Then
		If $bShowLog Then SetLog("Max Troops: " & $g_aiTroopsMaxCamp[0] & "/" & $g_aiTroopsMaxCamp[1])
	EndIf
EndFunc   ;==>getTrainArmyCapacityMini

Func getMySpellCapacityMini($hHBitmap, $bShowLog = True)
	Local $aGetSpellSize[3] = ["", "", ""]
	Local $sSpellInfo = ""
	Local $tmpTotalCamp

	; reset Global Variable
	$g_iCurrentSpells = 0
	$g_iTotalSpellCampSpace = 0

	$sSpellInfo = getMyOcrSpellCap($hHBitmap)
	UpdSam($sSpellInfo)
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
EndFunc   ;==>getMySpellCapacityMini

Func getBrewSpellCapacityMini($hHBitmap, $bShowLog = True)
	Local $aTempSize
	Local $sSpellInfo = ""

	; reset Global Variable
	$g_aiSpellsMaxCamp[0] = 0
	$g_aiSpellsMaxCamp[1] = 0

	$sSpellInfo = getMyOcrTrainArmyOrBrewSpellCap($hHBitmap)
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
EndFunc   ;==>getBrewSpellCapacityMini
