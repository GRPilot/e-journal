import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: _AuthWindow
    visible: true
    width: 500
    height: 500
    minimumWidth: 400
    minimumHeight: 500

    title: qsTr("e-journal | Authorization")

    Authorization {
        visible: true
        anchors.fill: parent

        onSignalExit: {
            _AuthWindow.close();
            _MainWindow.show();
        }
    }

    MainWindow {
        id: _MainWindow


    }
}
