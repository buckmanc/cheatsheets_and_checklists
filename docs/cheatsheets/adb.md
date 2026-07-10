# Android Debug Bridge Commands

[run adb from termux](https://xdaforums.com/t/termux-adb-running-adb-within-android-using-termux-wireless-adb.4724780)

## hide that annoying "do you want to rotate" icon

```bash
adb shell settings put secure show_rotation_suggestions 0
```

## don't let apps force set rotation (it's cool but it's more trouble than it's worth)
```bash
adb shell wm set-ignore-orientation-request true
```

## grant an app (like Termux) permissions to sensitive notifications (like 2FA codes)

```bash
adb shell appops set com.termux RECEIVE_SENSISITVE_NOTIFICATIONS allow
```

## grant write settings permissions

```bash
adb shell pm grant com.termux.api android.permission.WRITE_SETTINGS
adb shell pm grant com.termux.api android.permission.WRITE_SECURE_SETTINGS
```
