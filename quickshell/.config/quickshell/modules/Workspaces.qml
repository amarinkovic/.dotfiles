import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

// All workspaces on every output (waybar's all-outputs: true).
// Dispatches use Hyprland 0.55's Lua syntax; legacy `workspace N` no longer exists.
Pill {
    id: root

    required property HyprlandMonitor monitor

    padding: 2
    spacing: 2

    function switchTo(ws) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${ws}" })`)
    }

    onScrolled: delta => switchTo(delta > 0 ? "r-1" : "r+1")

    Repeater {
        model: Hyprland.workspaces.values.filter(ws => ws.id > 0)

        Rectangle {
            id: btn

            required property HyprlandWorkspace modelData
            readonly property bool onThisMonitor: modelData.monitor === root.monitor
            readonly property bool highlighted: (modelData.active && onThisMonitor) || area.containsMouse

            implicitWidth: Math.max(24, label.implicitWidth + 12)
            implicitHeight: Theme.pillHeight - 4
            radius: height / 2
            color: highlighted ? Theme.activeBg : "transparent"
            border.width: modelData.active && !onThisMonitor ? 1 : 0
            border.color: Theme.activeBg

            Behavior on color { ColorAnimation { duration: 200 } }

            Label {
                id: label
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSize - 1
                color: btn.highlighted ? Theme.activeFg : Theme.text
                glow: !btn.highlighted
                text: {
                    const ws = btn.modelData
                    const icon = ws.urgent ? Theme.icons.wsUrgent
                               : ws.active ? Theme.icons.wsActive
                               : Theme.icons.wsDefault
                    return `${icon} ${ws.name}`
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
