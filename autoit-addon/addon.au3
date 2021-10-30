#include-once
#include "vector_DeviceInfo.au3"

Func _addonEnumerateVideoDevices($videoDevices)
    ; AUTOITAPI(void) enumerateVideoDevices(std::vector<DeviceInfo> &videoDevices, std::vector<DeviceInfo> &audioDevices);
    Return _OpenCV_DllCall($addon_dll, "none:cdecl", "enumerateVideoDevices", "ptr", $videoDevices)
EndFunc

Func _addonEnumerateAudioDevices($audioDevices)
    ; AUTOITAPI(void) enumerateAudioDevices(std::vector<DeviceInfo> &videoDevices, std::vector<DeviceInfo> &audioDevices);
    Return _OpenCV_DllCall($addon_dll, "none:cdecl", "enumerateAudioDevices", "ptr", $audioDevices)
EndFunc

Func _addonEnumerateDevices($videoDevices, $audioDevices)
    ; AUTOITAPI(void) enumerateDevices(std::vector<DeviceInfo> &videoDevices, std::vector<DeviceInfo> &audioDevices);
    Return _OpenCV_DllCall($addon_dll, "none:cdecl", "enumerateDevices", "ptr", $videoDevices, "ptr", $audioDevices)
EndFunc