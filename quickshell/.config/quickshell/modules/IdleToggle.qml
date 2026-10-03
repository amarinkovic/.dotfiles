import QtQuick
import Quickshell.Wayland
import qs

Pill {
    id: root

    required property var bar

    clickable: true
    tooltip: inhibitor.enabled ? "Idle inhibitor: on" : "Idle inhibitor: off"
    onClicked: inhibitor.enabled = !inhibitor.enabled

    IdleInhibitor {
        id: inhibitor
        window: root.bar
    }

    Label {
        text: inhibitor.enabled ? Theme.icons.idleOn : Theme.icons.idleOff
    }
}
