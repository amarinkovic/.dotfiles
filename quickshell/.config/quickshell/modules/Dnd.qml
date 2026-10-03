import QtQuick
import Quickshell.Io
import qs

// Do-Not-Disturb toggle wired to dunst.
Pill {
    id: root

    property bool paused: false

    clickable: true
    onClicked: toggle.running = true

    Process {
        id: query
        command: ["dunstctl", "is-paused"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.paused = text.trim() === "true"
        }
    }

    Process {
        id: toggle
        command: ["dunstctl", "set-paused", "toggle"]
        onExited: query.running = true
    }

    // Catch changes made outside the bar (e.g. a dunstctl keybind).
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: query.running = true
    }

    Label {
        text: root.paused ? Theme.icons.dndOn : Theme.icons.dndOff
    }
}
