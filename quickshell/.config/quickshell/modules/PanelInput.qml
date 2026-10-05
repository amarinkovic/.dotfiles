import QtQuick
import qs

// Single-line text field for drop-down panels. With `password`, input is
// masked and an eye button reveals it.
Rectangle {
    id: root

    property alias text: input.text
    property alias validator: input.validator
    property bool password
    property bool revealed
    property string placeholder
    signal accepted()

    function focusInput() { input.forceActiveFocus() }

    implicitHeight: 30
    radius: 10
    color: Qt.rgba(0, 0, 0, 0.4)
    onVisibleChanged: revealed = false

    TextInput {
        id: input
        anchors.left: parent.left
        anchors.right: eye.visible ? eye.left : parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        focus: root.visible
        echoMode: root.password && !root.revealed ? TextInput.Password : TextInput.Normal
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: Theme.fontSize - 1
        verticalAlignment: TextInput.AlignVCenter
        clip: true
        onAccepted: root.accepted()

        PanelText {
            anchors.fill: parent
            visible: !input.text
            text: root.placeholder
            dim: true
        }
    }

    Text {
        id: eye
        visible: root.password
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: root.revealed ? Theme.icons.eye : Theme.icons.eyeOff
        color: Theme.text
        opacity: eyeArea.containsMouse ? 1 : 0.6
        font.family: Theme.font
        font.pixelSize: Theme.fontSize

        MouseArea {
            id: eyeArea
            anchors.fill: parent
            anchors.margins: -6
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.revealed = !root.revealed
        }
    }
}
