# Pi Music

Setting up headless Raspberry Pis for music streaming.

## Pi

1. Flash your SD cards with Pi Imager and pick PiOS Lite

## Sendspin Daemon

### Modern Pis

1. Install dependencies
	- `sudo apt install libffi-dev python3-dev libjpeg-dev zlib1g-dev`
1. Per [GitHub page](https://github.com/Sendspin/sendspin-cli#daemon-mode), install with the below command:
	- `curl -fsSL https://raw.githubusercontent.com/Sendspin/sendspin-cli/refs/heads/main/scripts/systemd/install-systemd.sh | sudo bash`
1. If using a non-default audio device (such as HDMI on a device with a headphone jack)
	1. `sendspin audio-devices list`
	2. `sendspin --audio-devices 'hdmi'`

### Old Pis (like Pi Zero W 1)

1. use [sendspin-armv2](https://github.com/LeoLTM/sendspin-armv6)

## Raspotify

1. Install dependencies
	- `sudo apt install curl`
1. Install Raspotify (from the github install script rather than waiting for the website to be updated)
	- `curl -sL https://raw.githubusercontent.com/dtcooper/raspotify/refs/heads/master/install.sh | sh`
1. Tweaks for non-default audio device
	1. Update `/etc/raspotify/conf` with your alsa audio hardware index from `aplay -l`
		- `LIBRESPOT_DEVICE="hw:1,0"`
	1. You may need to change `hw` to `plughw` to have alsa convert the stream to a format your hardware can use
	1. `sudo systemctl restart raspotify`
1. Check error logs with `journalctl -u raspotify -f`
