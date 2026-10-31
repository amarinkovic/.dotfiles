import QtQuick
import qs

// Horizontal 0..1 slider for drop-down panels. Emits moved() while dragged,
// clicked or scrolled; the owner applies it and feeds `value` back.
Item {
    id: root

    property real value
    property bool dim
    signal moved(real value)

    function clamp(v) { return Math.max(0, Math.min(1, v)) }

    implicitWidth: 200
    implicitHeight: 20

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: height / 2
        color: Qt.rgba(1, 1, 1, 0.12)

        Rectangle {
            width: Math.max(parent.height, knob.x + knob.width / 2)
            height: parent.height
            radius: parent.radius
            gradient: AccentGradient {}
            opacity: root.dim ? 0.35 : 1
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    Rectangle {
        id: knob
        anchors.verticalCenter: parent.verticalCenter
        width: 16
        height: width
        radius: width / 2
        x: root.clamp(root.value) * (root.width - width)
        color: Theme.text
        scale: area.pressed || area.containsMouse ? 1.15 : 1
        Behavior on scale { NumberAnimation { duration: 120 } }
    }

    MouseArea {
        id: area

        function set(mx) { root.moved(root.clamp((mx - knob.width / 2) / (width - knob.width))) }

        anchors.fill: parent
        anchors.topMargin: -4
        anchors.bottomMargin: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => set(mouse.x)
        onPositionChanged: mouse => { if (pressed) set(mouse.x) }
        onWheel: wheel => root.moved(root.clamp(root.value + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)))
    }
}
