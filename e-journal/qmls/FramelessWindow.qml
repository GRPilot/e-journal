import QtQuick 2.12
import QtQuick.Controls 2.12

//TODO: Доделать масштабирование кнопок
//TODO: Добавить возможность изменение размера окна потянув за угол
//TODO: Сделать при каждом открытии стандартный размер и позицию

ApplicationWindow {
    id: _framelessWin
    flags: Qt.FramelessWindowHint

    /// Properties

    property string headerColor: "#242246"
    property string backColor:   "#242246"
    property string borderColor: "red"

    property string title: "New window"
    property string iconImg: qsTr("none")

    property int borderSize: 5

    // Свойства, которые будут хранить позицию зажатия курсора мыши
    property int previousX: 0
    property int previousY: 0

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

        //TODO: correct this shit also
        MouseArea {

            anchors.fill: parent

            onDoubleClicked: {
                if (visibility != ApplicationWindow.Maximized) {
                    visibility = ApplicationWindow.Maximized;
                    maximizeImg.source = "images/restore.png"
                } else {
                    visibility = ApplicationWindow.Windowed
                    maximizeImg.source = "images/expand.png"
                }
            }

            onPressed: {
                previousX = mouseX
                previousY = mouseY
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                _framelessWin.setX(_framelessWin.x + dx)
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                _framelessWin.setY(_framelessWin.y + dy)
            }

        }

        Rectangle {
            id: leftBlock
            anchors.right: rightBlock.left
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            color: "red"

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
                        if (visibility != ApplicationWindow.Maximized) {
                            visibility = ApplicationWindow.Maximized;
                            maximizeImg.source = "images/restore.png"
                        } else {
                            visibility = ApplicationWindow.Windowed
                            maximizeImg.source = "images/expand.png"
                        }
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
                    onClicked: {
                        visibility = ApplicationWindow.Minimized
                    }
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

    // top scale anchor
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: borderSize

        color: borderColor

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onClicked: {
                previousY = mouseY;
            }

            onMouseYChanged: {
                var dy = mouseY - previousY;
                var maxHeight = _framelessWin.maximumHeight;
                var minHeight = _framelessWin.minimumHeight;
                var curHeight = _framelessWin.height;

                if (curHeight - dy <= minHeight || curHeight - dy >= maxHeight)
                    dy = 0

                _framelessWin.setY(_framelessWin.y + dy)
                _framelessWin.setHeight(curHeight - dy);

            }
        }
    }

    // right scale anchor
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: borderColor
        width: borderSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onEntered: {
                previousX = mouseX
            }
            onMouseXChanged: {
                var dx = mouseX - previousX;
                var maxWidth = _framelessWin.maximumWidth;
                var minWidth = _framelessWin.minimumWidth;
                var curWidth = _framelessWin.width;

                if (curWidth + dx <= minWidth || curWidth + dx >= maxWidth)
                    dx = 0;

                _framelessWin.setWidth(curWidth + dx)
            }
        }
    }

    // left scale anchor
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: borderColor
        width: borderSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onEntered: {
                previousX = mouseX
            }
            onMouseXChanged: {
                var dx = mouseX - previousX;
                var maxWidth = _framelessWin.maximumWidth;
                var minWidth = _framelessWin.minimumWidth;
                var curWidth = _framelessWin.width;

                if (curWidth - dx <= minWidth || curWidth - dx >= maxWidth)
                    dx = 0;

                _framelessWin.setX(_framelessWin.x + dx);
                _framelessWin.setWidth(curWidth - dx)
            }
        }
    }

    // bottom scale anchor
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: borderSize

        color: borderColor

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onClicked: {
                previousY = mouseY;
            }

            onMouseYChanged: {
                var dy = mouseY - previousY;
                var maxHeight = _framelessWin.maximumHeight;
                var minHeight = _framelessWin.minimumHeight;
                var curHeight = _framelessWin.height;

                if (curHeight + dy <= minHeight || curHeight + dy >= maxHeight)
                    dy = 0

                _framelessWin.setHeight(curHeight + dy);
            }
        }
    }
}
