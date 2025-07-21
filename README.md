# touchpadctl

A little utility which controls touchpad of laptops.

> Have you been annoyed by the flying cursor while typing when accidentally hit the touchpad? If so, try it.

## Supporting

- [x] Gnome Wayland (by gsettings)
- [x] Gnome X11 (By gsettings, untested)
- [ ] KDE
- [ ] Hyprland
- [ ] ...

## Requirements

- [fishshell](https://fishshell.com/) 

## Installation

```shell
git clone https://github.com/lialh4qwq/touchpadctl.git
cd touchpadctl
sudo mv touchpadctl.fish /usr/local/bin/touchpadctl
sudo chown root:root /usr/local/bin/touchpadctl
sudo chmod 0755 /usr/local/bin/touchpadctl
```

## Usage

### simply run in shell:

```shell
touchpadctl
```

### or bind it to a shortcut by your DE's settings. for example:

gnome:

Settings → Keyboard → View and Custom Shortcuts → Custom shortcuts → "+"

### or anyhow you like

Enjoy!

## Todo

- [ ] Support more DE/WM like KDE, Hyprland, etc.
- [ ] Support disable touchpad by xinput to work in generic X11 environments
- [ ] More complete and user-friendly CLI interface, supporting operating in specific method
- [ ] Config file support that defining default behavior
- [ ] Daemon mode for DE/WM that can't handle shortcuts

🕊️🕊️🕊️
