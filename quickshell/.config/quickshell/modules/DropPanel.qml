import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Popup that drops down from a bar pill with a grow/fade animation and
// closes on an outside click. Content goes in a padded column.
PopupWindow {
    id: root

    default property alias content: column.data
    property bool shown: false
    property real lastClosed: 0

    signal opened()

    function open() {
        visible = true
        shown = true
        opened()
    }

    function close() { shown = false }

    // An outside click dismisses the popup before the pill sees it; don't
    // let that same click reopen it.
    function toggle() {
        if (shown) close()
        else if (Date.now() - lastClosed > 300) open()
    }

    onShownChanged: if (!shown) lastClosed = Date.now()
    onVisibleChanged: if (!visible) shown = false

    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 8
    grabFocus: true
    color: "transparent"
    implicitWidth: 360
    implicitHeight: column.implicitHeight + 32

    Rectangle {
        id: frame

        width: parent.width
        height: root.shown ? parent.height : 0
        opacity: root.shown ? 1 : 0
        clip: true
        radius: 18
        color: Theme.panelBg

        Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 180 } }
        onHeightChanged: if (!root.shown && height === 0) root.visible = false

        NeonBorder { radius: frame.radius }

        ColumnLayout {
            id: column

            x: 16
            y: 16
            width: frame.width - 32
            spacing: 8
        }
    }
}
