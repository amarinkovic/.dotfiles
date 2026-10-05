pragma Singleton

import QtQuick
import Quickshell

// Palette and glyphs ported from the old waybar style.css / config.jsonc.
Singleton {
    readonly property color magenta: "#bd5eff"
    readonly property color red: "#ff6e5e"
    readonly property color lavender: "#d08fff"
    readonly property color brightRed: "#ff9a8f"

    readonly property color surface: Qt.rgba(0, 0, 0, 0.6)
    readonly property color text: "#ffe8e5"
    readonly property color activeBg: magenta
    readonly property color activeFg: "#000000"
    readonly property color shadow: Qt.rgba(0.816, 0.561, 1, 0.45)
    readonly property color tooltipBg: Qt.rgba(0, 0, 0, 0.8)
    readonly property color panelBg: Qt.rgba(0.05, 0.03, 0.07, 0.94)
    readonly property color hoverBg: Qt.rgba(0.741, 0.369, 1, 0.25)

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 14
    readonly property int barHeight: 34
    readonly property int pillHeight: 28
    readonly property int spacing: 10

    function g(cp) { return String.fromCodePoint(cp) }

    readonly property var icons: ({
        arch: g(0xF08C7),
        power: g(0xF0425),
        wsUrgent: g(0xF06A),
        wsActive: g(0xF192),
        wsDefault: g(0xF10C),
        idleOn: g(0xF06E),
        idleOff: g(0xF070),
        dndOn: g(0xF009B),
        dndOff: g(0xF009A),
        wifi: [g(0xF092F), g(0xF091F), g(0xF0922), g(0xF0925), g(0xF0928)],
        ethernet: g(0xF0200),
        bluetooth: g(0xF294),
        btOff: g(0xF00B2),
        btConnected: g(0xF00B1),
        adapter: g(0xF0553),
        wifiOff: g(0xF05AA),
        lock: g(0xF033E),
        speaker: g(0xF04C3),
        mouse: g(0xF037D),
        keyboard: g(0xF030C),
        gamepad: g(0xF0297),
        phone: g(0xF011C),
        laptop: g(0xF0322),
        refresh: g(0xF0450),
        eye: g(0xF0208),
        eyeOff: g(0xF0209),
        star: g(0xF04CE),
        starOutline: g(0xF04D2),
        trash: g(0xF0A7A),
        close: g(0xF0156),
        check: g(0xF012C),
        muted: g(0xF6A9),
        headphone: g(0xF025),
        volume: [g(0xF026), g(0xF027), g(0xF028)],
        cpu: g(0xF2DB),
        memory: g(0xE266),
        disk: g(0xF02CA),
        temp: [g(0xF2CB), g(0xF2C9), g(0xF2C7)],
        battery: [g(0xF244), g(0xF243), g(0xF242), g(0xF241), g(0xF240)],
        charging: g(0xF140B),
        playing: g(0xF1BC),
        paused: g(0xF28B),
        mic: g(0xF036C),
        screen: g(0xF0379)
    })
}
