import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: _profile
    anchors.fill: parent

    property int commonHeight: height / 4

    property string login
    property string userName
    property string userSubject
    property string userGroups
    property string userImgPath

    Column {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 5

        Rectangle {
            id: _FIO_block
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
                    fillMode: Image.PreserveAspectCrop

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
