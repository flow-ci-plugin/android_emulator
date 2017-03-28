# ************************************************************
#
# This step will init your project
#
#   Variables used:
#     $FLOW_ANDROID_SDK_VERSION
#     $FLOW_ANDROID_CPU_VERSION
#
# ************************************************************

set +e


  echo "Use default Android SDK: android-23"
  export FLOW_ANDROID_SDK_VERSION=android-23

  echo "Use default Android CPU: armeabi-v7a"
  export FLOW_ANDROID_CPU_VERSION=armeabi-v7a

array=$(find $FLOW_CURRENT_PROJECT_PATH -name *-androidTest-unaligned.apk 2>&1)
#array为空，说明没有安装*-androidTest-unaligned.apk
if [ -z "$array" ] ; then
echo "can't find *-debug-androidTest-unaligned.apk"
echo "./gradlew assembleAndroidTest"
./gradlew assembleAndroidTest
fi

cd /usr/sdk/android-sdk-linux/tools
 echo "android create avd -n test -t 22 --abi default/armeabi-v7a"
 echo no | android create avd -n test -t 22 --abi default/armeabi-v7a
 
 echo "emulator -avd test -no-audio -no-window -system /usr/sdk/android-sdk-linux/system-images/android-23/default/armeabi-v7a/system.img &"
 emulator -avd test -no-audio -no-window -system /usr/sdk/android-sdk-linux/system-images/android-23/default/armeabi-v7a/system.img &
 echo "adb wait-for-device"
 adb wait-for-device
 
 echo "等待120s,直到emulator完全启动，由于在docker上emulator启动较慢，请耐心等候"
 sleep 115
 
 arrays=$(find $FLOW_CURRENT_PROJECT_PATH -name *-unaligned.apk 2>&1)
 for file in ${arrays[@]}
 do
 echo "install APK: "
 adb install -r $file
 done
 instrumentation=$(adb shell pm list instrumentation|grep 'test/android'|awk -F ' ' '{print substr($1,17)}')
 echo "shell am instrument -w $instrumentation"
 adb shell am instrument -w $instrumentation
