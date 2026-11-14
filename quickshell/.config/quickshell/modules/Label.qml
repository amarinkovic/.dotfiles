import QtQuick
import QtQuick.Effects
import qs

// Bold text with waybar's red text-shadow glow.
Text {
    id: root

    property bool glow: true
    property color glowColor: Theme.red

    color: Theme.text
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    font.weight: Font.Black
    verticalAlignment: Text.AlignVCenter

    layer.enabled: glow
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: root.glowColor
        shadowBlur: 0.5
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
}
