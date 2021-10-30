#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/d8/dbc/tutorial_histogram_calculation.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/cpp/tutorial_code/Histograms_Matching/calcHist_Demo.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()
Local $addon_dll = _Addon_FindDLL()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Histogram Calculation", 1065, 617, 192, 124)

Local $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\lena.jpg", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Local $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Local $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelResult = GUICtrlCreateLabel("calcHist Demo", 735, 60, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Local $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GDIPlus_Startup()

Local $sImage, $nMsg

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sImage = ControlGetText($FormGUI, "", $InputSource)
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf
	EndSwitch
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	If $sImage == "" Then Return

	;;! [Load image]
	Local $src = _OpenCV_imread_and_check($sImage, $CV_IMREAD_COLOR)
	If @error Then
		$sImage = Null
		Return
	EndIf
	;;! [Load image]

	;;! [Separate the image in 3 places ( B, G and R )]
	Local $bgr_planes = $cv.split($src)
	;;! [Separate the image in 3 places ( B, G and R )]

	;;! [Establish the number of bins]
	Local $histSize[1] = [256] ;
	;;! [Establish the number of bins]

	;;! [Set the ranges ( for B,G,R) )]
	Local $histRange[2] = [0, 256]  ; ;;the upper boundary is exclusive
	;;! [Set the ranges ( for B,G,R) )]

	;;! [Set histogram param]
	Local $accumulate = False
	;;! [Set histogram param]

	Local $channels[0]

	;;! [Compute the histograms]
	Local $b_hist, $g_hist, $r_hist
	Local $images[1]

	$images[0] = $bgr_planes[0]
	$b_hist = $cv.calcHist($images, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $histRange, $accumulate)

	$images[0] = $bgr_planes[1]
	$g_hist = $cv.calcHist($images, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $histRange, $accumulate)

	$images[0] = $bgr_planes[2]
	$r_hist = $cv.calcHist($images, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $histRange, $accumulate)
	;;! [Compute the histograms]

	;;! [Draw the histograms for B, G and R]
	Local $hist_w = 512, $hist_h = 400 ;
	Local $bin_w = Round($hist_w / $histSize[0]) ;

	Local $histImage = ObjCreate("OpenCV.cv.Mat").create($hist_h, $hist_w, $CV_8UC3, _OpenCV_Scalar(0, 0, 0))
	;;! [Draw the histograms for B, G and R]

	;;! [Normalize the result to ( 0, histImage.rows )]
	$cv.normalize($b_hist, $b_hist, 0, $histImage.rows, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))
	$cv.normalize($g_hist, $g_hist, 0, $histImage.rows, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))
	$cv.normalize($r_hist, $r_hist, 0, $histImage.rows, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))
	;;! [Normalize the result to ( 0, histImage.rows )]

	;;! [Draw for each channel]
	Local $hTimer
	If $addon_dll == "" Then
		;;! Slower
		$hTimer = TimerInit()
		For $i = 1 To $histSize[0] - 1
			$cv.line($histImage, _OpenCV_Point($bin_w * ($i - 1), $hist_h - Round($b_hist.float_at($i - 1))), _
					_OpenCV_Point($bin_w * ($i), $hist_h - Round($b_hist.float_at($i))), _
					_OpenCV_Scalar(255, 0, 0), 2, 8, 0)
			$cv.line($histImage, _OpenCV_Point($bin_w * ($i - 1), $hist_h - Round($g_hist.float_at($i - 1))), _
					_OpenCV_Point($bin_w * ($i), $hist_h - Round($g_hist.float_at($i))), _
					_OpenCV_Scalar(0, 255, 0), 2, 8, 0)
			$cv.line($histImage, _OpenCV_Point($bin_w * ($i - 1), $hist_h - Round($r_hist.float_at($i - 1))), _
					_OpenCV_Point($bin_w * ($i), $hist_h - Round($r_hist.float_at($i))), _
					_OpenCV_Scalar(0, 0, 255), 2, 8, 0)
		Next
		ConsoleWrite("AutoIt loop " & TimerDiff($hTimer) & "ms" & @CRLF)
	Else
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
		$hTimer = TimerInit()
		_OpenCV_DllCall($addon_dll, "none:cdecl", "calcHist_Demo_draw", _
				"ptr", $histImage.self, _
				"int", $histSize[0], _
				"int", $hist_w, _
				"int", $hist_h, _
				"ptr", $b_hist.self, _
				"ptr", $g_hist.self, _
				"ptr", $r_hist.self _
				)
		ConsoleWrite("Dll loop " & TimerDiff($hTimer) & "ms" & @CRLF)
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf
	;;! [Draw for each channel]

	;;! [Display]
	_OpenCV_imshow_ControlPic($src, $FormGUI, $PicSource)
	_OpenCV_imshow_ControlPic($histImage, $FormGUI, $PicResult)
	;;! [Display]
EndFunc   ;==>Main
