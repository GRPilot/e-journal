import QtQuick 2.12
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
        id: _loginImage
        source: imgSource
        height: container.height / 1.5
        width: height
        anchors.verticalCenter: container.verticalCenter
    }
    Rectangle {
        id: space
        anchors.top: container.top
        anchors.bottom: container.bottom
        anchors.left: _loginImage.right
        width: 20
        color: "transparent"
    }
    Text {
        id: _loginText

        text: labelText
        color: localTextColor
        font.pointSize: container.height * (3/12)
        anchors.verticalCenter: container.verticalCenter
        anchors.left: space.right
        font.family: localFontFamily
    }
    Rectangle {
        id: _loginTextInputContainer
        anchors.verticalCenter: container.verticalCenter
        anchors.left: _loginText.right
        anchors.right: parent.right
        anchors.leftMargin: 10
        height: container.height / 2

        color: localInputBoxColor
        radius: 5

        TextInput {
            id: loginTextInput

            anchors.verticalCenter: _loginTextInputContainer.verticalCenter
            anchors.left: _loginTextInputContainer.left
            anchors.right: _loginTextInputContainer.right
            anchors.margins: 5
            font.pointSize: _loginTextInputContainer.height * (3/6)
            maximumLength: 32

            LinearGradient {
                anchors.fill: loginTextInput
                start: Qt.point(0, loginTextInput.height)
                end: Qt.point(loginTextInput.width, 0)
                source: loginTextInput
                gradient: localGradient
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }
        }

    }
}

