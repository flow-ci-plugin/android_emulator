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
#如果num小于等于1,说明没有安装UI测试apk，接下来执行./gradlew assembleAndroidTest命令
if [ -z "$array" ] ; then
echo "can't find *-debug-androidTest-unaligned.apk"
echo "./gradlew assembleAndroidTest"
#./gradlew assembleAndroidTest
fi
