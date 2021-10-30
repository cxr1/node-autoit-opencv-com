#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

If IsObj($cv) Then
	Local $img = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\data\lena.jpg"))
	Local $angle = 20
	Local $scale = 1

	Local $size[2] = [$img.width, $img.height]
	Local $center[2] = [$img.width / 2, $img.height / 2]
	Local $M = $cv.getRotationMatrix2D($center, -$angle, $scale)
	Local $rotated = $cv.warpAffine($img, $M, $size)

	$cv.imshow("Rotation", $rotated)

	$cv.waitKey()
	$cv.destroyAllWindows()
EndIf

_OpenCV_Unregister_And_Close()