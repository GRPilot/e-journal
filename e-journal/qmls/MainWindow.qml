import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

FramelessWindow {
    id: _mainWin
    width: 1024;
    height: 512;

    title: qsTr("e-journal | Profile")

    // for login out
    signal signalLogout

    property string bg_color:   "#242246"
    property string page_color: "#32305C"
    readonly property int unColumnedPages: 1
    readonly property int commonMargin:    5
    readonly property int heightOfTabs:    50
    property int widthOfTabs: 150
    property bool isMinimize: false

    property string profileTitle:    "Профиль"
    property string journalTitle:    "Журнал"
    property string statisticsTitle: "Сатистика"
    property string settingTitle:    "Настройки"

    property string signedUpLogin

    property var imgs: [
            "imgs/arrow",  // hide
            "imgs/user",   // profile
            "imgs/cross",
            "imgs/cross",
            "imgs/cross",
            "imgs/cross",
            "imgs/cross",
            "imgs/collaps", // setting
    ]

    color: bg_color

    Row {
        anchors.fill: parent

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
                    anchors.margins: commonMargin
                    width: height
                    fillMode: Image.PreserveAspectFit
                }
                Text {
                    id: _textHide
                    anchors.right: parent.right
                    anchors.left: _imgHide.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: commonMargin

                    verticalAlignment: Qt.AlignVCenter
                    text: "Скрыть панель"
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (isMinimize) {
                            tabMaximize();
                        } else {
                            tabMinimize();
                        }
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
                        anchors.margins: commonMargin
                        width: height
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        id: _text
                        anchors.right: parent.right
                        anchors.left: _img.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: commonMargin
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
                            _mainWin.title = qsTr("e-journal | %1".arg(view.getTab(index).title))
                        }
                    }
                }
                Component.onCompleted: view.getTab(0).forceActiveFocus();
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
                anchors.margins: commonMargin
                width: height
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: _settingText
                anchors.right: parent.right
                anchors.left: _settingImg.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: commonMargin
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
                    title = qsTr("e-journal | %1".arg(settingTitle));
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
                title: profileTitle

                Profile {
                    color: page_color;
                    login: signedUpLogin;
                }
            }
            Tab {
                title: journalTitle
                Rectangle {
                    color: page_color
                }
            }
            Tab {
                title: statisticsTitle
                Statistics {
                    color: page_color
                }
            }
            Tab {
                title: settingTitle
                Setting {
                    color: page_color
                }
            }
        }
    }

    NumberAnimation {
        id: minimizeImgAnim
        target: _imgHide
        property: "rotation"
        from: 0
        to: 180
        duration: 200
        easing.type: Easing.InOutBounce
    }
    NumberAnimation {
        id: maximizeImgAnim
        target: _imgHide
        property: "rotation"
        to: 360
        duration: 200
        easing.type: Easing.InOutBounce
    }

    NumberAnimation {
        id: maximizeAnim;
        target: _mainWin
        property: "widthOfTabs"
        to: 150
        duration: 200
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        id: minimizeAnim;
        target: _mainWin
        property: "widthOfTabs"
        to: heightOfTabs
        duration: 200
        easing.type: Easing.InOutQuad
    }

    onWidthChanged: {
        if (width <= widthOfTabs)
            tabMinimize();
    }

    onSignalLogout: {
        _mainWin.close();
    }

    function tabMinimize() {
        isMinimize = true;
        minimizeImgAnim.start();
        minimizeAnim.start();
    }

    function tabMaximize() {
        isMinimize = false;
        maximizeImgAnim.start();
        maximizeAnim.start();
    }
}
