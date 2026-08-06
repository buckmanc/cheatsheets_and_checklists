# Echo Show 5 Jailbreak Steps

## Recovery

[xda source](https://xdaforums.com/t/unlock-root-twrp-unbrick-amazon-echo-show-5-1st-gen-2019-checkers.4762900/)

1. download the amonet package from the xda link
1. run `sudo ./fastbrick.sh` (or the bat version on windows)
1. connect via usb
1. hold down all three buttons and power on until "=> FASTBOOT" appears
1. once detected, type "YES" at the prompt
1. wait till it says you're good

## Flashing LineageOS

1. download LineageOS image from the xda link
1. download the corresponding [MindTheGapps](https://wiki.lineageos.org/gapps/) package (ARM, match LineageOS version) (needed to install Google Play apps, ie Home Assistant)
1. on device, wipe system, data, and cache
1. on device, go to Advanced > Sideload and run it
1. on compy, run `adb sideload Lineage*`
1. when command completes on compy, reboot device back into recovery (only way to start a new adb sideload session)
	- don't use "reboot system" on the sideload page
	- ignore any "no os!" warnings
1. similarly, start Advanced > Sideload and run `adb sideload MindTheGapps*`
1. this time hit "reboot system" when done

## Post-Install Tweaks

- Home Assistant
	1. install the Home Assistant Companion app
	1. optional: make a "public" Home Assistant user and disable external network login for it
	1. set Home Assistant as the launcher
	1. turn on the sensors you want
- TODO: performance tweaks, as it is *slow*
- TODO: wake on motion

