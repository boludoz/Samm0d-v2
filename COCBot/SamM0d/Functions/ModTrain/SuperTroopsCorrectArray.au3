; #FUNCTION# ====================================================================================================================
; Name ..........: SuperTroopsCorrectArray
; Description ...: Reads current quanitites/type of troops from Training window, updates $CurXXXXX (Current available unit)
;                  and also update $g_avDTtroopsToBeUsed for drop trophy
;                  remove excess unit will be done by here if enable by user at GUI
; Syntax ........: SuperTroopsCorrectArray(ByRef $aTempTroops, ByRef $g_aMySuperTroops)
; Parameters ....:
;
; Return values .: None
; Author ........: Boldina! (5/5/2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; SuperTroopsCorrectArray($g_aMyTroops, "Giant")
Func SuperTroopsCorrectArray(ByRef $aTempTroops, $sSuperTroop = $g_sSuperTActive)
	
	$aTempTroops = $g_aMyTroops

	SuperTroopsArray($g_sSuperTActive)
	
	For $i = 0 To UBound($g_aMyTroops) - 1
		For $i2 = 0 To UBound($g_aMySuperTroops) - 1
			If (StringInStr($sSuperTroop, $g_aMyTroops[$i][0]) <> 0) Then
				If (StringInStr($g_aMySuperTroops[$i2][0], $sSuperTroop) <> 0) Then
					$g_aMySuperTroops[$i2][1] = $g_aMyTroops[$i][1] ; Unit order
					$g_aMySuperTroops[$i2][3] = Floor(Int($g_aMyTroops[$i][3] / (Int($g_aMySuperTroops[$i2][2] / $g_aMyTroops[$i][2]))))
					$g_aMySuperTroops[$i2][3] += ($sSuperTroop = "Giant") ? (2) : (0)
					ExitLoop 2
				EndIf
			EndIf
		Next
	Next

	; Add-hoc super troops.
	_ArrayAdd($aTempTroops, $g_aMySuperTroops)
	
	; Resize archs and SuperTroops remplace without edit $g_aMyTroops
	For $i = 0 To UBound($aTempTroops) -1
		If (StringInStr($aTempTroops[$i][0], "Arch") <> 0) Then
			$aTempTroops[$i][3] = 0 ; Unit quantity
		EndIf
		
		If (StringInStr($aTempTroops[$i][0], $sSuperTroop) = 1) Then
			$aTempTroops[$i][3] = 0 ; Unit quantity
		EndIf
	Next

	Local $iAntiFill = 0

	; Resize archs
	For $i = 0 To UBound($aTempTroops) -1
		$iAntiFill += Int($aTempTroops[$i][2] * $aTempTroops[$i][3]) ; Unit size * Unit quantity
	Next

	For $i = 0 To UBound($aTempTroops) -1
		If (StringInStr($aTempTroops[$i][0], "Arch") = 1) Then
			$aTempTroops[$i][3] = Abs($iAntiFill - $g_iTotalCampForcedValue) ; Unit quantity - Camp space = Archs.
			ExitLoop
		EndIf
	Next

EndFunc   ;==>SuperTroopsCorrectArray

Func SuperTroopsArray($sSuperTroop)
	$g_sSuperTActive = $sSuperTroop
	
	; SuperTroops
	Global $g_aMySuperTroops[4][5] = _
	[["SuperBarb", 23, 5, 0, 0], _
	["SuperGiant", 24, 10, 0, 0], _
	["SuperGobl", 25, 3, 0, 0], _
	["SuperWall", 26, 8, 0, 0]]
	
	If $sSuperTroop = "" Then Return
		
EndFunc   ;==>SuperTroopsArray

Func SearchMulti($aArray, $sToSearch)
	For $i = 0 To UBound($aArray) -1
		If StringInStr($aArray[$i][0], $sToSearch) = 1 Then
			Return $i
		EndIf
	Next
	SetLog("Fail SearchMultiTroops " & $sToSearch)
	Return 0
EndFunc