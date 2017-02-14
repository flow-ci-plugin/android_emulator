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

if [[ -z $FLOW_ANDROID_SDK_VERSION ]] && [[ -z $FLOW_ANDROID_CPU_VERSION ]]; then
  echo "WARNING: the [FLOW_PROJECT_ANDROID_SDK] not exist..."
  echo "Use default Android SDK: android-18"
  export FLOW_ANDROID_SDK_VERSION=android-18

  echo "WARNING: the [FLOW_PROJECT_ANDROID_CPU] not exist..."
  echo "Use default Android CPU: armeabi-v7a"
  export FLOW_ANDROID_CPU_VERSION=armeabi-v7a

fi

echo "echo no | android create avd --force -n test -t ${FLOW_ANDROID_SDK_VERSION} --abi ${FLOW_ANDROID_CPU_VERSION}"
echo no | android create avd --force -n test -t ${FLOW_ANDROID_SDK_VERSION} --abi ${FLOW_ANDROID_CPU_VERSION}

echo "emulator -avd test -no-skin -no-audio -no-window &"
emulator -avd test -no-skin -no-audio -no-window &

echo "adb wait-for-device"
adb wait-for-device