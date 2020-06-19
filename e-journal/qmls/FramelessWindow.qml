import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12

//TODO: Доделать масштабирование кнопок

ApplicationWindow {
    id: _framelessWin
    flags: Qt.FramelessWindowHint | Qt.Window
    width: 600
    height: 600
    minimumHeight: 100
    minimumWidth: 100 

    visible: true;

    signal settingShow

    Loader {
        id: settingLoader
    }

    onSettingShow: {
        settingLoader.setSource("GlobalSettingWindow.qml")
    }

/// Properties

    property string headerColor: "transparent"
    property string backColor:   "transparent"
    property string borderColor: "transparent"
    property string menuColor:   "#212045"
    property string textColor:   "white"
    property bool isBorderEnabled:
        _framelessWin.visibility !== ApplicationWindow.Maximized

    property bool isDragWindowEnabled:
        _framelessWin.visibility !== ApplicationWindow.Maximized

    property bool hasDropMenu: true

    property string title: "New window"
    property string iconImg: qsTr("none")
    property string menuItemTextSetting: qsTr("Settings")
    property string menuItemTextExit: qsTr("Exit")

    property int borderSize: 5
    property int commonMenuItemHeight: 25

    // Свойства, которые будут хранить позицию зажатия курсора мыши
    property int previousX: 0
    property int previousY: 0

    // Начальные параметры
    property int defaultWindowWidth: 500
    property int defaultWindowHeight: 500
    readonly property int zOfBorders: 2
    readonly property int defaultWindowPositionX: Screen.width / 2 - width / 2
    readonly property int defaultWindowPositionY: Screen.height / 2 - height / 2

/// Content

    // Custom header with exit button and also
    header: Rectangle {
        id: _hat
        anchors.left: parent.left
        anchors.right: parent.right
        z: 1
        height: 25

        readonly property int speedOfAnim: 200
        readonly property int maxButtonSize: 50
        property int widthOfButtons: maxButtonSize

        color: headerColor

        MouseArea {
            id: hatMouseArea
            anchors.fill: parent

            onDoubleClicked: {
                if (visibility != ApplicationWindow.Maximized)
                    maximizing();
                else
                    normolizing();
            }

            onPressed: {
                previousX = mouseX;
                previousY = mouseY;
            }

            onMouseXChanged: {
                if (isDragWindowEnabled) {
                    var dx = mouseX - previousX;
                    _framelessWin.setX(_framelessWin.x + dx);
                }
            }

            onMouseYChanged: {
                if (isDragWindowEnabled) {
                    var dy = mouseY - previousY;
                    _framelessWin.setY(_framelessWin.y + dy);
                }
            }

        }

        Rectangle {
            id: leftBlock
            anchors.right: rightBlock.left
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            color: "transparent"

            Image {
                id: icon
                anchors.left: parent.left
                anchors.top:parent.top
                anchors.bottom: parent.bottom
                visible: iconImg === qsTr("none") ? false : true
                fillMode: Image.PreserveAspectFit
                onVisibleChanged: {
                    if (icon.visible)
                        icon.source = iconImg;
                }
            }

            Text {
                anchors.left: icon.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 5
                verticalAlignment: Qt.AlignVCenter
                id: titleText
                text: qsTr(title)
                color: textColor

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onClicked: {
                        if (hasDropMenu) {
                            _menu.open();
                            _openMenuAmin.start();
                        }
                    }
                }
                Menu {
                    id: _menu
                    y: parent.height
                    enabled: hasDropMenu
                    background.opacity: 0
                    width: 140
                    height: 1
                    Rectangle {
                        id: _cont
                        anchors.fill: parent
                        color: menuColor


                        radius: 5
                        MenuItem {
                            id: _settingMenuItem
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            Text {
                                text: menuItemTextSetting
                                color: textColor
                                anchors.centerIn: parent;
                            }
                            height: commonMenuItemHeight
                            onTriggered: settingShow();

                        }

                        Rectangle {
                            id: _separator
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: _settingMenuItem.bottom
                            height: 2
                            color: textColor
                        }

                        MenuItem {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: _separator.bottom
                            Text {
                                text: menuItemTextExit
                                color: textColor
                                anchors.centerIn: parent;
                            }
                            height: commonMenuItemHeight
                            onTriggered: close();

                        }


                        NumberAnimation {
                            id: _openMenuAmin
                            running: false;
                            target: _menu
                            property: "height"
                            to: _cont.height
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            id: _closeMenuAmin
                            running: false;
                            target: _menu
                            property: "height"
                            to: 0
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }


                    onClosed: {
                        _menu.open();
                        _closeMenuAmin.start();
                    }
                }
            }
        }

        Rectangle {
            id: rightBlock
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            readonly property int commonMargins: 2

            color: "transparent"
            width: cross.width * 3 + commonMargins * 6

            Rectangle {
                id: cross

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: rightBlock.commonMargins
                clip: true
                radius: 5
                width: _hat.widthOfButtons
                Image {
                    id: crossImg
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "imgs/cross"//"images/cross.png"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: enterCrossAnim.start()
                    onExited: exitCrossAnim.start()
                    onClicked: {
                        _framelessWin.close();
                    }
                }

                ColorAnimation on color{
                    id: exitCrossAnim
                    to: "transparent"
                    duration: _hat.speedOfAnim
                }
                ColorAnimation on color{
                    id: enterCrossAnim
                    to: "red"
                    duration: _hat.speedOfAnim
                }
            }
            Rectangle {
                id: maximize
                anchors.right: cross.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: rightBlock.commonMargins
                clip: true
                radius: 5
                width: _hat.widthOfButtons
                Image {
                    id: maximizeImg
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "imgs/expand"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: enterMaximizeAnim.start()
                    onExited: exitMaximizeAnim.start()
                    onClicked: {
                        if (visibility != ApplicationWindow.Maximized)
                            maximizing();
                         else
                            normolizing();
                    }
                }

                ColorAnimation on color{
                    id: exitMaximizeAnim
                    to: "transparent"
                    duration: _hat.speedOfAnim
                }
                ColorAnimation on color{
                    id: enterMaximizeAnim
                    to: "green"
                    duration: _hat.speedOfAnim
                }
            }
            Rectangle {
                id: minimize
                anchors.right: maximize.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: rightBlock.commonMargins
                radius: 5
                width: _hat.widthOfButtons
                clip: true

                Image {
                    id: minimizeImg
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "imgs/collaps"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: enterMinimizeAnim.start()
                    onExited: exitMinimizeAnim.start()
                    onClicked: showMinimized();
                }

                ColorAnimation on color{
                    id: exitMinimizeAnim
                    to: "transparent"
                    duration: _hat.speedOfAnim
                }
                ColorAnimation on color{
                    id: enterMinimizeAnim
                    to: "blue"
                    duration: _hat.speedOfAnim
                }
            }
        }
    }

 // #### CORNERS ####

    // left top corner
    Rectangle {
        id: leftTopCorner
        anchors.left: parent.left
        anchors.top: _hat.top
        z: zOfBorders
        width: borderSize
        height: borderSize

        color: borderColor
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            onEntered: {
                previousY = mouseY;
                previousX = mouseX;
            }

            onMouseYChanged: grabTopBorder(this)
            onMouseXChanged: grabLeftBorder(this)
        }
    }

    // right top corner
    Rectangle {
        id: rightTopCorner

        anchors.right: parent.right
        anchors.top: _hat.top
        z: zOfBorders
        width: borderSize
        height: borderSize

        color: borderColor
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeBDiagCursor
            onEntered: {
                previousX = mouseX;
                previousY = mouseY;
            }

            onMouseXChanged: grabRightBorder(this);
            onMouseYChanged: grabTopBorder(this);
        }
    }

    // right bottom corner
    Rectangle {
        id: rightBottomCorner
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        z: zOfBorders
        width: borderSize
        height: borderSize

        color: borderColor
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor

            onEntered: {
                previousX = mouseX;
                previousY = mouseY;
            }

            onMouseXChanged: grabRightBorder(this)
            onMouseYChanged: grabBottomBorder(this);
        }
    }

    // left bottom corner
    Rectangle {
        id: leftBottomCorner
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        z: zOfBorders
        width: borderSize
        height: borderSize

        color: borderColor
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeBDiagCursor
            onEntered: {
                previousY = mouseY;
                previousX = mouseX;
            }

            onMouseYChanged: grabBottomBorder(this)
            onMouseXChanged: grabLeftBorder(this)
        }
    }

 // #### BORDERS ####

    // top border
    Rectangle {
        id: topBorder
        anchors.left: leftTopCorner.right
        anchors.right: rightTopCorner.left
        anchors.top: _hat.top
        z: zOfBorders
        height: borderSize

        color: borderColor
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onClicked: {
                previousY = mouseY;
            }

            onMouseYChanged: grabTopBorder(this);
        }
    }

    // right border
    Rectangle {
        id: rightBorder
        anchors.right: parent.right
        anchors.top: rightTopCorner.bottom
        anchors.bottom: rightBottomCorner.top
        z: zOfBorders
        color: borderColor
        width: borderSize
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onEntered: {
                previousX = mouseX
            }
            onMouseXChanged: grabRightBorder(this)
        }
    }

    // left border
    Rectangle {
        id: leftBorder
        anchors.left: parent.left
        anchors.top: leftTopCorner.bottom
        anchors.bottom: leftBottomCorner.top
        z: zOfBorders
        color: borderColor
        width: borderSize
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onEntered: {
                previousX = mouseX
            }
            onMouseXChanged: grabLeftBorder(this)
        }
    }

    // bottom border
    Rectangle {
        id: bottomBorder
        anchors.left: leftBottomCorner.right
        anchors.right: rightBottomCorner.left
        anchors.bottom: parent.bottom
        z: zOfBorders
        height: borderSize

        color: borderColor
        enabled: isBorderEnabled
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onClicked: {
                previousY = mouseY;
            }

            onMouseYChanged: grabBottomBorder(this);
        }
    }

    function grabTopBorder(mouseArea) {
        var dy = mouseArea.mouseY - previousY;
        var maxHeight = _framelessWin.maximumHeight;
        var minHeight = _framelessWin.minimumHeight;
        var curHeight = _framelessWin.height;

        if (curHeight - dy <= minHeight || curHeight - dy >= maxHeight)
            dy = 0

        _framelessWin.setY(_framelessWin.y + dy)
        _framelessWin.setHeight(curHeight - dy);

    }
    function grabRightBorder(mouseArea) {
        var dx = mouseArea.mouseX - previousX;
        var maxWidth = _framelessWin.maximumWidth;
        var minWidth = _framelessWin.minimumWidth;
        var curWidth = _framelessWin.width;

        if (curWidth + dx <= minWidth || curWidth + dx >= maxWidth)
            dx = 0;

        _framelessWin.setWidth(curWidth + dx)
    }
    function grabLeftBorder(mouseArea) {
        var dx = mouseArea.mouseX - previousX;
        var maxWidth = _framelessWin.maximumWidth;
        var minWidth = _framelessWin.minimumWidth;
        var curWidth = _framelessWin.width;

        if (curWidth - dx <= minWidth || curWidth - dx >= maxWidth)
            dx = 0;

        _framelessWin.setX(_framelessWin.x + dx);
        _framelessWin.setWidth(curWidth - dx)
    }
    function grabBottomBorder(mouseArea) {
        var dy = mouseArea.mouseY - previousY;
        var maxHeight = _framelessWin.maximumHeight;
        var minHeight = _framelessWin.minimumHeight;
        var curHeight = _framelessWin.height;

        if (curHeight + dy <= minHeight || curHeight + dy >= maxHeight)
            dy = 0

        _framelessWin.setHeight(curHeight + dy);
    }

    function maximizing() {
        showMaximized();
        isBorderEnabled = false;
        isDragWindowEnabled = false;
        maximizeImg.source = "imgs/restore";
    }
    function normolizing() {
        showNormal();
        isBorderEnabled = true;
        isDragWindowEnabled = true;
        maximizeImg.source = "imgs/expand";
        centeringWindow();
    }

    function centeringWindow() {
        setX(defaultWindowPositionX);
        setY(defaultWindowPositionY);
    }

    onVisibleChanged: {
        if (defaultWindowHeight === 500 && height > 0) {
            defaultWindowHeight = height;
        }
        if (defaultWindowWidth === 500 && width > 0) {
            defaultWindowWidth = width;
        }

        setWidth(defaultWindowWidth);
        setHeight(defaultWindowHeight);
        centeringWindow();
    }

    DropShadow {
      anchors.fill: _hat
      horizontalOffset: 1
      verticalOffset: 1
      radius: hatMouseArea.pressed ? 8 : 5
      samples: 10
      source: _hat
      color: "black"
      Behavior on radius { PropertyAnimation { duration: 100 } }
    }
}
