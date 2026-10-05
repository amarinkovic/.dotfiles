pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth

// Which adapter the bar shows and uses. Choosing one powers the others off
// so BlueZ can only connect through it. The choice is saved by address
// (adapter ids like hci0 shuffle on replug) and re-applied whenever the
// adapters change, e.g. at boot when BlueZ powers them all on.
Singleton {
    id: root

    readonly property var adapters: Bluetooth.adapters.values
    // Adapter name -> address. Quickshell doesn't expose addresses, so
    // they come from `bluetoothctl list`.
    property var addresses: ({})
    // Adapter id (hci0) -> hardware name from the USB id database.
    property var labels: ({})

    readonly property BluetoothAdapter adapter:
        adapters.find(a => addressOf(a) === saved.preferred)
        ?? adapters.find(a => a.enabled)
        ?? Bluetooth.defaultAdapter

    function addressOf(a) { return addresses[a?.name] ?? "" }
    function labelOf(a) { return labels[a?.adapterId] || a?.name || "" }

    function select(a) {
        saved.preferred = addressOf(a)
        a.enabled = true
        enforce()
    }

    function enforce() {
        const chosen = adapters.find(a => addressOf(a) === saved.preferred)
        if (!chosen) return
        for (const a of adapters)
            if (a !== chosen && a.enabled) a.enabled = false
    }

    onAdaptersChanged: list.running = true
    onAddressesChanged: enforce()

    // Re-apply if something else powers another adapter on.
    Instantiator {
        model: root.adapters
        delegate: Connections {
            required property BluetoothAdapter modelData
            target: modelData
            function onEnabledChanged() { if (modelData.enabled) root.enforce() }
            function onNameChanged() { list.running = true }
        }
    }

    Process {
        id: list
        command: ["sh", "-c", `
            bluetoothctl list
            for h in /sys/class/bluetooth/hci*; do
                case $h in *:*) continue;; esac
                props=$(udevadm info -q property -p "$(dirname "$(readlink -f "$h/device")")")
                vendor=$(echo "$props" | sed -n 's/^ID_VENDOR_FROM_DATABASE=//p' | cut -d' ' -f1)
                model=$(echo "$props" | sed -n 's/^ID_MODEL_FROM_DATABASE=//p' | sed 's/ *(HCI mode)//; s/Bluetooth *//')
                echo "Label $(basename "$h") $vendor $model"
            done
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const addrs = {}, labels = {}
                for (const line of text.replace(/\x1b\[[0-9;]*[A-Za-z]/g, "").split("\n")) {
                    let m = line.match(/^Controller (\S+) (.*?)(?: \[default\])?\s*$/)
                    if (m) addrs[m[2]] = m[1]
                    m = line.match(/^Label (\S+) (.*?)\s*$/)
                    if (m) labels[m[1]] = m[2]
                }
                root.labels = labels
                root.addresses = addrs
            }
        }
    }

    FileView {
        path: Quickshell.statePath("bluetooth.json")
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.enforce()
        // Missing on first run; written once a choice is made.
        printErrors: false

        JsonAdapter {
            id: saved
            property string preferred
        }
    }
}
