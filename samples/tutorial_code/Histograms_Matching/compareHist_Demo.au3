#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\Table.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/d8/dc8/tutorial_histogram_comparison.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/cpp/tutorial_code/Histograms_Matching/compareHist_Demo.cpp
;~     https://www.autoitscript.com/forum/topic/105814-table-udf/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Histogram Comparison", 997, 668, 192, 124)

Local $InputSrcBase = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\Histogram_Comparison_Source_0.jpg", 230, 16, 449, 21)
Local $BtnSrcBase = GUICtrlCreateButton("Input 1", 689, 14, 75, 25)

Local $InputSrcTest1 = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\Histogram_Comparison_Source_1.jpg", 230, 52, 449, 21)
Local $BtnSrcTest1 = GUICtrlCreateButton("Input 2", 689, 50, 75, 25)

Local $InputSrcTest2 = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\Histogram_Comparison_Source_2.jpg", 230, 88, 449, 21)
Local $BtnSrcTest2 = GUICtrlCreateButton("Input 3", 689, 86, 75, 25)

Local $BtnExec = GUICtrlCreateButton("Execute", 832, 48, 75, 25)

Local $LabelSrcBase = GUICtrlCreateLabel("Source 1", 144, 128, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSrcBase = GUICtrlCreateGroup("", 20, 150, 310, 316)
Local $PicSrcBase = GUICtrlCreatePic("", 25, 161, 300, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelSrcTest1 = GUICtrlCreateLabel("Source 2", 468, 128, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSrcTest1 = GUICtrlCreateGroup("", 344, 150, 310, 316)
Local $PicSrcTest1 = GUICtrlCreatePic("", 349, 161, 300, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelSrcTest2 = GUICtrlCreateLabel("Source 3", 792, 128, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSrcTest2 = GUICtrlCreateGroup("", 668, 150, 310, 316)
Local $PicSrcTest2 = GUICtrlCreatePic("", 673, 161, 300, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)

GUISetState(@SW_LOCK)
Local $Table = _GUICtrlTable_Create(20, 500, 191, 28, 5, 5, 0)
_GUICtrlTable_Set_RowHeight($Table, 1, 35)
_GUICtrlTable_Set_Justify_All($Table, 1, 1)
_GUICtrlTable_Set_TextFont_All($Table, 8.5, 800, 0, "Tahoma")
_GUICtrlTable_Set_CellColor_Row($Table, 1, 0x374F7F)
_GUICtrlTable_Set_TextColor_All($Table, 0x555555)
_GUICtrlTable_Set_TextColor_Row($Table, 1, 0xFFFFFF)
For $row = 3 To 5 Step 2
	_GUICtrlTable_Set_CellColor_Row($Table, $row, 0xDDDDDD)
Next
_GUICtrlTable_Set_Text_Row($Table, 1, "*Method*|Base - Base|Base - Half|Base - Test 1|Base - Test 2")
_GUICtrlTable_Set_Border_Table($Table, 0x555555)
GUISetState(@SW_UNLOCK)

#EndRegion ### END Koda GUI section ###

_GDIPlus_Startup()

Local $sSrcBase = "", $sSrcTest1 = "", $sSrcTest2 = ""
Local $nMsg

Local $aMethodName[4] = ["Correlation", "Chi-square", "Intersection", "Bhattacharyya"]

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSrcBase
			$sSrcBase = ControlGetText($FormGUI, "", $InputSrcBase)
			$sSrcBase = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sSrcBase)
			If @error Then
				$sSrcBase = ""
			Else
				ControlSetText($FormGUI, "", $InputSrcBase, $sSrcBase)
			EndIf
		Case $BtnSrcTest1
			$sSrcTest1 = ControlGetText($FormGUI, "", $InputSrcTest1)
			$sSrcTest1 = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sSrcTest1)
			If @error Then
				$sSrcTest1 = ""
			Else
				ControlSetText($FormGUI, "", $InputSrcTest1, $sSrcTest1)
			EndIf
		Case $BtnSrcTest2
			$sSrcTest2 = ControlGetText($FormGUI, "", $InputSrcTest2)
			$sSrcTest2 = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sSrcTest2)
			If @error Then
				$sSrcTest2 = ""
			Else
				ControlSetText($FormGUI, "", $InputSrcTest2, $sSrcTest2)
			EndIf
		Case $BtnExec
			Main()
	EndSwitch
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	;;! [Load three images with different environment settings]
	$sSrcBase = ControlGetText($FormGUI, "", $InputSrcBase)
	Local $src_base = _OpenCV_imread_and_check($sSrcBase, $CV_IMREAD_COLOR)
	If @error Then Return

	$sSrcTest1 = ControlGetText($FormGUI, "", $InputSrcTest1)
	Local $src_test1 = _OpenCV_imread_and_check($sSrcTest1, $CV_IMREAD_COLOR)
	If @error Then Return

	$sSrcTest2 = ControlGetText($FormGUI, "", $InputSrcTest2)
	Local $src_test2 = _OpenCV_imread_and_check($sSrcTest2, $CV_IMREAD_COLOR)
	If @error Then Return
	;;! [Load three images with different environment settings]

	;;! [Display]
	_OpenCV_imshow_ControlPic($src_base, $FormGUI, $PicSrcBase)
	_OpenCV_imshow_ControlPic($src_test1, $FormGUI, $PicSrcTest1)
	_OpenCV_imshow_ControlPic($src_test2, $FormGUI, $PicSrcTest2)
	;;! [Display]

	;;! [Convert to HSV]
	Local $hsv_base = $cv.cvtColor($src_base, $CV_COLOR_BGR2HSV)
	Local $hsv_test1 = $cv.cvtColor($src_test1, $CV_COLOR_BGR2HSV)
	Local $hsv_test2 = $cv.cvtColor($src_test2, $CV_COLOR_BGR2HSV)
	;;! [Convert to HSV]

	;;! [Convert to HSV half]
	Local $hsv_half_down = ObjCreate("OpenCV.cv.Mat").create($hsv_base, _OpenCV_Rect(0, $hsv_base.cols / 2, $hsv_base.rows, $hsv_base.cols / 2))
	;;! [Convert to HSV half]

	;;! [Using 50 bins for hue and 60 for saturation]
	Local $h_bins = 50, $s_bins = 60
	Local $histSize[2] = [$h_bins, $s_bins]

	;; hue varies from 0 to 179, saturation from 0 to 255
	Local $h_ranges[2] = [0, 180]
	Local $s_ranges[2] = [0, 256]

	Local $ranges[4] = [$h_ranges[0], $h_ranges[1], $s_ranges[0], $s_ranges[1]]

	;; Use the 0-th and 1-st channels
	Local $channels[2] = [0, 1]
	;;! [Using 50 bins for hue and 60 for saturation]

	;;! [Calculate the histograms for the HSV images]
	Local $a_hsv_base[1] = [$hsv_base]
	Local $hist_base = $cv.calcHist($a_hsv_base, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $ranges, False)
	$cv.normalize($hist_base, $hist_base, 0, 1, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))

	Local $a_hsv_half_down[1] = [$hsv_half_down]
	Local $hist_half_down = $cv.calcHist($a_hsv_half_down, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $ranges, False)
	$cv.normalize($hist_half_down, $hist_half_down, 0, 1, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))

	Local $a_hsv_test1[1] = [$hsv_test1]
	Local $hist_test1 = $cv.calcHist($a_hsv_test1, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $ranges, False)
	$cv.normalize($hist_test1, $hist_test1, 0, 1, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))

	Local $a_hsv_test2[1] = [$hsv_test2]
	Local $hist_test2 = $cv.calcHist($a_hsv_test2, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $ranges, False)
	$cv.normalize($hist_test2, $hist_test2, 0, 1, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))
	;;! [Calculate the histograms for the HSV images]

	;;! [Apply the histogram comparison methods]
	GUISetState(@SW_LOCK)
	For $compare_method = 0 To 3 Step 1
		Local $base_base = $cv.compareHist($hist_base, $hist_base, $compare_method)
		Local $base_half = $cv.compareHist($hist_base, $hist_half_down, $compare_method)
		Local $base_test1 = $cv.compareHist($hist_base, $hist_test1, $compare_method)
		Local $base_test2 = $cv.compareHist($hist_base, $hist_test2, $compare_method)

		ConsoleWrite("Method " & $compare_method & " Perfect, Base-Half, Base-Test(1), Base-Test(2) : " _
				 & $base_base & " / " & $base_half & " / " & $base_test1 & " / " & $base_test2 & @CRLF)

		_GUICtrlTable_Set_Text_Row($Table, $compare_method + 2, "*" & $aMethodName[$compare_method] & "*|" _
				 & $base_base & "|" & $base_half & "|" & $base_test1 & "|" & $base_test2)
	Next
	GUISetState(@SW_UNLOCK)
	;;! [Apply the histogram comparison methods]

	ConsoleWrite("Done " & @CRLF)
EndFunc   ;==>Main