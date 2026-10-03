import QtQuick
import Quickshell.Io
import qs

// NetworkManager status via nmcli. Click toggles the interface/IP view
// (waybar's format-alt).
Pill {
    id: root

    property string type      // "wifi" | "ethernet" | ""
    property string device
    property string ssid
    property int signal
    property string ip
    property string gateway
    property bool alt: false

    clickable: true
    onClicked: alt = !alt
    tooltip: device ? `${device} via ${gateway}` : ""

    Process {
        id: poll
        running: true
        command: ["sh", "-c", `
            dev=$(nmcli -t -f TYPE,STATE,DEVICE dev | awk -F: '$2=="connected" && ($1=="wifi" || $1=="ethernet") {print $1":"$3; exit}')
            iface=\${dev#*:}
            echo "type=\${dev%%:*}"
            echo "device=$iface"
            nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | awk -F: '$1=="yes" {print "ssid="$2; print "signal="$3; exit}'
            [ -n "$iface" ] && ip -4 -o addr show dev "$iface" | awk '{print "ip="$4; exit}'
            ip route show default | awk '{print "gateway="$3; exit}'
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const kv = {}
                for (const line of text.split("\n")) {
                    const i = line.indexOf("=")
                    if (i > 0) kv[line.slice(0, i)] = line.slice(i + 1)
                }
                root.type = kv.device ? kv.type : ""
                root.device = kv.device ?? ""
                root.ssid = kv.ssid ?? ""
                root.signal = parseInt(kv.signal) || 0
                root.ip = kv.ip ?? ""
                root.gateway = kv.gateway ?? ""
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: poll.running = true
    }

    Label {
        text: {
            if (!root.type) return "⚠ Disconnected"
            const icon = root.type === "wifi"
                ? Theme.icons.wifi[Math.min(4, Math.floor(root.signal / 20))]
                : Theme.icons.ethernet
            if (root.alt) return `${icon} ${root.device}: ${root.ip || "(No IP)"}`
            return root.type === "wifi" ? `${icon} ${root.ssid} ${root.signal}%` : `${icon} ${root.device}`
        }
    }
}
