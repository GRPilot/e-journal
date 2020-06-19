import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.13


Rectangle {
    anchors.fill: parent

    property string login
    property string userName
    property string userSubject
    property string userGroups
    property string userImgPath

    property int itemsSpacing: 15
    property int marginsContainer: 10

    property string backColor:      "#242246"
    property string blockColor:     "#242247"
    property string rectangleColor: "transparent"

    property string profileInfoBlockTitle: qsTr("Персональная информация")

    Item {
        id: mainContainer
        anchors.fill: parent
        anchors.margins: marginsContainer

        ScrollView {
            id: scroll
            anchors.fill: mainContainer
            clip: true;

            Column {
                id: rows
                width: mainContainer.width
                spacing: itemsSpacing

                SettingBlockPrefub {
                    id: personalInfoSettings
                    width: parent.width
                    height: content.height
                    header: profileInfoBlockTitle
                    color: blockColor

                    Item {
                        id: content
                        anchors.top: parent.headerBottomAnchor
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 200

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

                    }
                }

                SettingBlockPrefub {
                    id: logout
                    width: parent.width
                    height: button.height + 25
                    header: profileInfoBlockTitle
                    color: blockColor

                    Button {
                        id: button

                        anchors.top: parent.headerBottomAnchor

                        width: logout.width
                        height: 40
                        text: qsTr("Выйти из учетной записи")

                        onClicked: signalLogout();
                    }
                }
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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
