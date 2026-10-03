import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import qs

Pill {
    id: root

    // Tray item ids to hide (see `busctl --user` on StatusNotifierWatcher).
    // Spotify is covered by the Media module.
    property list<string> hidden: ["spotify-client"]

    readonly property var items: SystemTray.items.values.filter(i => !hidden.includes(i.id))

    // Window belonging to a tray item, matched on app id vs. the item's id/title
    // (e.g. "discord_status_icon_1" -> appId "discord").
    function windowFor(item) {
        const keys = [item.id, item.title].map(k => (k ?? "").toLowerCase()).filter(k => k)
        return ToplevelManager.toplevels.values.find(t => {
            const app = (t.appId ?? "").toLowerCase()
            return app && keys.some(k => k === app || k.startsWith(app + "_") || k.startsWith(app + "-"))
        }) ?? null
    }

    visible: items.length > 0
    background: false
    padding: 0
    spacing: 10

    Repeater {
        model: root.items

        IconImage {
            id: icon

            required property SystemTrayItem modelData

            implicitSize: 20
            source: modelData.icon

            QsMenuAnchor {
                id: menu
                menu: icon.modelData.menu
                anchor.item: icon
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.top: 8
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    const item = icon.modelData
                    if (mouse.button === Qt.MiddleButton) item.secondaryActivate()
                    else if (mouse.button === Qt.RightButton || item.onlyMenu) {
                        if (item.hasMenu) menu.open()
                    } else {
                        // Most apps' Activate only un-hides the window, which looks like a
                        // no-op when it's open on another workspace, so focus it ourselves.
                        const win = root.windowFor(item)
                        if (win) win.activate()
                        else item.activate()
                    }
                }
                onWheel: wheel => icon.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
