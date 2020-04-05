import QtQuick 2.9
import QtGraphicalEffects 1.0

Item {
    id: container
    anchors.margins: 10
    property string imgSource: ""
    property string labelText: ""
    property string localTextColor: ""
    property string localFontFamily: ""
    property string localInputBoxColor: ""
    property Gradient localGradient: Gradient {}

    Image {
        id: _image
        source: imgSource
        height: container.height / 1.5
        width: height
        anchors.verticalCenter: container.verticalCenter
    }
    Rectangle {
        id: space
        anchors.top: container.top
        anchors.bottom: container.bottom
        anchors.left: _image.right
        width: 20
        color: "transparent"
    }
    Text {
        id: _text

        text: labelText
        color: localTextColor
        font.pointSize: container.height * (3/12)
        anchors.verticalCenter: container.verticalCenter
        anchors.left: space.right
        font.family: localFontFamily
    }
    Rectangle {
        id: _textInputContainer
        anchors.verticalCenter: container.verticalCenter
        anchors.left: _text.right
        anchors.right: parent.right
        anchors.leftMargin: 10
        height: container.height / 2

        color: localInputBoxColor
        radius: 5

        TextInput {
            id: _textInput

            anchors.verticalCenter: _textInputContainer.verticalCenter
            anchors.left: _textInputContainer.left
            anchors.right: _textInputContainer.right
            anchors.margins: 5
            font.pointSize: _textInputContainer.height * (3/6)
            maximumLength: 32

            LinearGradient {
                anchors.fill: _textInput
                start: Qt.point(0, _textInput.height)
                end: Qt.point(_textInput.width, 0)
                source: _textInput
                gradient: localGradient
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }
        }

    }
}
