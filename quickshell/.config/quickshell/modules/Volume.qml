import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs

Pill {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property bool bluetooth: (sink?.name ?? "").startsWith("bluez")

    clickable: true
    tooltip: sink?.description ?? ""

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) {
            if (sink?.audio) sink.audio.muted = !sink.audio.muted
        } else {
            Quickshell.execDetached(["pavucontrol"])
        }
    }
    onScrolled: delta => {
        if (!sink?.audio) return
        sink.audio.volume = Math.max(0, Math.min(1.5, volume + (delta > 0 ? 0.05 : -0.05)))
    }

    // Volume/mute are only populated on tracked nodes.
    PwObjectTracker { objects: [root.sink] }

    Label {
        text: {
            const bt = root.bluetooth ? Theme.icons.bluetooth + " " : ""
            if (root.muted) return `${bt}${Theme.icons.muted}`
            const icons = Theme.icons.volume
            const icon = root.bluetooth ? Theme.icons.headphone
                       : icons[Math.min(icons.length - 1, Math.floor(root.volume * icons.length))]
            return `${bt}${icon}  ${Math.round(root.volume * 100)}%`
        }
    }
}
