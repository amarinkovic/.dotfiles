import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

// All workspaces on every output (waybar's all-outputs: true).
// Dispatches use Hyprland 0.55's Lua syntax; legacy `workspace N` no longer exists.
Pill {
    id: root

    required property HyprlandMonitor monitor

    readonly property var workspaces: Hyprland.workspaces.values.filter(ws => ws.id > 0)
    readonly property int activeIndex: workspaces.findIndex(ws => ws.active && ws.monitor === monitor)
    readonly property Item activeButton: activeIndex >= 0 && activeIndex < buttons.count ? buttons.itemAt(activeIndex) : null

    padding: 2
    spacing: 2

    function switchTo(ws) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${ws}" })`)
    }

    onScrolled: delta => switchTo(delta > 0 ? "r-1" : "r+1")

    // Gradient pill that slides between workspaces.
    underlay: Rectangle {
        visible: root.activeButton !== null
        x: root.activeButton?.x ?? 0
        y: root.activeButton?.y ?? 0
        width: root.activeButton?.width ?? 0
        height: Theme.pillHeight - 4
        radius: height / 2
        gradient: AccentGradient {}

        Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
        Behavior on width { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
    }

    Repeater {
        id: buttons
        model: root.workspaces

        Rectangle {
            id: btn

            required property HyprlandWorkspace modelData
            required property int index
            readonly property bool onThisMonitor: modelData.monitor === root.monitor
            readonly property bool current: index === root.activeIndex

            implicitWidth: Math.max(24, label.implicitWidth + 12)
            implicitHeight: Theme.pillHeight - 4
            radius: height / 2
            color: area.containsMouse && !current ? Theme.hoverBg : "transparent"
            border.width: modelData.active && !onThisMonitor ? 1 : 0
            border.color: Theme.activeBg

            Behavior on color { ColorAnimation { duration: 150 } }

            Label {
                id: label
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSize - 1
                color: btn.current ? Theme.activeFg : btn.modelData.urgent ? Theme.red : Theme.text
                glow: !btn.current
                text: {
                    const ws = btn.modelData
                    const icon = ws.urgent ? Theme.icons.wsUrgent
                               : ws.active ? Theme.icons.wsActive
                               : Theme.icons.wsDefault
                    return `${icon} ${ws.name}`
                }

                Behavior on color { ColorAnimation { duration: 200 } }

                // Urgent workspaces pulse until visited.
                SequentialAnimation on opacity {
                    running: btn.modelData.urgent
                    loops: Animation.Infinite
                    onRunningChanged: if (!running) label.opacity = 1
                    NumberAnimation { to: 0.35; duration: 500; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1; duration: 500; easing.type: Easing.InOutSine }
                }
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.switchTo(btn.modelData.name)
            }
        }
    }
}
