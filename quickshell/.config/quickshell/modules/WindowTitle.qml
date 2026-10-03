import QtQuick
import Quickshell.Hyprland
import qs

// Focused window title, only on the focused monitor (waybar's separate-outputs).
Label {
    required property HyprlandMonitor monitor

    readonly property string title: Hyprland.focusedMonitor === monitor && Hyprland.activeToplevel
        ? (Hyprland.activeToplevel.title ?? "") : ""

    text: title.length > 90 ? title.slice(0, 89) + "…" : title
    elide: Text.ElideRight
    visible: title !== "" && width > 0
    glowColor: Theme.brightRed
}
