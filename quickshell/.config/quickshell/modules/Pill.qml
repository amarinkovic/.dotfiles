import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Rounded translucent container.
// Also owns hover/click/scroll handling and an optional hover tooltip.
Rectangle {
    id: pill

    default property alias content: row.data
    property int padding: 8
    property alias spacing: row.spacing
    property bool background: true
    property bool clickable: false
    property string tooltip
    readonly property alias hovered: area.containsMouse

    signal clicked(var mouse)
    signal scrolled(int delta)

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: Theme.pillHeight
    radius: height / 2
    color: background ? Theme.surface : "transparent"

    // Below the Row so interactive children (workspace buttons, tray icons)
    // get their own clicks first.
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: pill.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: mouse => pill.clicked(mouse)
        onWheel: wheel => pill.scrolled(wheel.angleDelta.y)
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8
    }

    PopupWindow {
        visible: pill.tooltip !== "" && area.containsMouse
        anchor.item: pill
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.margins.top: 6
        implicitWidth: tip.implicitWidth + 20
        implicitHeight: tip.implicitHeight + 12
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: Theme.tooltipBg

            Text {
                id: tip
                anchors.centerIn: parent
                text: pill.tooltip
                textFormat: Text.PlainText
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: Theme.fontSize - 1
            }
        }
    }
}
