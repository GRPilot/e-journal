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

                width: mainContainer.width

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

/*
            Image {
                id: img
                source: userImgPath
                fillMode: Image.PreserveAspectCrop

                anchors.fill: mask
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
            }

            Rectangle {
                id: mask
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                height: commonHeight
                width: height
                radius: width / 2
                opacity: 0;

                //TODO: Сделать возможность изменения фотографии
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                }
            }
  */
