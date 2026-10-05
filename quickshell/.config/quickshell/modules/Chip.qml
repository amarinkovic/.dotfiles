import QtQuick
import qs

// Small rounded button for drop-down panels: a glyph and optional label.
Rectangle {
    id: chip

    property string icon
    property string label
    property bool active
    signal clicked()

    implicitWidth: chipRow.implicitWidth + (label ? 24 : 12)
    implicitHeight: 28
    radius: height / 2
    color: active ? Theme.hoverBg : chipArea.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 1, 1, 0.05)
    Behavior on color { ColorAnimation { duration: 150 } }

    NeonBorder { visible: chip.active; radius: chip.radius }

    Row {
        id: chipRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: chip.icon
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
        }
        Text {
            visible: chip.label !== ""
            text: chip.label
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.fontSize - 2
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: chipArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: chip.clicked()
    }
}
