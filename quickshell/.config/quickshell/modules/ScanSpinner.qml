import QtQuick
import qs

// Refresh arrow for panel headers: spins while `scanning`, click to toggle.
Text {
    id: root

    property bool scanning
    signal clicked()

    text: Theme.icons.refresh
    color: scanning ? Theme.lavender : Theme.text
    opacity: scanning || area.containsMouse ? 1 : 0.5
    font.family: Theme.font
    font.pixelSize: Theme.fontSize - 1

    RotationAnimation on rotation {
        running: root.scanning
        from: 0; to: 360; duration: 1000
        loops: Animation.Infinite
        onRunningChanged: if (!running) root.rotation = 0
    }

    MouseArea {
        id: area
        anchors.fill: parent
        anchors.margins: -6
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
