import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Rounded translucent container.
// Also owns hover/click/scroll handling and an optional hover tooltip.
Rectangle {
    id: pill

    default property alias content: row.data
    // Drawn behind the content, in the content row's coordinates.
    property alias underlay: under.data
    property int padding: 8
    property alias spacing: row.spacing
    property bool background: true
    property bool clickable: false
    // Fill with the accent gradient while hovered.
    property bool accentHover: false
    property string tooltip
    readonly property alias hovered: area.containsMouse

    signal clicked(var mouse)
    signal scrolled(int delta)

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: Theme.pillHeight
    radius: height / 2
    color: background ? Theme.surface : "transparent"

    Rectangle {
        anchors.fill: parent
        radius: pill.radius
        gradient: AccentGradient {}
        visible: opacity > 0
        opacity: pill.accentHover && pill.hovered ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    NeonBorder {
        visible: pill.background
        opacity: pill.hovered ? 1 : 0.5
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

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

    Item {
        id: under
        x: row.x
        y: row.y
        width: row.width
        height: row.height
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8
    }

    PopupWindow {
        id: popup
        visible: pill.tooltip !== "" && area.containsMouse
        anchor.item: pill
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.margins.top: 6
        implicitWidth: tip.implicitWidth + 20
        implicitHeight: tip.implicitHeight + 12
        color: "transparent"

        Rectangle {
            id: tipBox
            width: parent.width
            height: parent.height
            radius: 8
            color: Theme.tooltipBg

            NeonBorder { radius: 8 }

            states: State {
                when: popup.visible
                PropertyChanges { tipBox.opacity: 1; tipBox.y: 0 }
            }
            opacity: 0
            y: -6
            transitions: Transition {
                NumberAnimation { properties: "opacity,y"; duration: 180; easing.type: Easing.OutCubic }
            }

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
