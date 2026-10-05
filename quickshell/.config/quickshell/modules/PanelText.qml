import QtQuick
import QtQuick.Layouts
import qs

// Body text for drop-down panels; `dim` for secondary lines, `heading`
// for section titles.
Text {
    property bool dim
    property bool heading

    color: heading ? Theme.lavender : Theme.text
    opacity: dim ? 0.6 : 1
    font.family: Theme.font
    font.pixelSize: dim || heading ? Theme.fontSize - 3 : Theme.fontSize - 1
    font.weight: heading ? Font.Black : Font.Normal
    font.letterSpacing: heading ? 1 : 0
    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
    Layout.topMargin: heading ? 6 : 0
}
