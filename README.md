# android_emulator Step
Start an android emulator, which could run your tests in flow.ci

### INPUTS

* `FLOW_ANDROID_SDK_VERSION` - SDK 版本
* `FLOW_ANDROID_CPU_VERSION` - CPU 版本


## EXAMPLE 

```yml
steps:
  - name: android_emulator
    enable: true
    failure: true
    plugin:
      name: android_emulator
      inputs:
        - FLOW_ANDROID_SDK_VERSION=$FLOW_ANDROID_SDK_VERSION
        - FLOW_ANDROID_CPU_VERSION=$FLOW_ANDROID_CPU_VERSION
```
