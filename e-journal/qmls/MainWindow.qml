import QtQuick 2.12
import QtQuick.Window 2.12
//import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    width: 1024;
    height: 512;
    title: qsTr("e-journal")

    property string bg_color: "#242246"
    readonly property string page_color: "#332258"
    readonly property int unColumnedPages: 1
    property int widthOfTabs: 150
    property int heightOfTabs: 50
    property bool isMinimize: false

    property var imgs: [
            "images/collaps.png", // hide
            "images/user.png", // profile
            "images/cross.png",
            "images/cross.png",
            "images/cross.png",
            "images/cross.png",
            "images/cross.png",
            "images/collaps.png", // setting

    ]

    color: bg_color
    // for login out
    signal signalLogout

    //header:
    Hat {
        id: _header
        title: "e-journal"
        hatColor: bg_color
        height: 25

    }

    Row {
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: _header.bottom

        Column {
            id: columns
            spacing: 4

            // Minimize left panel button
            Rectangle {
                id: hiddenButton
                width: widthOfTabs
                height: heightOfTabs
                color: page_color
                opacity: 0.5
                Image {
                    id: _imgHide
                    source: imgs[0]
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: height
                    fillMode: Image.PreserveAspectFit
                }
                Text {
                    id: _textHide
                    anchors.right: parent.right
                    anchors.left: _imgHide.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    verticalAlignment: Qt.AlignVCenter
                    text: "Скрыть панель"
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (isMinimize) {
                            widthOfTabs = 150;

                        } else {
                            widthOfTabs = heightOfTabs;

                        }
                        isMinimize = !isMinimize
                    }
                }
            }

            // pages
            Repeater {
                model: view.count - unColumnedPages
                Rectangle {

                    width: widthOfTabs
                    height: heightOfTabs
                    color: page_color
                    opacity: 0.5

                    Image {
                        id: _img

                        source: imgs[index + unColumnedPages]
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: height
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        id: _text
                        anchors.right: parent.right
                        anchors.left: _img.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Qt.AlignVCenter
                        text: view.getTab(index).title
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onFocusChanged: {
                            if (focus) {
                                parent.opacity = 1;
                            } else {
                                parent.opacity = 0.5;
                            }

                        }

                        onClicked: {
                            view.currentIndex = index;
                            focus = true;
                        }
                    }
                }
            }
        }

        // Setting Button
        Rectangle {
            id: settingButton

            anchors.bottom: parent.bottom
            anchors.left: parent.left

            width: widthOfTabs
            height: heightOfTabs

            color: page_color
            opacity: 0.5

            Image {
                id: _settingImg
                source: imgs[imgs.length - 1]
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: height
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: _settingText
                anchors.right: parent.right
                anchors.left: _settingImg.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Qt.AlignVCenter
                text: view.getTab(view.count - unColumnedPages).title
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onFocusChanged: {
                    if (focus) {
                        parent.opacity = 1;
                    } else {
                        parent.opacity = 0.5;
                    }

                }

                onClicked: {
                    view.currentIndex = view.count - unColumnedPages;
                    focus = true;
                }
            }
        }

        TabView {
            id: view
            style: TabViewStyle {
                tab: Rectangle {

                    border.width: 0
                    color: bg_color
                }
            }
            anchors.bottom: parent.bottom
            anchors.left: columns.right
            anchors.right: parent.right
            anchors.top: parent.top

            Tab {
                title: "Профиль"

                Profile {
                    color: page_color;
                }
            }
            Tab {
                title: "Журнал"
                Rectangle {
                    color: page_color
                }
            }
            Tab {
                title: "Статистика"
                Statistics {
                    color: page_color
                }
            }

            Tab {
                title: "Настройки"
                Setting {
                    color: page_color
                }
            }
        }
    }
}
