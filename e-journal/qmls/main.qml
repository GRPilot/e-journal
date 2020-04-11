import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: _AuthWindow
    visible: true
    width: 500
    height: 500
    minimumWidth: 400
    minimumHeight: 500
    flags: Qt.FramelessWindowHint

    title: qsTr("e-journal | Authorization")

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    header: Hat {
        title: qsTr("e-journal | Authorization")
    }

    Authorization {
        visible: true
        anchors.fill: parent

        onSignalExit: {
            _AuthWindow.close();
            _MainWindow.show();
        }

        onForgorButtonPressed: {
            _AuthWindow.hide();
            _ReductionWindow.show();
        }
    }

    MainWindow {
        id: _MainWindow

        onSignalLogout: {
            _AuthWindow.show();
        }
    }

    ReductionWindow {
        id: _ReductionWindow

        onSignalClose: {
            _AuthWindow.show();
        }
    }
}
