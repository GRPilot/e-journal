import QtQuick 2.0
import QtGraphicalEffects 1.0

import loc.ProfileInfo 1.0

// TODO: Разберись с изображением


Rectangle {
    id: _profile
    anchors.fill: parent

    property int commonHeight: height / 4

    ProfileInfo {
        id: profileInfo

    }

    property string login
    // Data
    //TODO: Подгрузка данных из бд
    property string userName
    property string userSubject
    property string userGroups
    property string userImgPath

    onLoginChanged: {
        profileInfo.setUsername(login);

           userName = profileInfo.name();
         userGroups = profileInfo.groups();
        userSubject = profileInfo.subjects();
        //var image = profileInfo.image();

        if (userGroups === qsTr("<no items>"))
            userGroups = qsTr("нет групп");

        if (userSubject === qsTr("<no items>"))
            userSubject = qsTr("нет предметов");
    }

    Column {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 5

        Rectangle {
            id: _FIO_block
            //anchors.right: parent.right
            //anchors.left: parent.left
            height: commonHeight
            color: "transparent"

            Rectangle {
                id: mask
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                height: commonHeight
                width: height
                radius: width / 2
                color: "grey"


                Image {
                    id: img
                    source: userImgPath

                    anchors.fill: parent
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: mask
                    }

                }

                //TODO: Сделать возможность изменения фотографии
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Text {
                id: name_block
                anchors.left: mask.right
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: height / 10
                text: userName
                wrapMode: Text.Wrap
                color: "white"
                font.pointSize: 24
                font.italic: true
                verticalAlignment: Text.AlignVCenter
            }

        }

        Grid {
            columns: 2
            columnSpacing: height / 15
            rowSpacing: height / 20
            anchors.top: _FIO_block.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 20
            clip: true

            Text {
                id: _subject

                text: qsTr("Предметы:")
                wrapMode: Text.Wrap

                color: "white"
                font.pointSize: 18
            }

            Text {
                id: subjects
                width: parent.width - _subject.width
                wrapMode: Text.WordWrap
                text: userSubject
                color: "white"
                font.pointSize: 18

            }

            Text {
                id: groups_block

                text: qsTr("Группы:")
                wrapMode: Text.Wrap
                color: "white"
                font.pointSize: 18
            }

            Text {
                id: groups

                width: parent.width - groups_block.width
                wrapMode: Text.WrapAnywhere
                text: userGroups
                color: "white"
                font.pointSize: 18

            }
        }
    }


}
