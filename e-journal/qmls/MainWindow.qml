import QtQuick 2.12
import QtQuick.Window 2.12
//import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    width: 1024;
    height: 720;
    title: qsTr("e-journal")

    property string bg_color: "#242246"
    color: bg_color
    // for login out
    signal signalLogout

    //header:
    Hat {
        id: _header
        title: "e-journal"
        hatColor: bg_color
    }

}
