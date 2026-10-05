import QtQuick
import Quickshell.Bluetooth
import qs

// BlueZ status via Quickshell.Bluetooth. Click toggles adapter power.
// Hidden when there is no adapter (or bluetoothd isn't running).
Pill {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property var connected: (adapter?.devices.values ?? []).filter(d => d.connected)

    visible: adapter !== null
    clickable: true
    onClicked: if (adapter) adapter.enabled = !adapter.enabled
    tooltip: {
        if (!adapter) return ""
        if (!enabled) return `${adapter.name}: off`
        if (connected.length === 0) return `${adapter.name}: no devices connected`
        return connected.map(d => d.batteryAvailable
            ? `${d.name}  ${Math.round(d.battery * 100)}%`
            : d.name).join("\n")
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
