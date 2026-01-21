# Android Debug Bridge Commands

## hide that annoying "do you want to rotate" icon

```bash
adb shell settings put secure show_rotation_suggestions 0
```

## don't let apps force set rotation (it's cool but it's more trouble than it's worth)
```bash
adb shell wm set-ignore-orientation-request true
```
