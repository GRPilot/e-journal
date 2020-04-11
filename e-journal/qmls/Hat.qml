import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 25

    readonly property string hatColor: "#242246"
    readonly property int speedOfAnim: 200
    property string title: "New window"
    property string iconImg: "images/space.png"

    // Свойства, которые будут хранить позицию зажатия курсора мыши
    property int previousX
    property int previousY

    color: hatColor

    //TODO: correct this shit also
    MouseArea {

        anchors.fill: parent

        onPressed: {
            previousX = mouseX
            previousY = mouseY
        }

        onMouseXChanged: {
            var dx = mouseX - previousX
            setX(parent.x + dx)
        }

        onMouseYChanged: {
            var dy = mouseY - previousY
            setY(parent.y + dy)
        }
    }

    Rectangle {
        id: leftBlock
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 2
        color: "transparent"

        Image {
            id: icon
            anchors.left: parent.left
            anchors.top:parent.top
            anchors.bottom: parent.bottom
            fillMode: Image.PreserveAspectFit
            source: iconImg
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
        anchors.left: leftBlock.right
        color: "transparent"

        Rectangle {
            id: cross

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2

            radius: 5
            width: 50
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
                    Qt.quit();
                }
            }

            ColorAnimation on color{
                id: exitCrossAnim
                to: "transparent"
                duration: speedOfAnim
            }
            ColorAnimation on color{
                id: enterCrossAnim
                to: "red"
                duration: speedOfAnim
            }
        }
        Rectangle {
            id: maximize
            anchors.right: cross.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2

            radius: 5
            width: 50
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
                duration: speedOfAnim
            }
            ColorAnimation on color{
                id: enterMaximizeAnim
                to: "green"
                duration: speedOfAnim
            }
        }
        Rectangle {
            id: minimize
            anchors.right: maximize.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            radius: 5
            width: 50

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
                duration: speedOfAnim
            }
            ColorAnimation on color{
                id: enterMinimizeAnim
                to: "blue"
                duration: speedOfAnim
            }
        }
    }



}
