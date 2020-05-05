; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOnTrainUnit
; Description ...: Reads current quanitites/type of troops from Training window, updates $OnT (On Train unit and quantity), $OnQ (On Queue unit and quantity)
;                  Check troops train correctly, will remove what un need.
; Syntax ........: CheckOnTrainUnit
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
Func CheckOnTrainUnit()
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckOnTrainUnit ============")
	
	Local $aTempTroops = $g_aMyTroops
	SuperTroopsCorrectArray($aTempTroops)
	
	SetLog("Start check on train unit...", $COLOR_INFO)
	
	; reset variable
	For $i = 0 To UBound($aTempTroops) - 1
		Assign("OnT" & $aTempTroops[$i][0], 0)
		Assign("OnQ" & $aTempTroops[$i][0], 0)
		Assign("Ready" & $aTempTroops[$i][0], 0)
		Assign("RemoveUnitOfOnT" & $aTempTroops[$i][0], 0)
		Assign("RemoveUnitOfOnQ" & $aTempTroops[$i][0], 0)
	Next

	Local $aiTroopInfo[11][4]        ; Troop info get from image search, col 0,1,2,3= Object name (troop name), unit of troop, slot (left to right), true for pre-train | false for on train troops
	Local $iAvailableCamp = 0         ; store the avaible + on train (first troop) camp size
	Local $iMyTroopsCampSize = 0     ; store the troops camp size of what troop you need to train
	
	Local $iOnQueueCamp = 0         ; store the pretrain troops (second troop) camp size

	Local $bDeletedExcess = False
	Local $bGotOnTrainFlag = False
	Local $bGotOnQueueFlag = False

	; Name, qty, IsPre, IsReady
	Local $aSumPreTra = GetTrainedAndPreDetect("Troops")
	;_ArrayDisplay($aSumPreTra)
	If IsArray($aSumPreTra) Then
		For $i = UBound($aSumPreTra) -1 To 0 Step -1

			If $aSumPreTra[$i][0] = "NotRecognized" Then
				SetLog("Error: Cannot detect what troops on slot: " & $i + 1, $COLOR_ERROR)
				$aiTroopInfo[$i][0] = "NotRecognized"
				$aiTroopInfo[$i][1] = $aSumPreTra[$i][1]
				$aiTroopInfo[$i][2] = Abs(11 - $i) 
				$aiTroopInfo[$i][3] = $aSumPreTra[$i][2]
				ContinueLoop
			EndIf

			If $aSumPreTra[$i][1] <> 0 Then

				$aiTroopInfo[$i][0] = $aSumPreTra[$i][0] ; Name
				$aiTroopInfo[$i][1] = $aSumPreTra[$i][1] ; Qty
				$aiTroopInfo[$i][2] = Abs(11 - $i) 
				$aiTroopInfo[$i][3] = $aSumPreTra[$i][2] ;IsQueueTroop
				If $aSumPreTra[$i][2] Then
					Assign("OnQ" & $aSumPreTra[$i][0], Eval("OnQ" & $aSumPreTra[$i][0]) + $aSumPreTra[$i][1])

					If $aSumPreTra[$i][3] = True Then
						Assign("Ready" & $aSumPreTra[$i][0], Eval("Ready" & $aSumPreTra[$i][0]) + $aSumPreTra[$i][1])
					EndIf
                    
				Else
					Assign("OnT" & $aSumPreTra[$i][0], Eval("OnT" & $aSumPreTra[$i][0]) + $aSumPreTra[$i][1])
				EndIf
			Else
				SetLog("Error detect quantity no. On Troop: " & GetTroopName(Eval("e" & $aSumPreTra[$i][0]), $aSumPreTra[$i][1]), $COLOR_RED)
				ExitLoop
			EndIf
		Next

	Else
		SetLog("No Army On Train.", $COLOR_ERROR)
		Return True
	EndIf
	
	; Super troops mod
	For $i = 0 To UBound($aTempTroops) - 1
		Local $itempTotal = Eval("cur" & $aTempTroops[$i][0]) + Eval("OnT" & $aTempTroops[$i][0])
		If Eval("OnT" & $aTempTroops[$i][0]) > 0 Then
			SetLog(" - No. of On Train " & GetTroopName(Eval("e" & $aTempTroops[$i][0]), Eval("OnT" & $aTempTroops[$i][0])) & ": " & Eval("OnT" & $aTempTroops[$i][0]), (Eval("e" & $aTempTroops[$i][0]) > $iDarkFixTroop ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
			$bGotOnTrainFlag = True
		EndIf
		If $aTempTroops[$i][3] < $itempTotal Then
			If $ichkEnableDeleteExcessTroops = 1 Then
				SetLog("Error: " & GetTroopName(Eval("e" & $aTempTroops[$i][0]), Eval("OnT" & $aTempTroops[$i][0])) & " need " & $aTempTroops[$i][3] & " only, and i made " & $itempTotal)
				Assign("RemoveUnitOfOnT" & $aTempTroops[$i][0], $itempTotal - $aTempTroops[$i][3])
				$bDeletedExcess = True
			EndIf
		EndIf
		If $itempTotal > 0 Then
			$iAvailableCamp += $itempTotal * $aTempTroops[$i][2]
		EndIf
		If $aTempTroops[$i][3] > 0 Then
			$iMyTroopsCampSize += $aTempTroops[$i][3] * $aTempTroops[$i][2]
		EndIf
	Next
	
	If $bDeletedExcess Then
		$bDeletedExcess = False
		SetLog(" >>> Some troops over train, stop and remove excess troops.", $COLOR_RED)
		If gotoTrainTroops() = False Then Return
		RemoveAllPreTrainTroops()

		_ArraySort($aiTroopInfo, 0, 0, 0, 2) ; sort to make remove start from left to right
		For $i = 0 To 10
			If $aiTroopInfo[$i][1] <> 0 And $aiTroopInfo[$i][3] = False Then
				; Comprueba si esta tropa va a ser eliminada.
				Local $iUnitToRemove = Eval("RemoveUnitOfOnT" & $aiTroopInfo[$i][0])
				If $iUnitToRemove > 0 Then
					If $aiTroopInfo[$i][1] > $iUnitToRemove Then
						SetLog("Remove " & GetTroopName(Eval("e" & $aiTroopInfo[$i][0]), $aiTroopInfo[$i][1]) & " at slot: " & $aiTroopInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
						RemoveTrainTroops($aiTroopInfo[$i][2] - 1, $iUnitToRemove)
						$iUnitToRemove = 0
						Assign("RemoveUnitOfOnT" & $aiTroopInfo[$i][0], $iUnitToRemove)
					Else
						SetLog("Remove " & GetTroopName(Eval("e" & $aiTroopInfo[$i][0]), $aiTroopInfo[$i][1]) & " at slot: " & $aiTroopInfo[$i][2] & ", unit to remove: " & $aiTroopInfo[$i][1], $COLOR_ACTION)
						RemoveTrainTroops($aiTroopInfo[$i][2] - 1, $aiTroopInfo[$i][1])
						$iUnitToRemove -= $aiTroopInfo[$i][1]
						Assign("RemoveUnitOfOnT" & $aiTroopInfo[$i][0], $iUnitToRemove)
					EndIf
				EndIf
			EndIf
		Next
		$g_bRestartCheckTroop = True
		Return False
	Else
		$bDeletedExcess = False
		$bGotOnQueueFlag = False

		; Super troops mod
		For $i = 0 To UBound($aTempTroops) - 1
			Local $itempTotal = Eval("OnQ" & $aTempTroops[$i][0])
			If $itempTotal > 0 Then
				SetLog(" - No. of On Queue " & GetTroopName(Eval("e" & $aTempTroops[$i][0]), Eval("OnQ" & $aTempTroops[$i][0])) & ": " & Eval("OnQ" & $aTempTroops[$i][0]), (Eval("e" & $aTempTroops[$i][0]) > $iDarkFixTroop ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				$bGotOnQueueFlag = True
				If $aTempTroops[$i][3] < $itempTotal Then
					If $ichkEnableDeleteExcessTroops = 1 Then
						SetLog("Error: " & GetTroopName(Eval("e" & $aTempTroops[$i][0]), Eval("OnQ" & $aTempTroops[$i][0])) & " need " & $aTempTroops[$i][3] & " only, and i made " & $itempTotal)
						Assign("RemoveUnitOfOnQ" & $aTempTroops[$i][0], $itempTotal - $aTempTroops[$i][3])
						$bDeletedExcess = True
					EndIf
				EndIf
				$iOnQueueCamp += $itempTotal * $aTempTroops[$i][2]
			EndIf
		Next

		If $bGotOnQueueFlag And Not $bGotOnTrainFlag Then
			If $ichkEnableDeleteExcessTroops = 1 Then
				If $iAvailableCamp < $iMyTroopsCampSize Or $ichkDisablePretrainTroops Then
					If $ichkDisablePretrainTroops Then
						SetLog("Pre-Train troops disable by user, remove all pre-train troops.", $COLOR_ERROR)
					Else
						SetLog("Error: Troops size not correct but pretrain already.", $COLOR_ERROR)
						SetLog("Error: Detected Troops size = " & $iAvailableCamp & ", My Troops size = " & $iMyTroopsCampSize, $COLOR_ERROR)
					EndIf
					If gotoTrainTroops() = False Then Return
					RemoveAllPreTrainTroops()
					$g_bRestartCheckTroop = True
					Return False
				EndIf
			EndIf
		EndIf
		If $bDeletedExcess Then
			$bDeletedExcess = False
			SetLog(" >>> Some troops over train, stop and remove excess pre-train troops.", $COLOR_RED)
			If gotoTrainTroops() = False Then Return

			_ArraySort($aiTroopInfo, 0, 0, 0, 2) ; sort to make remove start from left to right
			For $i = 0 To 10
				If $aiTroopInfo[$i][1] <> 0 And $aiTroopInfo[$i][3] = True Then
					; Comprueba si esta tropa va a ser eliminada.
					Local $iUnitToRemove = Eval("RemoveUnitOfOnQ" & $aiTroopInfo[$i][0])
					If $iUnitToRemove > 0 Then
						If $aiTroopInfo[$i][1] > $iUnitToRemove Then
							SetLog("Remove " & GetTroopName(Eval("e" & $aiTroopInfo[$i][0]), $aiTroopInfo[$i][1]) & " at slot: " & $aiTroopInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
							RemoveTrainTroops($aiTroopInfo[$i][2] - 1, $iUnitToRemove)
							$iUnitToRemove = 0
							Assign("RemoveUnitOfOnQ" & $aiTroopInfo[$i][0], $iUnitToRemove)
						Else
							SetLog("Remove " & GetTroopName(Eval("e" & $aiTroopInfo[$i][0]), $aiTroopInfo[$i][1]) & " at slot: " & $aiTroopInfo[$i][2] & ", unit to remove: " & $aiTroopInfo[$i][1], $COLOR_ACTION)
							RemoveTrainTroops($aiTroopInfo[$i][2] - 1, $aiTroopInfo[$i][1])
							$iUnitToRemove -= $aiTroopInfo[$i][1]
							Assign("RemoveUnitOfOnQ" & $aiTroopInfo[$i][0], $iUnitToRemove)
						EndIf
					EndIf
				EndIf
				If _Sleep(Random((250 * 90) / 100, (250 * 110) / 100, 1), False) Then Return False
			Next
			$g_bRestartCheckTroop = True
			Return False
		EndIf

		; if don't have on train troops then i check the pre train troop size
		If $bGotOnQueueFlag And Not $bGotOnTrainFlag Then
			If $aiTroopInfo[0][1] > 0 Then
				If $ichkEnableDeleteExcessTroops = 1 Then
					If $iOnQueueCamp <> $iMyTroopsCampSize Then
						SetLog("Error: Pre-Train Troops size not correct.", $COLOR_ERROR)
						SetLog("Error: Detected Pre-Train Troops size = " & $iOnQueueCamp & ", My Troops size = " & $iMyTroopsCampSize, $COLOR_ERROR)
						If gotoTrainTroops() = False Then Return
						RemoveAllPreTrainTroops()
						$g_bRestartCheckTroop = True
						Return False
					EndIf
				EndIf
			EndIf
			If $ichkDisablePretrainTroops Then
				SetLog("Pre-Train troops disable by user, remove all pre-train troops.", $COLOR_ERROR)
				If gotoTrainTroops() = False Then Return
				RemoveAllPreTrainTroops()
			EndIf
		Else
			If $ichkMyTroopsOrder Then
				_ArraySort($aTempTroops, 0, 0, 0, 1)
				For $i = 0 To UBound($aTempTroops) - 1
					If $aTempTroops[$i][3] > 0 Then
						$aTempTroops[0][0] = $aTempTroops[$i][0]
						$aTempTroops[0][3] = $aTempTroops[$i][3]
						ExitLoop
					EndIf
				Next
				_ArraySort($aiTroopInfo, 1, 0, 0, 2)
				For $i = 0 To UBound($aiTroopInfo) - 1
					If $aiTroopInfo[$i][3] = True Then
						If $aiTroopInfo[$i][0] <> $aTempTroops[0][0] Then
							SetLog("Pre-Train first slot: " & GetTroopName(Eval("e" & $aiTroopInfo[$i][0]), $aiTroopInfo[$i][1]), $COLOR_ERROR)
							SetLog("My first order troops: " & GetTroopName(Eval("e" & $aTempTroops[0][0]), $aTempTroops[0][3]), $COLOR_ERROR)
							SetLog("Remove and re training by order.", $COLOR_ERROR)
							RemoveAllPreTrainTroops()
							$g_bRestartCheckTroop = True
							Return False
						Else
							If $aiTroopInfo[$i][1] < $aTempTroops[0][3] Then
								SetLog("Pre-Train first slot: " & GetTroopName(Eval("e" & $aiTroopInfo[$i][0]), $aiTroopInfo[$i][1]) & " - Units: " & $aiTroopInfo[$i][1], $COLOR_ERROR)
								SetLog("My first order troops: " & GetTroopName(Eval("e" & $aTempTroops[0][0]), $aTempTroops[0][3]) & " - Units: " & $aTempTroops[0][3], $COLOR_ERROR)
								SetLog("Not enough quantity, remove and re-training again.", $COLOR_ERROR)
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
	Return True
EndFunc   ;==>CheckOnTrainUnit
