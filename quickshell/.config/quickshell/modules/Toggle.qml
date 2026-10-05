import QtQuick
import qs

// Pill-shaped on/off switch. Emits toggled(); the owner flips `checked`.
Rectangle {
    id: root

    property bool checked
    signal toggled()

    implicitWidth: 40
    implicitHeight: 22
    radius: height / 2
    color: checked ? "transparent" : Qt.rgba(1, 1, 1, 0.12)
    gradient: checked ? grad : null

    AccentGradient { id: grad }

    Rectangle {
        width: parent.height - 6
        height: width
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 3 : 3
        color: root.checked ? Theme.activeFg : Theme.text
        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
