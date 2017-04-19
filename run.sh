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

  if [[ -z $FLOW_ANDROID_SDK_VERSION ]]; then
    export FLOW_ANDROID_SDK_VERSION=android-23
  fi
  
  if [[ -z FLOW_ANDROID_CPU_VERSION ]]; then
    export FLOW_ANDROID_CPU_VERSION=armeabi-v7a
  fi

  echo "Android SDK version: $FLOW_ANDROID_SDK_VERSION"
  echo "Android CPU version: $FLOW_ANDROID_CPU_VERSION"

  array=$(find $FLOW_CURRENT_PROJECT_PATH -name *-androidTest-unaligned.apk 2>&1)
  #array为空，说明没有安装*-androidTest-unaligned.apk
  if [ -z "$array" ] ; then
     echo " === can't find *-debug-androidTest-unaligned.apk"
     echo "./gradlew assembleAndroidTest"
     ./gradlew assembleAndroidTest
  fi
  sleep 5
  
  #进入到tools目录下，里面有android、emulator等工具
  cd /usr/sdk/android-sdk-linux/tools
  
  #创建名为test的avd，sdk为23(-t 22在docker内表示android-23)，abi为armeabi-v7a
  #不支持x86_64
  echo "android create avd -n test -t 22 --abi default/armeabi-v7a"
  echo no | android create avd -n test -t 22 --abi default/armeabi-v7a
 
  #启动emulator
  echo "emulator -avd test -no-audio -no-window -system /usr/sdk/android-sdk-linux/system-images/android-23/default/armeabi-v7a/system.img &"
  emulator -avd test -no-audio -no-window -system /usr/sdk/android-sdk-linux/system-images/android-23/default/armeabi-v7a/system.img &
  
  echo "adb wait-for-device"
  echo "等待115s,直到emulator完全启动，由于在docker上emulator启动较慢，请耐心等候"
  adb wait-for-device
  sleep 115

  #找到*-debug-unaligned.apk、*-androidTest-unaligned.apk,并安装
  arrays=$(find $FLOW_CURRENT_PROJECT_PATH -name *-unaligned.apk 2>&1)
  for file in ${arrays[@]}
   do
     echo "install APK: "
     adb install -r $file
   done
   
  #adb shell pm list instrumentation可以列举可用的instrumentation,
  #通过下面这条语句可以提取我们所需的instrumentation
  instrumentation=$(adb shell pm list instrumentation|grep 'test/android'|awk -F ' ' '{print substr($1,17)}')
  if [ -z "$instrumentation" ] ; then
     echo " === can not find instrumentation for UI test of your project"
  else
     echo "shell am instrument -w $instrumentation"
     sleep 1
     #启动UI测试
     adb shell am instrument -w $instrumentation
  fi
