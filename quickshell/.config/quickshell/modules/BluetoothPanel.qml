import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs

// Device panel that drops down from the bar's bluetooth pill: power,
// adapter choice, scanning, visibility, paired/available devices and
// pairing prompts.
DropPanel {
    id: root

    property BluetoothAdapter adapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property var all: adapter?.devices.values ?? []
    // Connected first, then by name.
    readonly property var paired: all.filter(d => d.paired || d.pairing)
        .sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
    // Nameless devices are mostly BLE beacons; hide them.
    readonly property var available: all.filter(d => !d.paired && !d.pairing && d.deviceName !== "")
        .sort((a, b) => a.name.localeCompare(b.name))

    onOpened: if (enabled) adapter.discovering = true
    onShownChanged: if (!shown && adapter?.discovering) adapter.discovering = false

    // Discovery can only start once the adapter is powered.
    Connections {
        target: root.adapter
        function onEnabledChanged() {
            if (root.shown && root.enabled) root.adapter.discovering = true
        }
    }

    // Devices we started pairing; trusted and connected once paired. Kept
    // here since rows are recreated whenever the device lists change.
    property var pending: []

    function pairAndConnect(dev) {
        if (!pending.includes(dev)) pending = pending.concat([dev])
        dev.pair()
    }

    Instantiator {
        model: root.pending
        delegate: Connections {
            required property BluetoothDevice modelData
            target: modelData
            function onPairedChanged() {
                if (!modelData.paired) return
                modelData.trusted = true
                modelData.connect()
                root.pending = root.pending.filter(d => d !== modelData)
            }
        }
    }

    component DeviceRow: Rectangle {
        id: row

        required property BluetoothDevice modelData
        readonly property BluetoothDevice dev: modelData
        signal pairRequested()

        readonly property string glyph: {
            const i = dev.icon
            if (i.startsWith("audio-head")) return Theme.icons.headphone
            if (i.startsWith("audio")) return Theme.icons.speaker
            if (i === "input-mouse") return Theme.icons.mouse
            if (i === "input-keyboard") return Theme.icons.keyboard
            if (i === "input-gaming") return Theme.icons.gamepad
            if (i.startsWith("phone")) return Theme.icons.phone
            if (i === "computer") return Theme.icons.laptop
            return Theme.icons.bluetooth
        }

        readonly property string status: {
            if (dev.pairing) return "Pairing…"
            if (dev.state === BluetoothDeviceState.Connecting) return "Connecting…"
            if (dev.state === BluetoothDeviceState.Disconnecting) return "Disconnecting…"
            if (dev.connected) return dev.batteryAvailable
                ? `Connected · ${Math.round(dev.battery * 100)}%` : "Connected"
            if (dev.paired) return dev.trusted ? "Paired · trusted" : "Paired"
            return dev.address
        }

        function activate() {
            if (dev.pairing) return
            if (!dev.paired) pairRequested()
            else if (dev.connected) dev.disconnect()
            else dev.connect()
        }

        Layout.fillWidth: true
        implicitHeight: 50
        radius: 14
        color: dev.connected ? Theme.hoverBg : area.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        NeonBorder { visible: row.dev.connected; radius: row.radius }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: row.activate()
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 8
            spacing: 12

            Text {
                text: row.glyph
                color: row.dev.connected ? Theme.lavender : Theme.text
                font.family: Theme.font
                font.pixelSize: Theme.fontSize + 4
                Layout.preferredWidth: 22
                horizontalAlignment: Text.AlignHCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                PanelText {
                    text: row.dev.name
                    font.weight: row.dev.connected ? Font.Bold : Font.Normal
                    Layout.fillWidth: true
                }
                PanelText { dim: true; text: row.status; Layout.fillWidth: true }
            }

            Chip {
                visible: row.dev.paired
                icon: row.dev.trusted ? Theme.icons.star : Theme.icons.starOutline
                active: row.dev.trusted
                onClicked: row.dev.trusted = !row.dev.trusted
            }
            Chip {
                visible: row.dev.paired
                icon: Theme.icons.trash
                onClicked: row.dev.forget()
            }
            Chip {
                visible: row.dev.pairing
                icon: Theme.icons.close
                onClicked: row.dev.cancelPair()
            }
        }
    }

    // Header: title, adapter name, power switch.
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Label {
            text: root.enabled ? Theme.icons.bluetooth : Theme.icons.btOff
            font.pixelSize: Theme.fontSize + 6
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            RowLayout {
                spacing: 8

                PanelText { text: "Bluetooth"; font.weight: Font.Black }
                ScanSpinner {
                    visible: root.enabled
                    scanning: root.adapter?.discovering ?? false
                    onClicked: root.adapter.discovering = !root.adapter.discovering
                }
            }
            PanelText { dim: true; text: BluetoothState.labelOf(root.adapter); Layout.fillWidth: true }
        }
        Toggle {
            checked: root.enabled
            onToggled: root.adapter.enabled = !root.enabled
        }
    }

    // Adapter picker; choosing one powers the others off.
    Flow {
        visible: BluetoothState.adapters.length > 1
        Layout.fillWidth: true
        spacing: 8

        Repeater {
            model: BluetoothState.adapters

            Chip {
                required property BluetoothAdapter modelData
                icon: Theme.icons.adapter
                label: BluetoothState.labelOf(modelData)
                active: modelData === root.adapter
                onClicked: BluetoothState.select(modelData)
            }
        }
    }

    RowLayout {
        visible: root.enabled
        Layout.fillWidth: true
        spacing: 8

        Chip {
            icon: root.adapter?.discoverable ? Theme.icons.eye : Theme.icons.eyeOff
            label: "Visible"
            active: root.adapter?.discoverable ?? false
            onClicked: root.adapter.discoverable = !root.adapter.discoverable
        }
        Item { Layout.fillWidth: true }
    }

    // Pairing prompt from the agent.
    Rectangle {
        visible: BluetoothAgent.kind !== ""
        Layout.fillWidth: true
        implicitHeight: prompt.implicitHeight + 24
        radius: 14
        color: Theme.hoverBg

        NeonBorder { radius: 14 }

        ColumnLayout {
            id: prompt
            anchors.centerIn: parent
            width: parent.width - 24
            spacing: 8

            PanelText { text: BluetoothAgent.message; wrapMode: Text.Wrap; Layout.fillWidth: true }
            Label {
                visible: BluetoothAgent.code !== ""
                text: BluetoothAgent.code
                font.pixelSize: Theme.fontSize + 10
                font.letterSpacing: 4
                Layout.alignment: Qt.AlignHCenter
            }
            PanelInput {
                id: input
                visible: BluetoothAgent.kind === "pin" || BluetoothAgent.kind === "passkey"
                Layout.fillWidth: true
                validator: RegularExpressionValidator {
                    regularExpression: BluetoothAgent.kind === "passkey" ? /\d{0,6}/ : /\S{0,16}/
                }
                onAccepted: submit.clicked()
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 8

                Chip {
                    label: BluetoothAgent.kind === "display" ? "Dismiss" : "Reject"
                    icon: Theme.icons.close
                    onClicked: {
                        if (BluetoothAgent.kind === "display") BluetoothAgent.clear()
                        else BluetoothAgent.reply("no")
                        input.text = ""
                    }
                }
                Chip {
                    id: submit
                    visible: BluetoothAgent.kind !== "display"
                    label: BluetoothAgent.kind === "confirm" ? "Accept" : "Submit"
                    icon: Theme.icons.check
                    active: true
                    onClicked: {
                        BluetoothAgent.reply(BluetoothAgent.kind === "confirm" ? "yes" : input.text)
                        input.text = ""
                    }
                }
            }
        }
    }

    Flickable {
        visible: root.enabled
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(lists.implicitHeight, 420)
        contentHeight: lists.implicitHeight
        interactive: contentHeight > height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: lists
            width: parent.width
            spacing: 4

            PanelText { heading: true; visible: root.paired.length > 0; text: "MY DEVICES" }
            Repeater {
                model: root.paired
                DeviceRow {}
            }

            PanelText { heading: true; text: "AVAILABLE" }
            Repeater {
                model: root.available
                DeviceRow { onPairRequested: root.pairAndConnect(modelData) }
            }
            PanelText {
                dim: true
                visible: root.available.length === 0
                text: root.adapter?.discovering ? "Searching for devices…" : "No devices found."
                Layout.leftMargin: 4
                Layout.bottomMargin: 4
            }
        }
    }

    PanelText {
        dim: true
        visible: !root.enabled
        text: "Bluetooth is off"
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 8
        Layout.bottomMargin: 8
    }
}
