import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12

FramelessWindow {
    id: _SignInWindow
    minimumWidth: 400
    minimumHeight: 500

    signal logined
    signal forgorButtonPressed
    signal signupButtomPressed

    property string backColor: "#242246"

    readonly property int commonScale: 5
    readonly property string commonFontFamily: "arial"
    readonly property string inputBoxColor:     "#222233"
    readonly property string textColor:         "white"
    readonly property string incorrectColor:    "#ff0022"
    readonly property string buttonColor:       "#c82f63"
    readonly property string buttonHoverColor:  "#912247"
    readonly property string buttonClickColor:  "green"
    readonly property string forgotButtonText: qsTr("Забыл логин или пароль")
    readonly property string signupButtonText: qsTr("Зарегистрироваться")
    readonly property Gradient textGradient: Gradient {
        GradientStop { position: 0.0; color: "#09479D" }
        GradientStop { position: 0.25; color: "#9949FD" }
        GradientStop { position: 0.5; color: "#FE0069" }
        GradientStop { position: 0.75; color: "#FE00FF" }
        GradientStop { position: 1.0; color: "#F3FEFA" }
    }

    Connections {
        target: validator
    }

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    Column {
        id: _AuthorizationWindow

        visible: true
        anchors.fill: parent

        Keys.onReturnPressed: {
            checkUser();
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

            Item {
                id: container_login
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    id: _image
                    source: "/images/login.svg"
                    height: container_login.height / 1.5
                    width: height
                    anchors.verticalCenter: container_login.verticalCenter
                }
                Rectangle {
                    id: space
                    anchors.top: container_login.top
                    anchors.bottom: container_login.bottom
                    anchors.left: _image.right
                    width: 20
                    color: "transparent"
                }
                Text {
                    id: _text

                    text: qsTr("Логин: ")
                    color: textColor
                    font.pointSize: container_login.height * (3/12)
                    anchors.verticalCenter: container_login.verticalCenter
                    anchors.left: space.right
                    font.family: commonFontFamily
                }

                Rectangle {
                    id: _textLoginInputContainer
                    anchors.verticalCenter: container_login.verticalCenter
                    anchors.left: _text.right
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    height: parent.height / 2
                    clip: true
                    color: inputBoxColor

                    radius: 5

                    TextInput {
                        id: _textLoginInput
                        text: qsTr("")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 5
                        focus: true
                        font.pointSize: parent.height * (3/6)
                        maximumLength: 32

                        validator: RegExpValidator {
                            regExp: /^(\S)+/
                        }

                        Keys.onTabPressed: {
                            _textPasswordInput.forceActiveFocus();
                        }

                        Keys.onPressed: {
                            _selectLoginAnim.start();
                        }

                        LinearGradient {
                            anchors.fill: _textLoginInput
                            start: Qt.point(0, _textLoginInput.height)
                            end: Qt.point(_textLoginInput.width, 0)
                            source: _textLoginInput
                            gradient: textGradient
                        }
                    }

                    ColorAnimation on color {
                        id: _selectLoginAnim
                        to: inputBoxColor
                        duration: 500
                    }

                    ColorAnimation on color {
                        id: incorrectLoginAnim
                        to: incorrectColor
                        duration: 500
                    }
                }
            }

        }
        // password
        AuthBlockPrefab {
            heightScale: commonScale
            color: backColor
            Item {
                id: container_password
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    id: _image_pas
                    source: "/images/pass.svg"
                    height: container_password.height / 1.5
                    width: height
                    anchors.verticalCenter: container_password.verticalCenter
                }
                Rectangle {
                    id: space_pas
                    anchors.top: container_password.top
                    anchors.bottom: container_password.bottom
                    anchors.left: _image_pas.right
                    width: 20
                    color: "transparent"
                }
                Text {
                    id: _text_pass

                    text: qsTr("Пароль: ")
                    color: textColor
                    font.pointSize: container_password.height * (3/12)
                    anchors.verticalCenter: container_password.verticalCenter
                    anchors.left: space_pas.right
                    font.family: commonFontFamily
                }

                Rectangle {
                    id: _textInputContainer
                    anchors.verticalCenter: container_password.verticalCenter
                    anchors.left: _text_pass.right
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    height: parent.height / 2
                    clip: true
                    color: inputBoxColor
                    radius: 5
                    Keys.onTabPressed: {
                        buttonMouseArea.focus = true;
                    }

                    TextInput {
                        id: _textPasswordInput
                        text: qsTr("")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 5
                        font.pointSize: parent.height * (3/6)
                        maximumLength: 32

                        echoMode: TextInput.Password

                        Keys.onPressed: {
                            _selectPassAnim.start();
                        }
                        LinearGradient {
                            anchors.fill: _textPasswordInput
                            start: Qt.point(0, _textPasswordInput.height)
                            end: Qt.point(_textPasswordInput.width, 0)
                            source: _textPasswordInput
                            gradient: textGradient
                        }
                    }

                    ColorAnimation on color {
                        id: _selectPassAnim
                        to: inputBoxColor
                        duration: 500
                    }

                    ColorAnimation on color {
                        id: incorrectPassAnim
                        to: incorrectColor
                        duration: 500
                    }
                }
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
                color: buttonColor

                Text {
                    anchors.centerIn: parent
                    color: textColor
                    text: qsTr("Войти");
                    font.family: commonFontFamily
                    font.pointSize: parent.height * 0.3
                }
                MouseArea {
                    id: buttonMouseArea

                    anchors.fill: parent
                    acceptedButtons: Qt.Key_Return | Qt.Key_Enter
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: {
                        exitingAnim.stop();
                        enteredAnim.start();
                    }
                    onExited: {
                        enteredAnim.stop();
                        exitingAnim.start();
                    }
                    onFocusChanged: {
                        if (buttonMouseArea.focus) {
                            enteredAnim.start();
                        } else {
                            exitingAnim.start();
                        }
                    }

                    Keys.onTabPressed: _textLoginInput.forceActiveFocus();

                    onClicked: {
                        checkUser();
                        parent.color = buttonClickColor;
                    }
                }

                ColorAnimation on color{
                    id: enteredAnim
                    running: false
                    to: buttonHoverColor
                    duration: 200
                }

                ColorAnimation on color{
                    id: exitingAnim
                    running: false
                    to: buttonColor
                    duration: 400
                }


            }
        }
        // Forgot pass and signup text
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

                text: forgotButtonText
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor

                    onEntered: { forgotText.localColor = "white"; }
                    onExited: { forgotText.localColor = "#343464"; }
                    onClicked: {
                        forgotText.localColor = "#AFAEAC";
                        _SignInWindow.forgorButtonPressed();
                    }
                }
            }

            Text {
                id: signupText

                anchors.top: forgotText.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                property string localColor: "#343464"

                color: localColor
                font.family: commonFontFamily
                font.pointSize: 12

                text: signupButtonText
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor

                    onEntered: { signupText.localColor = "white"; }
                    onExited: { signupText.localColor = "#343464"; }
                    onClicked: {
                        signupText.localColor = "#AFAEAC";
                        _SignInWindow.signupButtomPressed();
                    }
                }
            }
        }
    }

    function checkUser() {
        if (validator.checkUser(qsTr(_textLoginInput.text))) {
            if (validator.checkPassWithUser(_textLoginInput.text, _textPasswordInput.text)) {
                _SignInWindow.logined();
            } else {
                incorrectPassAnim.start();
                _textPasswordInput.forceActiveFocus();
            }
        } else {
            incorrectLoginAnim.start();
            _textLoginInput.forceActiveFocus();
        }
    }

    function onWinLoaded() {
        _SignInWin.show()
        _SignInWin.visible = true;
    }
}






