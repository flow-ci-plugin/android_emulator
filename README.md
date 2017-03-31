# android_emulator Step
Start an iOS emulator, which could run your unitTests in flow.ci

## EXAMPLE 

```yml
steps:
  - name: objc_unit_test
    enable: true
    failure: true
    plugin:
      name: android_emulator
      
```
