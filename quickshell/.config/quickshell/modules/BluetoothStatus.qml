import QtQuick
import Quickshell.Bluetooth
import Quickshell.Hyprland
import qs

// BlueZ status via Quickshell.Bluetooth. Click opens the device panel,
// right click toggles adapter power. Hidden when there is no adapter
// (or bluetoothd isn't running).
Pill {
    id: root

    property HyprlandMonitor monitor
    readonly property BluetoothAdapter adapter: BluetoothState.adapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property var connected: (adapter?.devices.values ?? []).filter(d => d.connected)

    visible: adapter !== null
    clickable: true
    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) {
            if (adapter) adapter.enabled = !adapter.enabled
        } else panel.toggle()
    }
    tooltip: {
        if (!adapter || panel.shown) return ""
        if (!enabled) return `${adapter.name}: off`
        if (connected.length === 0) return `${adapter.name}: no devices connected`
        return connected.map(d => d.batteryAvailable
            ? `${d.name}  ${Math.round(d.battery * 100)}%`
            : d.name).join("\n")
    }

    BluetoothPanel {
        id: panel
        anchor.item: root
        adapter: root.adapter
    }

    // Surface pairing prompts (e.g. a phone pairing with us) on the focused bar.
    Connections {
        target: BluetoothAgent
        function onKindChanged() {
            if (BluetoothAgent.kind && root.monitor?.focused && !panel.shown) panel.open()
        }
    }

    Label {
        text: {
            if (!root.enabled) return Theme.icons.btOff
            const n = root.connected.length
            if (n === 0) return Theme.icons.bluetooth
            if (n > 1) return `${Theme.icons.btConnected} ${n}`
            const d = root.connected[0]
            const battery = d.batteryAvailable ? ` ${Math.round(d.battery * 100)}%` : ""
            return `${Theme.icons.btConnected} ${d.name}${battery}`
        }
    }
}
