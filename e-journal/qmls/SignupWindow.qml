import QtQuick 2.14
import QtQuick.Controls 2.12

import loc.SignupProfile 1.0

FramelessWindow {
    id: _SignUpWinLocal
    width: 500
    height: 650
    minimumWidth: 500
    minimumHeight: 500

    SignupHelper {
        id: _signupHelper
    }

    property string backColor:              "#242246"
    property string blockColor:             "#32305C"
    property string textColor:              "white"
    property string inputBoxColor:          "#242246"
    property string inputBoxActiveColor:    "#222233"
    property string inputBoxIncorrectColor: "#B16264"
    property string buttonColor:            "#c82f63"
    property string buttonHoverColor:       "#912247"
    property string buttonClickColor:       "#5CA665"
    property string correctCollor:          "#5CA665"
    property string blockTitle:             "РЕГИСТРАЦИЯ"
    property string blockName:              "Введите ФИО:"
    property string blockLogin:             "Введите логин:"
    property string blockPassword:          "Введите пароль:"
    property string blockPasswordComfirm:   "Подтвердите пароль:"
    property string buttonTitle:            "зарегистрироваться"
    property string backButtonTitle:        "назад"

    property string lastRegProfile;

    readonly property string commonFontFamily: "arial"
    readonly property int blockSizeScale:     4
    readonly property int fontInputTextScale: 2
    readonly property int fontTitleScale:     3
    readonly property int fontScale:          5
    readonly property int fontButtonScale:    3
    readonly property int countOfBlocks:      6
    readonly property int heightOfLine:       5
    readonly property int commonRadius:      20
    readonly property int commonMargins:      5

    color: backColor
    headerColor: backColor

    Rectangle {
        id: _block
        anchors.centerIn: parent
        width: parent.width - parent.width / blockSizeScale
        height: parent.height - parent.height / blockSizeScale + heightOfLine;
        color: blockColor
        radius: commonRadius

        Keys.onReturnPressed: buttonPressed();

        // Title
        Item {
            id: _blockTitle
            height: parent.height / countOfBlocks - heightOfLine * 3
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Text {
                id: _blockTitleText
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: textColor

                text: blockTitle

                font.pointSize: Math.min(parent.width, parent.height) / fontTitleScale
                font.family: commonFontFamily
            }
        }
        // Line
        Rectangle {
            id: _line
            anchors.top: _blockTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: heightOfLine
            color: "white"
            opacity: 0.5
        }
        // Full name Text Input
        Item {
            id: _blockName
            height: parent.height / countOfBlocks - heightOfLine
            anchors.top: _line.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true
            anchors.margins: commonMargins

            Text {
                id: _blockNameText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                color: textColor
                text: blockName

                font.family: commonFontFamily
                font.pointSize: Math.min(parent.width, parent.height) / fontScale
            }

            Rectangle {
                id: _blockNameForm
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: _blockNameText.bottom
                anchors.topMargin: commonMargins

                color: inputBoxColor
                clip: true

                radius: commonRadius


                TextInput {
                    id: _blockNameTextInput
                    anchors.fill: parent
                    anchors.margins: commonMargins

                    maximumLength: 32

                    verticalAlignment: Text.AlignVCenter
                    focus: true
                    color: textColor

                    font.pixelSize: Math.min(parent.width, parent.height) / fontInputTextScale
                }


                ColorAnimation on color {
                    running: _blockNameTextInput.activeFocus
                    to: inputBoxActiveColor
                    duration: 200
                }
                ColorAnimation on color {
                    running: !_blockNameTextInput.activeFocus
                    to: inputBoxColor
                    duration: 200
                }
                ColorAnimation on color {
                    id: incorNameAnim
                    running: false
                    to: inputBoxIncorrectColor
                    duration: 200
                }

                Keys.onTabPressed: {
                    _blockLoginTextInput.forceActiveFocus();
                    if (_blockNameTextInput.text.length <= 0)
                        incorNameAnim.start();
                }
            }
        }
        // Login Text Imput
        Item {
            id: _blockLogin
            height: parent.height / countOfBlocks - heightOfLine
            anchors.top: _blockName.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: commonMargins
            clip: true

            Text {
                id: _blockLoginText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                color: textColor
                text: blockLogin

                font.family: commonFontFamily
                font.pointSize: Math.min(parent.width, parent.height) / fontScale
            }

            Rectangle {
                id: _blockLoginForm
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: _blockLoginText.bottom
                anchors.topMargin: commonMargins

                color: inputBoxColor
                clip: true

                radius: commonRadius

                TextInput {
                    id: _blockLoginTextInput
                    anchors.fill: parent
                    anchors.margins: commonMargins
                    verticalAlignment: Text.AlignVCenter
                    maximumLength: 32
                    color: textColor

                    font.pixelSize: Math.min(parent.width, parent.height) / fontInputTextScale

                    validator: RegExpValidator {
                        regExp: /^(\S)+/
                    }
                }

                ColorAnimation on color {
                    running: _blockLoginTextInput.activeFocus
                    to: inputBoxActiveColor
                    duration: 200
                }
                ColorAnimation on color {
                    running: !_blockLoginTextInput.activeFocus
                    to: inputBoxColor
                    duration: 200
                }

                ColorAnimation on color {
                    id: incorLoginComfAnim
                    to: inputBoxIncorrectColor
                    duration: 200
                }

                Keys.onTabPressed: {
                    _blockPassTextInput.forceActiveFocus();
                }
            }
        }
        // Password Text Imput
        Item {
            id: _blockPass
            height: parent.height / countOfBlocks - heightOfLine
            anchors.top: _blockLogin.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: commonMargins
            clip: true

            Text {
                id: _blockPassText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                color: textColor
                text: blockPassword

                font.family: commonFontFamily
                font.pointSize: Math.min(parent.width, parent.height) / fontScale
            }

            Rectangle {
                id: _blockPassForm
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: _blockPassText.bottom
                anchors.topMargin: commonMargins

                color: inputBoxColor
                clip: true

                radius: commonRadius

                TextInput {
                    id: _blockPassTextInput
                    anchors.fill: parent
                    anchors.margins: commonMargins
                    verticalAlignment: Text.AlignVCenter
                    echoMode: TextInput.Password

                    color: textColor

                    font.pixelSize: Math.min(parent.width, parent.height) / fontInputTextScale

                }

                ColorAnimation on color {
                    running: _blockPassTextInput.activeFocus
                    to: inputBoxActiveColor
                    duration: 200
                }
                ColorAnimation on color {
                    id: normalColorAnim
                    running: !_blockPassTextInput.activeFocus
                    to: inputBoxColor
                    duration: 200
                }
                ColorAnimation on color {
                    id: incorPassAnim
                    running: false
                    to: inputBoxIncorrectColor
                    duration: 200
                }


                Keys.onTabPressed: {
                    _blockPassComfirmTextInput.forceActiveFocus();
                    if (!isPasswordValid(_blockPassTextInput.text))
                        incorPassAnim.start();
                }
            }
        }
        // Password Comfirm Imput
        Item {
            id: _blockPassComfirm
            height: parent.height / countOfBlocks - heightOfLine
            anchors.top: _blockPass.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: commonMargins
            clip: true

            Text {
                id: _blockPassComfirmText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                color: textColor
                text: blockPasswordComfirm

                font.family: commonFontFamily
                font.pointSize: Math.min(parent.width, parent.height) / fontScale
            }

            Rectangle {
                id: _blockPassComfirmForm
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: _blockPassComfirmText.bottom
                anchors.topMargin: commonMargins

                color: inputBoxColor
                clip: true

                radius: commonRadius

                TextInput {
                    id: _blockPassComfirmTextInput
                    anchors.fill: parent
                    anchors.margins: commonMargins
                    verticalAlignment: Text.AlignVCenter
                    echoMode: TextInput.Password
                    color: textColor

                    font.pixelSize: Math.min(parent.width, parent.height) / fontInputTextScale

                    onFocusChanged: {

                    }

                }

                ColorAnimation on color {
                    running: _blockPassComfirmTextInput.activeFocus
                    to: inputBoxActiveColor
                    duration: 200
                }

                ColorAnimation on color {
                    running: !_blockPassComfirmTextInput.activeFocus
                    to: inputBoxColor
                    duration: 200
                }

                ColorAnimation on color {
                    id: incorPassComfAnim
                    target: parent
                    to: inputBoxIncorrectColor
                    duration: 200
                }

                Keys.onTabPressed: {
                    _blockNameTextInput.forceActiveFocus();
                    if (!(isPasswordValid(_blockPassTextInput.text.toString() && isPasswordsEqual())))
                        incorPassComfAnim.start();
                }
            }
        }
        // Buttons
        Item {
            id: _blockButton
            height: parent.height / countOfBlocks - heightOfLine * 2
            anchors.top: _blockPassComfirm.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                id: _button
                anchors.top: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: heightOfLine
                width: parent.width - parent.width / blockSizeScale
                height: parent.height - (parent.height * 1.5) / blockSizeScale

                color: buttonColor
                radius: commonRadius

                Text {
                    id: _blockButtonText
                    anchors.centerIn: parent
                    color: textColor

                    text: buttonTitle

                    font.pointSize: Math.min(parent.width, parent.height) / fontButtonScale
                    font.family: commonFontFamily
                }

                MouseArea {
                    anchors.fill: parent;
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.Key_Return | Qt.Key_Enter
                    hoverEnabled: true

                    onEntered: enteringAnim.start();
                    onExited:  exitingAnim.start();
                    onClicked: buttonPressed();
                }

                ColorAnimation on color {
                    id: enteringAnim
                    running: false
                    to: buttonHoverColor
                    duration: 200
                }
                ColorAnimation on color {
                    id: exitingAnim
                    running: false
                    to: buttonColor
                    duration: 400
                }
                ColorAnimation on color {
                    id: clickedAnimColor
                    running: false
                    from: buttonClickColor
                    to: buttonColor
                    duration: 700
                }
            }

            Rectangle {
                id: _backButton
                anchors.top: _button.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: heightOfLine * 2
                width: (parent.width - parent.width / blockSizeScale) / 1.5
                height: parent.height - (parent.height * 2.5) / blockSizeScale

                color: buttonColor
                radius: commonRadius

                Text {
                    id: _blockBackButtonText
                    anchors.centerIn: parent
                    color: textColor

                    text: backButtonTitle

                    font.pointSize: (Math.min(parent.width, parent.height) * 1.5) / fontButtonScale
                    font.family: commonFontFamily
                }

                MouseArea {
                    anchors.fill: parent;
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.Key_Return | Qt.Key_Enter
                    hoverEnabled: true

                    onEntered: enteringBackAnim.start();
                    onExited:  exitingBackAnim.start();
                    onClicked: buttonBackPressed();

                }

                ColorAnimation on color {
                    id: enteringBackAnim
                    running: false
                    to: buttonHoverColor
                    duration: 200
                }
                ColorAnimation on color {
                    id: exitingBackAnim
                    running: false
                    to: buttonColor
                    duration: 400
                }
                ColorAnimation on color {
                    id: clickedBackAnimColor
                    running: false
                    from: buttonClickColor
                    to: buttonColor
                    duration: 700
                }
            }
        }

    }

    ColorAnimation on color {
        id: userCreatedSuccessAnim
        targets: [
            _blockNameForm,
            _blockLoginForm,
            _blockPassForm,
            _blockPassComfirmForm,
            _SignUpWinLocal
        ]
        properties: "color"
        running: false
        to: correctCollor
        duration: 200
    }
    ColorAnimation {
        id: headerCorrectAnim
        target: _SignUpWinLocal
        properties: "headerColor"
        running: false;
        to: correctCollor
        duration: 200
    }

    ColorAnimation on color {
        id: setStandartColors
        targets: [
            _blockNameForm,
            _blockLoginForm,
            _blockPassForm,
            _blockPassComfirmForm,
            _SignUpWinLocal
        ]
        properties: "color"
        running: false
        to: backColor
        duration: 200
    }
    ColorAnimation {
        id: headerStandartAnim
        target: _SignUpWinLocal
        properties: "headerColor"
        running: false;
        to: backColor;
        duration: 200
    }

    function correctAnimStart() {
        userCreatedSuccessAnim.start();
        headerCorrectAnim.start();
    }
    function standartAnimStart() {
        setStandartColors.start();
        headerStandartAnim.start();
    }

    function buttonPressed() {
        clickedAnimColor.start();

        var status = false;
        var login = _blockLoginTextInput.text

        var passChecker = isPasswordValid(_blockPassTextInput.text) && isPasswordsEqual();
        var loginChecker = !_signupHelper.checkUser(login);

        if (!loginChecker) {
            incorLoginComfAnim.start();
        } else if (!passChecker) {
            incorPassAnim.start();
            incorPassComfAnim.start();
        } else {
            status = createUser();
            correctAnimStart();
        }

        return status;
    }
    function buttonBackPressed() {
        clickedBackAnimColor.start();
        this.close();
    }

    function isPasswordValid(password) {
        if (password.length <= 4)
            return false;

        return true;
    }
    function isPasswordsEqual() {
        return (_blockPassTextInput.text === _blockPassComfirmTextInput.text);
    }

    function createUser() {
        var name = _blockNameTextInput.text;
        var login = _blockLoginTextInput.text;
        var password = _blockPassTextInput.text;

        var status = _signupHelper.newUser(login, password, name);

        if (status) lastRegProfile = login;

        return status;
    }

    function clearFields() {
        _blockNameTextInput.text = "";
        _blockLoginTextInput.text = "";
        _blockPassTextInput.text = "";
        _blockPassComfirmTextInput.text = "";

        standartAnimStart();
    }
}
