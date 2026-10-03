import QtQuick
import qs

// Thin magenta -> red gradient ring following the parent's rounded shape.
Canvas {
    id: root

    property real radius: height / 2
    property real borderWidth: 1

    anchors.fill: parent
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onRadiusChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        const grad = ctx.createLinearGradient(0, 0, width, 0)
        grad.addColorStop(0, Theme.magenta)
        grad.addColorStop(1, Theme.red)
        ctx.strokeStyle = grad
        ctx.lineWidth = borderWidth
        const o = borderWidth / 2
        ctx.roundedRect(o, o, width - borderWidth, height - borderWidth, radius - o, radius - o)
        ctx.stroke()
    }
}
