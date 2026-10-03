import QtQuick
import Quickshell
import Quickshell.Io
import qs

// HH:mm, click for the date; hover shows a month calendar.
Pill {
    id: root

    property bool alt: false

    clickable: true
    onClicked: alt = !alt
    implicitWidth: Math.max(80, label.implicitWidth + padding * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Label {
        id: label
        text: root.alt ? Qt.formatDate(clock.date, "yyyy-MM-dd") : Qt.formatTime(clock.date, "HH:mm")
    }

    Process {
        id: cal
        command: ["cal"]
        running: root.hovered
        stdout: StdioCollector { onStreamFinished: root.tooltip = text.replace(/\s+$/, "") }
    }
}
