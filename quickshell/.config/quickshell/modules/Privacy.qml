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

    // Breathe while anything is capturing.
    SequentialAnimation on opacity {
        running: root.visible
        loops: Animation.Infinite
        onRunningChanged: if (!running) root.opacity = 1
        NumberAnimation { to: 0.4; duration: 900; easing.type: Easing.InOutSine }
        NumberAnimation { to: 1; duration: 900; easing.type: Easing.InOutSine }
    }

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
