import QtQuick 2.9
import QtGraphicalEffects 1.0

Column {
    id: _AuthorizationWindow

    readonly property int commonScale: 5
    readonly property string commonFontFamily: "arial"
    readonly property string inputBoxColor: "#222233"
    readonly property string textColor:  "white"
    readonly property string backColor: "#242246"
    readonly property Gradient textGradient: Gradient {
        GradientStop { position: 0.0; color: "#09479D" }
        GradientStop { position: 0.25; color: "#9949FD" }
        GradientStop { position: 0.5; color: "#FE0069" }
        GradientStop { position: 0.75; color: "#FE00FF" }
        GradientStop { position: 1.0; color: "#F3FEFA" }
    }

    // Title
    AuthBlockPrefab {
        id: _titleBlock
        heightScale: commonScale
        color: backColor
        Text {
            id: _Title
            text: qsTr("АВТОРИЗАЦИЯ")
            anchors.centerIn: parent
            color: textColor

            font.pointSize: 25
            font.family: commonFontFamily
        }
    }
    // login
    AuthBlockPrefab {
        heightScale: commonScale
        color: backColor
        InputBlock {
            anchors.fill: parent
            imgSource: "/images/login.svg"
            labelText: qsTr("Логин: ")
            localTextColor: textColor
            localFontFamily: commonFontFamily
            localInputBoxColor: inputBoxColor
            localGradient: textGradient

        }

    }
    // password
    AuthBlockPrefab {
        heightScale: commonScale
        color: backColor
        InputBlock {
            anchors.fill: parent
            imgSource: "images/pass.svg"
            labelText: qsTr("Пароль: ")
            localTextColor: textColor
            localFontFamily: commonFontFamily
            localInputBoxColor: inputBoxColor
            localGradient: textGradient
        }
    }
    // EnterButton
    AuthBlockPrefab {
        id: buttonContainer
        heightScale: commonScale
        color: backColor

        Rectangle {
            id: _buttonRect

            anchors.centerIn: parent
            width: parent.width / 2
            height: parent.height / 1.5
            radius: height / 2
            color: "yellow"

            Text {
                anchors.centerIn: parent
                color: textColor
                text: qsTr("Войти");
                font.family: commonFontFamily
                font.pointSize: parent.height * 0.3
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: { enteredAnim.start(); }
                onExited: { exitingAnim.start(); }
                onClicked: {
                    //parent.color = 'green'
                    /* метод передачи логина и пароля в класс Authorization
                     * для проверки. А так же при правильности введенных данных
                     * закрытие текущего окна и открытие окна с авторизированным
                     * пользователем.
                     */
                }

            }

            ColorAnimation on color{
                id: enteredAnim
                to: "orange"
                duration: 400
            }

            ColorAnimation on color{
                id: exitingAnim
                to: "yellow"
                duration: 400
            }
        }
    }

    // Forgot pass text
    AuthBlockPrefab {
        heightScale: commonScale
        color: backColor
        Text {
            id: forgotText

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            property string localColor: "#343464"

            color: localColor
            font.family: commonFontFamily
            font.pointSize: 12

            text: qsTr("I forgot login or password.")
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                onEntered: { forgotText.localColor = "white"; }
                onExited: { forgotText.localColor = "#343464"; }
                onClicked: {
                    forgotText.localColor = "#AFAEAC"
                }
            }
        }
    }


}

