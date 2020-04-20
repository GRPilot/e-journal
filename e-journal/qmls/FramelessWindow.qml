import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

//TODO: Доделать масштабирование кнопок
//TODO: Добавить возможность изменение размера окна потянув за угол
//TODO: Сделать при каждом открытии стандартный размер и позицию

ApplicationWindow {
    id: _framelessWin
    flags: Qt.FramelessWindowHint

/// Properties

    property string headerColor: "#242246"
    property string backColor:   "#242246"
    property string borderColor: "transparent"
    property bool isBorderEnabled: _framelessWin.visibility !== ApplicationWindow.Maximized
    property bool isDragWindowEnabled: _framelessWin.visibility !== ApplicationWindow.Maximized

    property string title: "New window"
    property string iconImg: qsTr("none")

    property int borderSize: 5

    // Свойства, которые будут хранить позицию зажатия курсора мыши
    property int previousX: 0
    property int previousY: 0

    // Начальные параметры
    property int defaultWindowWidth: -1
    property int defaultWindowHeight: -1
    readonly property int defaultWindowPositionX: Screen.width / 2 - width / 2
    readonly property int defaultWindowPositionY: Screen.height / 2 - height / 2

/// Content

    // Custom header with exit button and also
    Rectangle {
        id: _hat
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: 25

        readonly property int speedOfAnim: 200
        readonly property int maxButtonSize: 50
        property string hatColor: headerColor
        property int widthOfButtons: maxButtonSize


        color: hatColor

        MouseArea {
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
                color: "white"

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
                    source: "images/cross.png"
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
                    source: "images/expand.png"
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
                    source: "images/collaps.png"
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
        anchors.top: parent.top

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
        anchors.top: parent.top

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
        anchors.top: parent.top

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
        maximizeImg.source = "images/restore.png";
    }
    function normolizing() {
        showNormal();
        isBorderEnabled = true;
        isDragWindowEnabled = true;
        maximizeImg.source = "images/expand.png";
    }

    onVisibleChanged: {
        if (defaultWindowHeight === -1)
            defaultWindowHeight = height;
        if (defaultWindowWidth === -1)
            defaultWindowWidth = width;

        setWidth(defaultWindowWidth);
        setHeight(defaultWindowHeight);
        setX(defaultWindowPositionX);
        setY(defaultWindowPositionY);
        console.log("width: " + width + "\nheight: " + height);
    }
}
