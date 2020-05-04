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

    GlobalSettingWindow {
        id: _GlobalSettingWindow
        title: qsTr("e-journal | Global Settings")

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

        onSignupButtomPressed: {
            _SignInWin.hide();
            _SignUpWin.show();
        }

        onSettingShow: {
            _GlobalSettingWindow.show();
        }
    }

    ReductionWindow {
        id: _ReductionWindow
        title: "e-journal | Rediction login or password"
        onClosing: {
            _SignInWin.show();
        }
    }

    SignupWindow {
        id: _SignUpWin
        title: "e-journal | Sign up"
        onClosing: {
            _SignInWin.show();
        }
    }

    MainWindow {
        id: _MainWindow

        onSignalLogout: {
            _SignInWin.show();
        }
    }
}
