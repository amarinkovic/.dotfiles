import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs

// Spotify now-playing; hidden when Spotify isn't running.
Pill {
    id: root

    readonly property MprisPlayer player: Mpris.players.values.find(
        p => p.identity.toLowerCase().includes("spotify")) ?? null

    visible: player !== null && player.trackTitle !== ""
    background: false
    clickable: true
    onClicked: player.togglePlaying()

    Label {
        readonly property string track: root.player
            ? `${root.player.trackArtist} - ${root.player.trackTitle}` : ""

        text: root.player
            ? `${root.player.isPlaying ? Theme.icons.playing : Theme.icons.paused}  ${track}`
            : ""
        elide: Text.ElideRight
        Layout.maximumWidth: 420
    }
}
