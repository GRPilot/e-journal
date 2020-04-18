import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: _profile
    anchors.fill: parent

    property int commonHeight: height / 4

    // Data
    //TODO: Подгрузка данных из бд
    property string userName: qsTr("Силахина\nТатьяна Валентиновна")
    property string userImg: qsTr("images/user.png")
    property string userSubject: qsTr("Аппаратно-программные средства, Технические средства информатизации")
    property string userGroups: qsTr("ИП-18-4, ИП-18-3")



    Column {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 5

        Rectangle {
            id: _FIO_block
            anchors.right: parent.right
            anchors.left: parent.left
            height: commonHeight
            color: "transparent"

            Rectangle {
                id: mask
                height: commonHeight
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: height
                radius: width / 2
                color: "grey"

                Image {
                    id: img

                    source: userImg

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
            /*Item {
                anchors.left: mask.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 10
                clip: true



            }*/
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

                text: qsTr("Предмет:")
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
