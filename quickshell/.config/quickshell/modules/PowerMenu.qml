import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs

// Full-screen power menu, replacing wlogout (whose look it ports: square cards
// framed by corner brackets, letter-spaced caps with a magenta ghost).
//
// The reason it exists: wlogout styled GTK's :hover and :focus independently,
// so the mouse and the arrow keys could each highlight a different card. Here
// there is a single `selected` index that both inputs write to, so exactly one
// card is ever lit — whichever input moved last.
//
// Toggled over IPC: `qs ipc call powermenu toggle`.
Scope {
    id: root

    property bool shown: false
    property var pending: null

    readonly property var actions: [
        { label: "LOCK",      icon: 0xF033E, key: Qt.Key_L, cmd: ["hyprlock"] },
        { label: "LOGOUT",    icon: 0xF0343, key: Qt.Key_E, cmd: ["hyprctl", "dispatch", "hl.dsp.exit()"] },
        { label: "SUSPEND",   icon: 0xF0904, key: Qt.Key_U, cmd: ["systemctl", "suspend"] },
        { label: "HIBERNATE", icon: 0xF0717, key: Qt.Key_H, cmd: ["systemctl", "hibernate"] },
        { label: "REBOOT",    icon: 0xF0709, key: Qt.Key_R, cmd: ["systemctl", "reboot"],   warn: true },
        { label: "SHUTDOWN",  icon: 0xF0425, key: Qt.Key_S, cmd: ["systemctl", "poweroff"], warn: true }
    ]
    readonly property int columns: 3

    // Close first and run a beat later, so the menu is gone before the action
    // starts — hyprlock screenshots the desktop for its background.
    function run(i) {
        pending = actions[i].cmd
        shown = false
        launch.restart()
    }

    Timer {
        id: launch
        interval: 150
        onTriggered: Quickshell.execDetached(root.pending)
    }

    // A soft glow along all four edges of its parent: one blurred hairline
    // per edge, so the middle stays empty and a translucent fill on top
    // doesn't pick up a wash of color.
    component EdgeGlow: Item {
        id: glow

        property color color
        property real blur

        Repeater {
            model: 4

            RectangularShadow {
                required property int index
                readonly property bool horizontal: index < 2

                x: horizontal ? 0 : (index === 2 ? 0 : glow.width - 2)
                y: horizontal ? (index === 0 ? 0 : glow.height - 2) : 0
                width: horizontal ? glow.width : 2
                height: horizontal ? 2 : glow.height
                color: glow.color
                blur: glow.blur
                spread: 2
            }
        }
    }

    IpcHandler {
        target: "powermenu"

        function toggle(): void { root.shown = !root.shown }
        function open(): void { root.shown = true }
        function close(): void { root.shown = false }
    }

    LazyLoader {
        active: root.shown

        PanelWindow {
            id: win

            property int selected: 0

            function move(dx, dy) {
                const n = root.actions.length
                const rows = Math.ceil(n / root.columns)
                const col = (selected % root.columns + dx + root.columns) % root.columns
                const row = (Math.floor(selected / root.columns) + dy + rows) % rows
                selected = Math.min(row * root.columns + col, n - 1)
            }

            screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
                ?? Quickshell.screens[0]
            anchors { top: true; bottom: true; left: true; right: true }
            exclusionMode: ExclusionMode.Ignore
            // Same namespace wlogout used, so the `blur-powermenu` layer rule
            // in hyprland.lua keeps blurring what's behind.
            WlrLayershell.namespace: "logout_dialog"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: Qt.rgba(0.039, 0.016, 0.063, 0.55)

            // A click on the backdrop dismisses, like wlogout.
            MouseArea {
                anchors.fill: parent
                onClicked: root.shown = false
            }

            Item {
                anchors.fill: parent
                focus: true

                Keys.onPressed: event => {
                    switch (event.key) {
                    case Qt.Key_Escape: root.shown = false; break
                    case Qt.Key_Left:  win.move(-1, 0); break
                    case Qt.Key_Right: win.move(1, 0); break
                    case Qt.Key_Up:    win.move(0, -1); break
                    case Qt.Key_Down:  win.move(0, 1); break
                    case Qt.Key_Tab:   win.selected = (win.selected + 1) % root.actions.length; break
                    case Qt.Key_Backtab:
                        win.selected = (win.selected + root.actions.length - 1) % root.actions.length
                        break
                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                    case Qt.Key_Space: root.run(win.selected); break
                    default: {
                        const i = root.actions.findIndex(a => a.key === event.key)
                        if (i < 0) return
                        root.run(i)
                    }
                    }
                    event.accepted = true
                }
            }

            Grid {
                anchors.centerIn: parent
                columns: root.columns
                columnSpacing: 32
                rowSpacing: 260

                Repeater {
                    model: root.actions

                    Item {
                        id: card

                        required property var modelData
                        required property int index

                        readonly property bool active: win.selected === index
                        readonly property color hot: modelData.warn ? Theme.red : Theme.magenta
                        readonly property color arm: active ? hot : Qt.alpha(Theme.lavender, 0.8)
                        readonly property int armLen: active ? 44 : 26

                        width: 667
                        height: 229

                        // Outer bloom, selected card only: soft light spilling
                        // out from the edges.
                        EdgeGlow {
                            anchors.fill: parent
                            color: Qt.alpha(card.hot, 0.75)
                            blur: 32
                            opacity: card.active ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 160 } }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: card.active ? Qt.alpha(card.hot, 0.16) : Qt.rgba(0, 0, 0, 0.55)
                            Behavior on color { ColorAnimation { duration: 160 } }
                        }

                        // Inner glow, the inset box-shadow from wlogout: the same
                        // edge glow clipped to the card so only the inward half
                        // shows. Lavender at rest, the hot color when selected.
                        Item {
                            anchors.fill: parent
                            clip: true

                            EdgeGlow {
                                anchors.fill: parent
                                color: card.active ? Qt.alpha(card.hot, 0.7) : Qt.alpha(Theme.lavender, 0.4)
                                blur: card.active ? 36 : 26
                                Behavior on color { ColorAnimation { duration: 160 } }
                            }
                        }

                        // Corner brackets: an H and a V arm per corner, laid
                        // flush inside the edge. Length snaps on select, like
                        // a reticle acquiring a target.
                        Repeater {
                            model: 4

                            Item {
                                required property int index
                                readonly property bool atRight: index % 2 === 1
                                readonly property bool atBottom: index >= 2

                                anchors.fill: parent

                                Rectangle {
                                    x: parent.atRight ? card.width - width : 0
                                    y: parent.atBottom ? card.height - height : 0
                                    width: card.armLen
                                    height: 2
                                    color: card.arm
                                }
                                Rectangle {
                                    x: parent.atRight ? card.width - width : 0
                                    y: parent.atBottom ? card.height - height : 0
                                    width: 2
                                    height: card.armLen
                                    color: card.arm
                                }
                            }
                        }

                        // Hard 3px chromatic-aberration ghost behind the label.
                        Text {
                            x: label.x + 3
                            y: label.y + 3
                            text: label.text
                            font: label.font
                            color: Qt.alpha(card.hot, card.active ? 0.55 : 0.4)
                        }

                        Text {
                            id: label

                            anchors.centerIn: parent
                            text: Theme.g(card.modelData.icon) + "  " + card.modelData.label
                            font.family: Theme.font
                            font.pixelSize: 34
                            font.weight: Font.Bold
                            font.letterSpacing: 1
                            color: card.active ? "#ffffff" : Theme.text

                            layer.enabled: true
                            layer.effect: MultiEffect {
                                shadowEnabled: true
                                shadowColor: card.active ? Qt.alpha(card.hot, 0.9) : Qt.alpha(Theme.lavender, 0.45)
                                shadowBlur: card.active ? 1 : 0.6
                                blurMax: 48
                                shadowHorizontalOffset: 0
                                shadowVerticalOffset: 0
                            }
                        }

                        // Hover writes the same index the arrow keys do, and
                        // only on actual movement — so a keyboard move isn't
                        // undone by a cursor that is merely resting on a card.
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onPositionChanged: win.selected = card.index
                            onClicked: root.run(card.index)
                        }
                    }
                }
            }
        }
    }
}
