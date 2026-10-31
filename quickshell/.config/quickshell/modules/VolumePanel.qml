import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs

// Sound panel that drops down from the bar's volume pill: mute switch,
// output and mic volume, output/input device pickers and a link to the mixer.
DropPanel {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real micVolume: source?.audio?.volume ?? 0
    readonly property bool micMuted: source?.audio?.muted ?? false
    readonly property var devices: Pipewire.nodes.values.filter(n => n.audio && !n.isStream)
    readonly property var sinks: devices.filter(n => n.isSink)
    readonly property var sources: devices.filter(n => !n.isSink)

    function nameOf(n) { return n?.description || n?.nickname || n?.name || "" }

    onShownChanged: if (!shown) {
        outputs.expanded = false
        inputs.expanded = false
    }

    PwObjectTracker { objects: [root.sink, root.source] }

    // Header: title, current output, sound on/off switch.
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Label {
            text: root.muted ? Theme.icons.muted : Theme.icons.volume[2]
            font.pixelSize: Theme.fontSize + 6
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            PanelText { text: "Sound"; font.weight: Font.Black }
            PanelText {
                dim: true
                text: root.sink ? (root.muted ? "Muted" : root.nameOf(root.sink)) : "No output device"
                Layout.fillWidth: true
            }
        }
        Toggle {
            visible: root.sink?.audio ?? false
            checked: !root.muted
            onToggled: root.sink.audio.muted = !root.muted
        }
    }

    RowLayout {
        visible: root.sink?.audio ?? false
        Layout.fillWidth: true
        Layout.topMargin: 4
        spacing: 12

        PanelSlider {
            Layout.fillWidth: true
            value: root.volume
            dim: root.muted
            onMoved: value => root.sink.audio.volume = value
        }
        PanelText {
            text: `${Math.round(root.volume * 100)}%`
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: 40
        }
    }

    PanelText { heading: true; text: "OUTPUT" }
    PanelSelect {
        id: outputs
        icon: Theme.icons.speaker
        options: root.sinks
        current: root.sink
        labelOf: root.nameOf
        onSelected: option => Pipewire.preferredDefaultAudioSink = option
        onExpandedChanged: if (expanded) inputs.expanded = false
    }

    PanelText { heading: true; text: "INPUT" }
    PanelSelect {
        id: inputs
        icon: Theme.icons.mic
        options: root.sources
        current: root.source
        labelOf: root.nameOf
        onSelected: option => Pipewire.preferredDefaultAudioSource = option
        onExpandedChanged: if (expanded) outputs.expanded = false
    }

    RowLayout {
        visible: root.source?.audio ?? false
        Layout.fillWidth: true
        Layout.topMargin: 4
        spacing: 12

        PanelSlider {
            Layout.fillWidth: true
            value: root.micVolume
            dim: root.micMuted
            onMoved: value => root.source.audio.volume = value
        }
        PanelText {
            text: `${Math.round(root.micVolume * 100)}%`
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: 40
        }
    }

    PanelText {
        text: `${Theme.icons.openExternal}  Open volume mixer`
        color: Theme.lavender
        opacity: linkArea.containsMouse ? 1 : 0.8
        font.underline: linkArea.containsMouse
        Layout.alignment: Qt.AlignRight
        Layout.topMargin: 6

        MouseArea {
            id: linkArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Quickshell.execDetached(["pavucontrol"])
                root.close()
            }
        }
    }
}
