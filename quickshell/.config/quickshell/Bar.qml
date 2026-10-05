import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.modules

PanelWindow {
    id: bar

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    color: "transparent"

    RowLayout {
        id: left
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 6
        }
        spacing: Theme.spacing

        IconButton {
            text: Theme.icons.arch
            fontSize: Theme.fontSize + 4
            command: "wofi --show drun"
        }
        Workspaces { monitor: bar.monitor }
    }

    // Stays centred, but never wider than the gap to the nearer side group.
    WindowTitle {
        anchors.centerIn: parent
        monitor: bar.monitor
        width: Math.min(implicitWidth, 2 * Math.min(
            bar.width / 2 - left.x - left.width,
            right.x - bar.width / 2) - 2 * Theme.spacing)
    }

    RowLayout {
        id: right
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 6
        }
        spacing: Theme.spacing

        IdleToggle { bar: bar }
        Dnd {}
        Privacy {}
        Media {}
        Volume {}
        Tray {}
        Hardware {}
        BluetoothStatus { monitor: bar.monitor }
        Network {}
        Clock {}
        IconButton {
            text: Theme.icons.power
            command: "wlogout --protocol layer-shell"
        }
    }
}
