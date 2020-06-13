import QtQuick 2.12
import QtQuick.Controls 2.13

Rectangle {
    anchors.fill: parent

    property int itemsSpacing: 5

    Item {
        id: mainContainer
        anchors.fill: parent
        anchors.margins: parent.height / 10

        Column {
            spacing: itemsSpacing

            Rectangle {
                id: personalInfo

                width: mainContainer

            }

            Button {
                id: button

                width: mainContainer.width
                height: 20
                text: qsTr("Logout")

                onClicked: signalLogout();
            }
        }

    }

}
