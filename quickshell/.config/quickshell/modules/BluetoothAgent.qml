pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth

// BlueZ pairing agent backed by a long-running bluetoothctl, since
// Quickshell.Bluetooth doesn't provide one. Without an agent, devices that
// need a PIN or passkey confirmation can't pair. Shared by every bar so
// there's a single default agent; its prompts are parsed off stdout.
Singleton {
    id: root

    // "" | "confirm" | "pin" | "passkey" | "display"
    property string kind
    property string message
    property string code

    function reply(text) {
        proc.write(text + "\n")
        clear()
    }

    function clear() {
        kind = ""
        message = ""
        code = ""
    }

    function request(k, msg, c) {
        kind = k
        message = msg
        code = c ?? ""
    }

    Process {
        id: proc

        property string buf
        // Briefly forced false after an exit so the binding flips back to
        // true and respawns bluetoothctl (e.g. after it crashes on resume).
        property bool cooling

        running: Bluetooth.defaultAdapter !== null && !cooling
        command: ["bluetoothctl"]
        stdinEnabled: true
        onStarted: write("agent KeyboardDisplay\ndefault-agent\n")
        onExited: {
            root.clear()
            buf = ""
            // Start the timer first: if it's already gone (config teardown
            // on reload) this throws before cooling can get stuck true.
            respawn.start()
            cooling = true
        }

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => proc.parse(data)
        }

        function parse(data) {
            buf = (buf + data.replace(/\x1b\[[0-9;]*[A-Za-z]|\r/g, "")).slice(-1024)
            const re = /Confirm passkey (\d+)|Accept pairing|Authorize service (\S+)|Enter PIN code|Enter passkey|\[agent\] PIN code: (\S+)|\[agent\] Passkey: (\d+)|Request canceled/g
            let m, end = 0
            while ((m = re.exec(buf)) !== null) {
                end = re.lastIndex
                const s = m[0]
                if (m[1]) root.request("confirm", "Confirm this passkey matches the device", m[1])
                else if (s === "Accept pairing") root.request("confirm", "Accept pairing request?")
                else if (m[2]) root.request("confirm", `Authorize service ${m[2]}?`)
                else if (s === "Enter PIN code") root.request("pin", "Enter the device's PIN code")
                else if (s === "Enter passkey") root.request("passkey", "Enter the device's passkey")
                else if (m[3]) root.request("display", "Type this PIN on the device", m[3])
                else if (m[4]) root.request("display", "Type this passkey on the device", m[4])
                else root.clear()
            }
            buf = buf.slice(end)
        }
    }

    Timer {
        id: respawn
        interval: 2000
        onTriggered: proc.cooling = false
    }
}
