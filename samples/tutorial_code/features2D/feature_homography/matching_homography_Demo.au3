#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/d7/dff/tutorial_feature_homography.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/cpp/tutorial_code/features2D/feature_homography/SURF_FLANN_matching_homography_Demo.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Features2D + Homography to find a known object", 1000, 707, 192, 95)

Local $InputObject = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\box.png", 230, 16, 449, 21)
Local $BtnObject = GUICtrlCreateButton("Object", 689, 14, 75, 25)

Local $InputScene = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\box_in_scene.png", 230, 52, 449, 21)
Local $BtnScene = GUICtrlCreateButton("Scene", 689, 50, 75, 25)

Local $LabelAlgorithm = GUICtrlCreateLabel("Algorithm", 150, 92, 69, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $ComboAlgorithm = GUICtrlCreateCombo("", 230, 92, 169, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "ORB|Brisk|FAST|MSER|SimpleBlob|GFTT|KAZE|AKAZE|Agast")

Local $LabelMatchType = GUICtrlCreateLabel("Match type", 414, 92, 79, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $ComboMatchType = GUICtrlCreateCombo("", 502, 92, 177, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "BruteForce|BruteForce-L1|BruteForce-Hamming|BruteForce-HammingLUT|BruteForce-Hamming(2)|BruteForce-SL2")

Local $BtnExec = GUICtrlCreateButton("Execute", 832, 48, 75, 25)

Local $LabelMatches = GUICtrlCreateLabel("Good Matches && Object detection", 377, 144, 245, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupMatches = GUICtrlCreateGroup("", 20, 166, 958, 532)
Local $PicMatches = GUICtrlCreatePic("", 25, 177, 948, 516)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Local $aMatchTypes[6] = [ _
		$CV_NORM_L2, _
		$CV_NORM_L1, _
		$CV_NORM_HAMMING, _
		$CV_NORM_HAMMING, _
		$CV_NORM_HAMMING2, _
		$CV_NORM_L2SQR _
		]

Local $ORB_DETECTOR = 0
Local $BRISK_DETECTOR = 1
Local $FAST_DETECTOR = 2
Local $MSER_DETECTOR = 3
Local $SIMPLE_BLOB_DETECTOR = 4
Local $GFTT_DETECTOR = 5
Local $KAZE_DETECTOR = 6
Local $AKAZE_DETECTOR = 7
Local $AGAST_DETECTOR = 8

_GUICtrlComboBox_SetCurSel($ComboAlgorithm, 0)
_GUICtrlComboBox_SetCurSel($ComboMatchType, 2)

_GDIPlus_Startup()

Local $img_object, $img_scene
Local $nMsg
Local $sObject, $sScene

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnObject
			$sObject = ControlGetText($FormGUI, "", $InputObject)
			$sObject = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sObject)
			If @error Then
				$sObject = ""
			Else
				ControlSetText($FormGUI, "", $InputObject, $sObject)
			EndIf
		Case $BtnScene
			$sScene = ControlGetText($FormGUI, "", $InputScene)
			$sScene = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sScene)
			If @error Then
				$sScene = ""
			Else
				ControlSetText($FormGUI, "", $InputScene, $sScene)
			EndIf
		Case $ComboAlgorithm
			Detect()
		Case $ComboMatchType
			Detect()
		Case $BtnExec
			Main()
	EndSwitch
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	;;! [load_image]
	;;/ Load object and scene
	$sObject = ControlGetText($FormGUI, "", $InputObject)
	$img_object = _OpenCV_imread_and_check($sObject, $CV_IMREAD_GRAYSCALE)
	If @error Then
		$sObject = ""
		Return
	EndIf

	$sScene = ControlGetText($FormGUI, "", $InputScene)
	$img_scene = _OpenCV_imread_and_check($sScene, $CV_IMREAD_GRAYSCALE)
	If @error Then
		$sScene = ""
		Return
	EndIf
	;;! [load_image]

	Detect()
EndFunc   ;==>Main

Func Detect()
	If $sObject == "" Or $sScene == "" Then Return

	Local $algorithm = _GUICtrlComboBox_GetCurSel($ComboAlgorithm)
	Local $match_type = $aMatchTypes[_GUICtrlComboBox_GetCurSel($ComboMatchType)]

	Local $can_compute = False
	Local $detector

	;;-- Step 1: Detect the keypoints using ORB Detector, compute the descriptors
	Switch $algorithm
		Case $ORB_DETECTOR
			$can_compute = True
			$detector = ObjCreate("OpenCV.cv.ORB").create()
		Case $BRISK_DETECTOR
			$can_compute = True
			$detector = ObjCreate("OpenCV.cv.BRISK").create()
		Case $FAST_DETECTOR
			$detector = ObjCreate("OpenCV.cv.FastFeatureDetector").create()
		Case $MSER_DETECTOR
			$detector = ObjCreate("OpenCV.cv.MSER").create()
		Case $SIMPLE_BLOB_DETECTOR
			$detector = ObjCreate("OpenCV.cv.SimpleBlobDetector").create()
		Case $GFTT_DETECTOR
			$detector = ObjCreate("OpenCV.cv.GFTTDetector").create()
		Case $KAZE_DETECTOR
			$can_compute = $match_type <> $CV_NORM_HAMMING And $match_type <> $CV_NORM_HAMMING2
			$detector = ObjCreate("OpenCV.cv.KAZE").create()
		Case $AKAZE_DETECTOR
			$can_compute = True
			$detector = ObjCreate("OpenCV.cv.AKAZE").create()
		Case $AGAST_DETECTOR
			$detector = ObjCreate("OpenCV.cv.AgastFeatureDetector").create()
	EndSwitch

	Local $keypoints_object = ObjCreate("OpenCV.VectorOfKeyPoint")
	Local $keypoints_scene = ObjCreate("OpenCV.VectorOfKeyPoint")
	Local $descriptors_object = ObjCreate("OpenCV.cv.Mat")
	Local $descriptors_scene = ObjCreate("OpenCV.cv.Mat")

	If $can_compute Then
		$detector.detectAndCompute($img_object, ObjCreate("OpenCV.cv.Mat"), Default, $keypoints_object, $descriptors_object)
		$detector.detectAndCompute($img_scene, ObjCreate("OpenCV.cv.Mat"), Default, $keypoints_scene, $descriptors_scene)
	Else
		$detector.detect($img_object, ObjCreate("OpenCV.cv.Mat"), $keypoints_object)
		$detector.detect($img_scene, ObjCreate("OpenCV.cv.Mat"), $keypoints_scene)
	EndIf

	;;-- Step 2: Matching descriptor vectors with a BruteForce based matcher
	;; Since ORB is a floating-point descriptor NORM_L2 is used
	Local $matcher = ObjCreate("OpenCV.cv.BFMatcher").create()
	Local $knn_matches = ObjCreate("OpenCV.VectorOfVectorOfDMatch")

	If $can_compute Then
		$matcher.knnMatch($descriptors_object, $descriptors_scene, 2, Default, Default, $knn_matches)
	EndIf

	;;-- Filter matches using the Lowe's ratio test
	Local $ratio_thresh = 0.75
	Local $good_matches = ObjCreate("OpenCV.VectorOfDMatch")

	For $i = 0 To $knn_matches.size() - 1
		Local $oDMatch0 = $knn_matches.at($i)[0]
		Local $oDMatch1 = $knn_matches.at($i)[1]

		If $oDMatch0.distance < $ratio_thresh * $oDMatch1.distance Then
			$good_matches.push_back($oDMatch0)
		EndIf
	Next

	;;-- Draw matches
	Local $img_matches = ObjCreate("OpenCV.cv.Mat")
	Local $matchesMask[0]

	If $can_compute Then
		$cv.drawMatches($img_object, $keypoints_object, $img_scene, $keypoints_scene, $good_matches, $img_matches, _OpenCV_ScalarAll(-1), _
				_OpenCV_ScalarAll(-1), $matchesMask, $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)
	Else
		Local $img_object_with_keypoints = ObjCreate("OpenCV.cv.Mat")
		$cv.drawKeypoints($img_object, $keypoints_object, $img_object_with_keypoints, _OpenCV_ScalarAll(-1), $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)

		Local $img_scene_with_keypoints = ObjCreate("OpenCV.cv.Mat")
		$cv.drawKeypoints($img_scene, $keypoints_scene, $img_scene_with_keypoints, _OpenCV_ScalarAll(-1), $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)

		; workaround to concatenate the two images
		$cv.drawMatches($img_object_with_keypoints, $keypoints_object, $img_scene_with_keypoints, $keypoints_scene, $good_matches, $img_matches, _OpenCV_ScalarAll(-1), _
				_OpenCV_ScalarAll(-1), $matchesMask, $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)
	EndIf


	If Not $can_compute Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Compute is not supported for combination ' & GUICtrlRead($ComboAlgorithm) & ' - ' & GUICtrlRead($ComboMatchType) & @CRLF)
	ElseIf $good_matches.size() < 4 Then
		ConsoleWriteError("!>Error: Unable to calculate homography. There is less than 4 point correspondences." & @CRLF)
	Else
		;;-- Localize the object
		Local $obj = ObjCreate("OpenCV.VectorOfPoint2f")
		Local $scene = ObjCreate("OpenCV.VectorOfPoint2f")

		For $i = 0 To $good_matches.size() - 1
			;;-- Get the keypoints from the good matches
			$obj.push_back($keypoints_object.at($good_matches.at($i).queryIdx).pt)
			$scene.push_back($keypoints_scene.at($good_matches.at($i).trainIdx).pt)
		Next

		Local $H = $cv.findHomography($obj, $scene, $CV_RANSAC)

		If $H.empty() Then
			ConsoleWriteError("!>Error: No homography were found." & @CRLF)
		Else
			;;-- Get the corners from the image_1 ( the object to be "detected" )
			Local $obj_corners = ObjCreate("OpenCV.VectorOfPoint2f").create(4)

			$obj_corners.at(0, _OpenCV_Point(0, 0))
			$obj_corners.at(1, _OpenCV_Point($img_object.cols, 0))
			$obj_corners.at(2, _OpenCV_Point($img_object.cols, $img_object.rows))
			$obj_corners.at(3, _OpenCV_Point(0, $img_object.rows))

			Local $scene_corners = ObjCreate("OpenCV.VectorOfPoint2f").create(4)

			$cv.perspectiveTransform($obj_corners, $H, $scene_corners)

			;;-- Draw lines between the corners (the mapped object in the scene - image_2 )
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(0)[0] + $img_object.cols, $scene_corners.at(0)[1]), _
					_OpenCV_Point($scene_corners.at(1)[0] + $img_object.cols, $scene_corners.at(1)[1]), _OpenCV_Scalar(0, 255, 0), 4)
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(1)[0] + $img_object.cols, $scene_corners.at(1)[1]), _
					_OpenCV_Point($scene_corners.at(2)[0] + $img_object.cols, $scene_corners.at(2)[1]), _OpenCV_Scalar(0, 255, 0), 4)
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(2)[0] + $img_object.cols, $scene_corners.at(2)[1]), _
					_OpenCV_Point($scene_corners.at(3)[0] + $img_object.cols, $scene_corners.at(3)[1]), _OpenCV_Scalar(0, 255, 0), 4)
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(3)[0] + $img_object.cols, $scene_corners.at(3)[1]), _
					_OpenCV_Point($scene_corners.at(0)[0] + $img_object.cols, $scene_corners.at(0)[1]), _OpenCV_Scalar(0, 255, 0), 4)
		EndIf
	EndIf

	;-- Show detected matches
	; _cveImshowMat("Good Matches & Object detection", $img_matches)
	_OpenCV_imshow_ControlPic($img_matches, $FormGUI, $PicMatches)
EndFunc   ;==>Detect
