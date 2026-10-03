import QtQuick
import qs

// Magenta -> red, left to right. Instantiate per use; a shared Gradient doesn't render.
Gradient {
    orientation: Gradient.Horizontal
    GradientStop { position: 0; color: Theme.magenta }
    GradientStop { position: 1; color: Theme.red }
}
