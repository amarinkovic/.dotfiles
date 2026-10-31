import QtQuick
import QtQuick.Layouts
import qs

// Inline drop-down for panels: shows the current option and, when clicked,
// expands the full list below it. `labelOf` names an option.
ColumnLayout {
    id: root

    property string icon
    property var options: []
    property var current
    property var labelOf: o => String(o)
    property bool expanded
    signal selected(var option)

    Layout.fillWidth: true
    spacing: 4

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 40
        radius: 14
        color: root.expanded ? Theme.hoverBg : headerArea.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 1, 1, 0.05)
        Behavior on color { ColorAnimation { duration: 150 } }

        NeonBorder { visible: root.expanded; radius: parent.radius }

        MouseArea {
            id: headerArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 12

            Text {
                text: root.icon
                color: Theme.lavender
                font.family: Theme.font
                font.pixelSize: Theme.fontSize + 2
                Layout.preferredWidth: 22
                horizontalAlignment: Text.AlignHCenter
            }
            PanelText {
                text: root.current ? root.labelOf(root.current) : "None"
                Layout.fillWidth: true
            }
            PanelText {
                dim: true
                text: root.expanded ? Theme.icons.chevronUp : Theme.icons.chevronDown
            }
        }
    }

    Repeater {
        model: root.expanded ? root.options : []

        Rectangle {
            id: option

            required property var modelData
            readonly property bool active: modelData === root.current

            Layout.fillWidth: true
            Layout.leftMargin: 8
            implicitHeight: 34
            radius: 10
            color: optionArea.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                id: optionArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.expanded = false
                    root.selected(option.modelData)
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                PanelText {
                    text: root.labelOf(option.modelData)
                    color: option.active ? Theme.lavender : Theme.text
                    font.weight: option.active ? Font.Bold : Font.Normal
                    Layout.fillWidth: true
                }
                PanelText {
                    visible: option.active
                    text: Theme.icons.check
                    color: Theme.lavender
                }
            }
        }
    }
}
