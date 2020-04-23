import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Loader {
    id: _root

    readonly property string commonBackColor: "#242246"
    focus: false;

    source: "/SignInWindow.qml"

    Component.onCompleted: {
        _root.item.onWinLoaded();
    }

    SignInWindow {
        id: _SignInWin
        width: 500
        height: 500

        title: qsTr("e-journal | Authorization")

        onSignalExit: {
            _SignInWin.close();
            _MainWindow.show();
        }

        onForgorButtonPressed: {
            _SignInWin.hide();
            _ReductionWindow.show();
        }
    }

    MainWindow {
        id: _MainWindow
        flags: Qt.FramelessWindowHint

        onSignalLogout: {
            _SignInWin.show();
        }
    }

    ReductionWindow {
        id: _ReductionWindow

        onClosing: {
            _SignInWin.show();
        }
    }
}
/*
FramelessWindow {
    id: _AuthWindow
    visible: true
    width: 500
    height: 500
    minimumWidth: 400
    minimumHeight: 500

    title: qsTr("e-journal | Authorization")

    readonly property string commonBackColor: "#242246"

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    Authorization {
        visible: true
        anchors.fill: parent

        backColor: commonBackColor

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
        bg_color: commonBackColor
        flags: Qt.FramelessWindowHint

        onSignalLogout: {
            _AuthWindow.show();
        }
    }

    ReductionWindow {
        id: _ReductionWindow
        backColor: commonBackColor

        onClosing: {
            _AuthWindow.show();
        }
    }
}

*/
