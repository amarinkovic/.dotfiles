import QtQuick
import Quickshell.Services.Pipewire
import qs

// Shows an icon only while the mic or a screen-share is in use.
Pill {
    id: root

    readonly property var streams: Pipewire.nodes.values.filter(n => n.isStream)
    readonly property bool micInUse: streams.some(n => (n.type & PwNodeType.AudioInStream) === PwNodeType.AudioInStream)
    readonly property bool screenInUse: streams.some(n => (n.type & PwNodeType.Video) !== 0)

    visible: micInUse || screenInUse
    background: false
    padding: 0

    Label {
        visible: root.screenInUse
        text: Theme.icons.screen
        color: Theme.red
    }
    Label {
        visible: root.micInUse
        text: Theme.icons.mic
        color: Theme.red
    }
}
