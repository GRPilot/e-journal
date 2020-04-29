import QtQuick 2.0
import QtQuick.Controls 2.13

Rectangle {
    anchors.fill: parent

    Item {
        anchors.fill: parent
        anchors.margins: parent.height / 10

        Button {
            id: button
            anchors.centerIn: parent
            width: parent.width / 10
            height: parent.height / 10
            text: qsTr("Logout")

            onClicked: signalLogout();
        }


    }

}
