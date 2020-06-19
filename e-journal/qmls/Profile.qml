import QtQuick 2.14
import QtQuick.Controls 2.12
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

    readonly property int commonPaddings: 15
    readonly property int commonSpacing: 10

    property Gradient backColorGrad: Gradient {
        GradientStop { position: 0.5;  color: _profile.color }
        GradientStop { position: 1.0; color: "transparent" }
    }

    Image {
        id: img
        source: userImgPath
        fillMode: Image.PreserveAspectCrop

        anchors.right: _profile.right
        anchors.top: _profile.top
        anchors.bottom: _profile.bottom
        width: parent.width / 2

        layer.enabled: true

    }

    Rectangle {
        id: backgroundRect
        width: _profile.height
        height: _profile.width

        anchors.centerIn: _profile

        gradient: backColorGrad
        rotation: -90;
    }


    Column {
        id: rows
        width: parent.width / 2
        spacing: commonSpacing
        padding: commonPaddings
        clip: true

        Text {
            id: name_block
            width: rows.width
            text: userName
            wrapMode: Text.Wrap
            color: "white"
            font.pointSize: 24
            font.italic: true
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: line
            width: rows.width
            height: 5
            color: "white"
            opacity: 0.8
        }
    }

    Item {
        id: cont
        anchors.top: rows.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width / 2

        clip: true

        ScrollView {
            anchors.fill: cont
            Column {
                id: rowsOfInfo

                spacing: commonPaddings
                padding: commonSpacing

                Text {
                    id: _subject

                    text: qsTr("Предметы:")
                    wrapMode: Text.Wrap

                    color: "white"
                    font.pointSize: 18
                    font.bold: true
                }

                Text {
                    id: subjectList
                    width: cont.width - commonPaddings * 2
                    wrapMode: Text.WordWrap
                    text: userSubject;
                    color: "white"
                    font.pointSize: 18
                    leftPadding: commonPaddings
                }

                Text {
                    id: groups_block
                    width: cont.width - commonPaddings * 2
                    text: qsTr("<b>" + "Группы:" + "</b> " + userGroups);
                    wrapMode: Text.Wrap
                    color: "white"
                    font.pointSize: 18
                }
            }
        }
    }
}
