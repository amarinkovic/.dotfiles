//@ pragma UseQApplication
import QtQuick
import Quickshell
import qs.modules

ShellRoot {
    PowerMenu {}

    Variants {
        model: Quickshell.screens

        Bar {
            required property ShellScreen modelData
            screen: modelData
        }
    }
}
