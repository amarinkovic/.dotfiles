import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import qs

// cpu / memory / disk / temperature / battery group, polled from /proc and /sys.
Pill {
    id: root

    property real cpu: 0
    property real mem: 0
    property string memTip
    property real disk: 0
    property string diskTip
    property real temp: 0

    property real lastTotal: 0
    property real lastIdle: 0

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery?.isLaptopBattery ?? false

    background: false
    padding: 0
    spacing: 8

    Process {
        id: poll
        running: true
        command: ["sh", "-c",
            "head -1 /proc/stat;" +
            "grep -E '^(MemTotal|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo;" +
            "df -B1 --output=used,size / | tail -1;" +
            "cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input"]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text.trim().split("\n"))
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: poll.running = true
    }

    function gib(kb) { return (kb / 1048576).toFixed(1) }

    function parse(lines) {
        const cpu = lines[0].split(/\s+/).slice(1).map(Number)
        const idle = cpu[3] + cpu[4]
        const total = cpu.reduce((a, b) => a + b, 0)
        if (lastTotal > 0)
            root.cpu = 100 * (1 - (idle - lastIdle) / (total - lastTotal))
        lastTotal = total
        lastIdle = idle

        const m = {}
        for (const l of lines.slice(1, 5)) {
            const [k, v] = l.split(/:\s+/)
            m[k] = parseInt(v)
        }
        root.mem = 100 * (1 - m.MemAvailable / m.MemTotal)
        root.memTip = `Physical: ${gib(m.MemTotal - m.MemAvailable)}/${gib(m.MemTotal)}GiB used\n`
                    + `Swap: ${gib(m.SwapTotal - m.SwapFree)}/${gib(m.SwapTotal)}GiB used`

        const [used, size] = lines[5].trim().split(/\s+/).map(Number)
        root.disk = 100 * used / size
        root.diskTip = `${(used / 2 ** 30).toFixed(1)} GiB / ${(size / 2 ** 30).toFixed(1)} GiB used on /`

        root.temp = parseInt(lines[6]) / 1000
    }

    component Stat: Pill {
        property alias text: label.text
        property bool critical: false
        // 0..1 usage drawn as a thin bar under the text; < 0 hides it.
        property real level: -1

        background: false
        padding: 0

        underlay: Rectangle {
            visible: level >= 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -3
            height: 2
            radius: 1
            color: Qt.rgba(1, 1, 1, 0.12)

            Rectangle {
                height: parent.height
                radius: 1
                width: parent.width * Math.max(0, Math.min(1, level))
                color: level >= 0.8 ? Theme.red : Theme.magenta
                Behavior on width { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 300 } }
            }
        }
        Label {
            id: label
            color: Theme.text
            glowColor: Theme.brightRed

            // waybar's `blink` keyframes: alternate between red and text colour.
            SequentialAnimation on color {
                running: critical
                loops: Animation.Infinite
                onRunningChanged: if (!running) label.color = Theme.text
                ColorAnimation { from: Theme.red; to: Theme.text; duration: 2500 }
                ColorAnimation { from: Theme.text; to: Theme.red; duration: 2500 }
            }
        }
    }

    Stat {
        text: `${Theme.icons.cpu} ${Math.round(root.cpu)}%`
        critical: root.cpu >= 95
        level: root.cpu / 100
        clickable: true
        onClicked: Quickshell.execDetached(["ghostty", "-e", "btop"])
    }
    Stat {
        text: `${Theme.icons.memory} ${Math.round(root.mem)}%`
        tooltip: root.memTip
        level: root.mem / 100
    }
    Stat {
        text: `${Theme.icons.disk} ${Math.round(root.disk)}%`
        tooltip: root.diskTip
        level: root.disk / 100
    }
    Stat {
        readonly property var icons: Theme.icons.temp
        text: `${icons[Math.min(2, Math.floor(root.temp / 40))]} ${Math.round(root.temp)}°C`
        critical: root.temp >= 80
        level: root.temp / 100
    }
    Stat {
        visible: root.hasBattery
        readonly property var icons: Theme.icons.battery
        readonly property real pct: root.battery?.percentage * 100 ?? 0
        readonly property bool charging: root.battery?.state === UPowerDeviceState.Charging
        text: `${icons[Math.min(4, Math.floor(pct / 20))]} ${Math.round(pct)}%${charging ? Theme.icons.charging : ""}`
        critical: pct <= 20 && !charging
        level: pct / 100
    }
}
