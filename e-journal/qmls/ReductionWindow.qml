import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: _ReductionWindow
    width: 500
    height: 500
    title: qsTr("Reduction of password")
    property string bg_color: "#242246"

    signal signalClose

    header: Hat {
        title: qsTr("Reduction of password")
        hatColor: bg_color

        function quit() {
            signalClose();
            _ReductionWindow.close();
        }
    }

    color: bg_color;

    onVisibilityChanged: {
        if (!visibility) {
            signalClose();
        }
    }
}
