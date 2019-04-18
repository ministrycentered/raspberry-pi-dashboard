# Raspberry Pi Dashboard

Easily drive a kiosk display with a Raspberry Pi, and allow changing the URL displayed remotely.

# Setup

This guide assumes you have installed Raspbian on your Raspberry Pi, and have it successfully connected to the network, and connected to a monitor. There are [lots of guides](https://www.google.com/search?q=Raspberry+Pi+Noobs+Setup) out there to get you this far.

You can perform the rest of these updates with a connected keyboard and mouse, or [enable SSH](https://www.raspberrypi.org/forums/viewtopic.php?t=210137) and do it remotely.

### Install Ruby
You can use [PiSetup](https://github.com/mcfadden/PiSetup) to help you do this. You'll only need Ruby, not the other things it provides. You're welcome to use a different approach, but install ruby `2.6.2`

### Assign static IP
You'll want a static IP for your Raspberry Pi to more easily update the displayed URL remotely. Once again, there are [guides](http://www.avoiderrors.com/assign-static-ip-raspberry-pi) available to help you do this if you're unfamiliar with it.

### Install the dashboard script
On the pi (either through `ssh` or a local terminal) run this:

```bash
cd ~/
git clone https://github.com/ministrycentered/raspberry-pi-dashboard.git
```

If desired, change the `API_KEY`, `PORT` and `DEFAULT_PAGE` in `~/raspberry-pi-dashboard/dashboard.rb`.

### Make it better

Let us hide the mouse cursor:

```bash
sudo apt-get install unclutter
```

Make it automatically start:

```bash
nano ~/.config/lxsession/LXDE-pi/autostart
```

Paste in this as the contents:

```bash
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xset s off
@xset -dpms
@xset s noblank
@sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/chromium/Default/Preferences
@/usr/local/bin/ruby /home/pi/raspberry-pi-dashboard/dashboard.rb
@unclutter -idle 0.5
```

That will disable the screensaver, disable the power savings (that turn the display off), clear any warnings from the browser, automatically start our script, and hide the mouse cursor.


# Changing the displayed page

The Ruby script is a tiny web server, so you can control the displayed page by accessing special urls. The format is:

```http://<ip addresss>:<port>?api_key=<api_key>&url=<url>```

Example:

```http://192.168.12.209:8039?api_key=ulxMkC8k3VpkBemqPmuu&url=https://apple.com```

### Using a Stream Deck

If you have a Stream Deck you can use the "Website" action (under System) and paste in a URL like shown above. Be sure to check the `Access in background` checkbox.
