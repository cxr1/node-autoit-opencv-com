#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <GUIConstantsEx.au3>

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("show image in autoit gui", 400, 400, 200, 200)
Global $Pic = GUICtrlCreatePic("", 0, 0, 400, 400)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $cv = _OpenCV_get()

If IsObj($cv) Then
	Global $img = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\data\lena.jpg"))
	_OpenCV_imshow_ControlPic($img, $FormGUI, $Pic)

	Global $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	$cv.destroyAllWindows()
EndIf

_OpenCV_Unregister_And_Close()
