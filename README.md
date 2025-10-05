# hyprland-share-picker-gtk4

A simple screen sharing picker for **Hyprland** built with GTK4.

<div align="center">
  <img width="797" height="498" alt="light.png" src="https://github.com/user-attachments/assets/42c3bec4-c512-433d-9a6b-39838ded0c48" />
</div>

## Requirements

To bundle this app, you need:

- `luajit` 
- `luajit-lgi-git`
- `astal-lua`
- `AstalHyprland` 

## Installation

To make the app available for all users, move the bundled binary to `/usr/local/bin`

```bash
sudo mv hyprland-share-picker-gtk4 /usr/local/bin/
sudo chmod +x /usr/local/bin/hyprland-share-picker-gtk4
````

Then, edit your Hyprland configuration file `~/.config/hypr/xdph.conf` and add:

```ini
screencopy {
    custom_picker_binary = hyprland-share-picker-gtk4
}
```

## Usage

Once installed, the app will automatically be used by Hyprland as the custom screen picker. 

[Try it out](https://mozilla.github.io/webrtc-landing/gum_test.html)
