import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    width: 500
    height: 500
    title: qsTr("Reduction of password")

    signal signalClose

    onVisibilityChanged: {
        if (!visibility) {
            signalClose();
        }
    }
}
