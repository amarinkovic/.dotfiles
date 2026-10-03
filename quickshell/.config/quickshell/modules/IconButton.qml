import QtQuick
import Quickshell
import qs

// Pill with a single glyph that runs a shell command on click.
Pill {
    id: root

    property string text
    property string command
    property int fontSize: Theme.fontSize

    implicitWidth: Theme.pillHeight + 4
    clickable: true
    color: hovered ? Theme.activeBg : Theme.surface
    onClicked: Quickshell.execDetached(["sh", "-c", command])

    Behavior on color { ColorAnimation { duration: 150 } }

    Label {
        text: root.text
        font.pixelSize: root.fontSize
        color: root.hovered ? Theme.activeFg : Theme.text
        glow: !root.hovered
    }
}
