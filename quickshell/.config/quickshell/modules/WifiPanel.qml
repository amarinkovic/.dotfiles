import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import qs

// Network panel that drops down from the bar's network pill: Wi-Fi radio,
// interface choice, scanning, saved/available networks with password
// entry, and wired links.
DropPanel {
    id: root

    readonly property var wifiDevices: Networking.devices.values.filter(d => d.type === DeviceType.Wifi)
    readonly property var wiredDevices: Networking.devices.values.filter(d => d.type === DeviceType.Wired)
    property string chosen  // interface name picked in the panel
    readonly property var device: wifiDevices.find(d => d.name === chosen) ?? wifiDevices[0] ?? null
    readonly property bool enabled: Networking.wifiEnabled && Networking.wifiHardwareEnabled

    // Hidden SSIDs have no name; connected first, then strongest.
    readonly property var all: (device?.networks.values ?? []).filter(n => n.name !== "")
        .sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength))
    readonly property var saved: all.filter(n => n.known)
    readonly property var available: all.filter(n => !n.known)

    // Password prompt state. Lives here since rows are recreated whenever
    // the lists re-sort (signal strength changes constantly).
    property WifiNetwork asking
    property WifiNetwork trying
    property string error

    function activate(net) {
        error = ""
        if (net.connected) return net.disconnect()
        trying = net
        if (net.known || !secured(net)) net.connect()
        else if (enterprise(net)) error = `${net.name} needs enterprise login; set it up with nmtui`
        else asking = net
    }

    function submit(psk) {
        const net = asking
        asking = null
        trying = net
        net.connectWithPsk(psk)
    }

    function secured(net) {
        return net.security !== WifiSecurityType.Open && net.security !== WifiSecurityType.Owe
    }

    function enterprise(net) {
        return [WifiSecurityType.Wpa3SuiteB192, WifiSecurityType.Wpa2Eap, WifiSecurityType.WpaEap,
                WifiSecurityType.DynamicWep, WifiSecurityType.Leap].includes(net.security)
    }

    function securityLabel(net) {
        switch (net.security) {
        case WifiSecurityType.Open: return "Open"
        case WifiSecurityType.Owe: return "Enhanced open"
        case WifiSecurityType.Sae: return "WPA3"
        case WifiSecurityType.Wpa2Psk: return "WPA2"
        case WifiSecurityType.WpaPsk: return "WPA"
        case WifiSecurityType.StaticWep: return "WEP"
        default: return enterprise(net) ? "Enterprise" : "Secured"
        }
    }

    onOpened: if (device) device.scannerEnabled = true
    onShownChanged: if (!shown) {
        if (device) device.scannerEnabled = false
        asking = null
        error = ""
    }

    Connections {
        target: root.trying
        function onConnectionFailed(reason) {
            const net = root.trying
            // A wrong key usually surfaces as a client failure or timeout
            // rather than NoSecrets, so offer the password again for those.
            const authish = [ConnectionFailReason.NoSecrets, ConnectionFailReason.WifiClientFailed,
                             ConnectionFailReason.WifiAuthTimeout].includes(reason)
            if (authish && root.secured(net) && !root.enterprise(net)) {
                root.error = `Couldn't connect to ${net.name}; the password may be wrong`
                root.asking = net
            } else {
                root.error = `Couldn't connect to ${net.name}`
            }
        }
        function onConnectedChanged() {
            if (root.trying?.connected) root.trying = null
        }
    }

    component NetworkRow: Rectangle {
        id: row

        required property WifiNetwork modelData
        readonly property WifiNetwork net: modelData
        readonly property bool secured: net.security !== WifiSecurityType.Open && net.security !== WifiSecurityType.Owe
        property string securityLabel
        signal activated()
        signal forgetRequested()

        readonly property string status: {
            if (net.state === ConnectionState.Connecting) return "Connecting…"
            if (net.state === ConnectionState.Disconnecting) return "Disconnecting…"
            const pct = `${Math.round(net.signalStrength * 100)}%`
            if (net.connected) return `Connected · ${pct}`
            return `${net.known ? "Saved" : securityLabel} · ${pct}`
        }

        Layout.fillWidth: true
        implicitHeight: 50
        radius: 14
        color: net.connected ? Theme.hoverBg : area.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        NeonBorder { visible: row.net.connected; radius: row.radius }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: row.activated()
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 8
            spacing: 12

            Text {
                text: Theme.icons.wifi[Math.min(4, Math.floor(row.net.signalStrength * 5))]
                color: row.net.connected ? Theme.lavender : Theme.text
                font.family: Theme.font
                font.pixelSize: Theme.fontSize + 4
                Layout.preferredWidth: 22
                horizontalAlignment: Text.AlignHCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                PanelText {
                    text: row.net.name
                    font.weight: row.net.connected ? Font.Bold : Font.Normal
                    Layout.fillWidth: true
                }
                PanelText { dim: true; text: row.status; Layout.fillWidth: true }
            }

            PanelText {
                visible: row.secured
                text: Theme.icons.lock
                dim: true
            }
            Chip {
                visible: row.net.known
                icon: Theme.icons.trash
                onClicked: row.forgetRequested()
            }
        }
    }

    // Header: title, interface, radio switch.
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Label {
            text: root.enabled ? Theme.icons.wifi[4] : Theme.icons.wifiOff
            font.pixelSize: Theme.fontSize + 6
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            RowLayout {
                spacing: 8

                PanelText { text: "Wi-Fi"; font.weight: Font.Black }

                ScanSpinner {
                    visible: root.enabled && root.device !== null
                    scanning: root.device?.scannerEnabled ?? false
                    onClicked: root.device.scannerEnabled = !root.device.scannerEnabled
                }
            }
            PanelText {
                dim: true
                text: !Networking.wifiHardwareEnabled ? "Blocked by hardware switch"
                    : root.device ? root.device.name : "No Wi-Fi device"
                Layout.fillWidth: true
            }
        }
        Toggle {
            visible: Networking.wifiHardwareEnabled && root.device !== null
            checked: root.enabled
            onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
        }
    }

    // Interface picker, only with more than one Wi-Fi card.
    Flow {
        visible: root.wifiDevices.length > 1
        Layout.fillWidth: true
        spacing: 8

        Repeater {
            model: root.wifiDevices

            Chip {
                required property NetworkDevice modelData
                icon: Theme.icons.adapter
                label: modelData.name
                active: modelData === root.device
                onClicked: {
                    if (root.device) root.device.scannerEnabled = false
                    root.chosen = modelData.name
                    modelData.scannerEnabled = true
                }
            }
        }
    }

    // Password prompt / connection errors.
    Rectangle {
        visible: root.asking !== null || root.error !== ""
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

            PanelText {
                visible: root.error !== ""
                text: root.error
                color: Theme.brightRed
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            PanelText {
                visible: root.asking !== null
                text: `Password for ${root.asking?.name ?? ""}`
                Layout.fillWidth: true
            }
            PanelInput {
                id: psk
                visible: root.asking !== null
                Layout.fillWidth: true
                password: true
                placeholder: "Password"
                onVisibleChanged: if (visible) focusInput()
                onAccepted: connectChip.clicked()
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 8

                Chip {
                    label: root.asking ? "Cancel" : "Dismiss"
                    icon: Theme.icons.close
                    onClicked: {
                        root.asking = null
                        root.error = ""
                        psk.text = ""
                    }
                }
                Chip {
                    id: connectChip
                    visible: root.asking !== null
                    label: "Connect"
                    icon: Theme.icons.check
                    active: true
                    onClicked: {
                        if (psk.text.length < 8) {
                            root.error = "Passwords are at least 8 characters"
                            return
                        }
                        root.error = ""
                        root.submit(psk.text)
                        psk.text = ""
                    }
                }
            }
        }
    }

    Flickable {
        visible: root.enabled && root.device !== null
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

            PanelText { heading: true; visible: root.saved.length > 0; text: "SAVED" }
            Repeater {
                model: root.saved
                NetworkRow {
                    securityLabel: root.securityLabel(modelData)
                    onActivated: root.activate(modelData)
                    onForgetRequested: modelData.forget()
                }
            }

            PanelText { heading: true; text: "AVAILABLE" }
            Repeater {
                model: root.available
                NetworkRow {
                    securityLabel: root.securityLabel(modelData)
                    onActivated: root.activate(modelData)
                }
            }
            PanelText {
                dim: true
                visible: root.available.length === 0
                text: root.device?.scannerEnabled ? "Searching for networks…" : "No networks found."
                Layout.leftMargin: 4
                Layout.bottomMargin: 4
            }
        }
    }

    PanelText {
        dim: true
        visible: !root.enabled && root.device !== null
        text: "Wi-Fi is off"
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 8
        Layout.bottomMargin: 8
    }

    // Wired links: click to connect/disconnect.
    PanelText { heading: true; visible: root.wiredDevices.length > 0; text: "WIRED" }
    Repeater {
        model: root.wiredDevices

        Rectangle {
            id: wired

            required property WiredDevice modelData
            readonly property WiredDevice dev: modelData

            Layout.fillWidth: true
            implicitHeight: 50
            radius: 14
            color: dev.connected ? Theme.hoverBg : wiredArea.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }

            NeonBorder { visible: wired.dev.connected; radius: wired.radius }

            MouseArea {
                id: wiredArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: wired.dev.hasLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (wired.dev.connected) wired.dev.disconnect()
                    else if (wired.dev.hasLink) wired.dev.network?.connect()
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 8
                spacing: 12

                Text {
                    text: Theme.icons.ethernet
                    color: wired.dev.connected ? Theme.lavender : Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize + 4
                    Layout.preferredWidth: 22
                    horizontalAlignment: Text.AlignHCenter
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    PanelText {
                        text: wired.dev.name
                        font.weight: wired.dev.connected ? Font.Bold : Font.Normal
                        Layout.fillWidth: true
                    }
                    PanelText {
                        dim: true
                        text: !wired.dev.hasLink ? "Cable unplugged"
                            : wired.dev.connected ? `Connected · ${wired.dev.linkSpeed} Mb/s`
                            : "Disconnected"
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
