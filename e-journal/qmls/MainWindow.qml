import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import loc.ProfileInfo 1.0


FramelessWindow {
    id: _mainWin
    width: 1024;
    height: 512;

    minimumWidth: 512;
    minimumHeight: 512;

    title: qsTr("e-journal | " + profileTitle)

    // for login out
    signal signalLogout

    hasDropMenu: true;

    property string bg_color:   "#242246"
    property string page_color: "#32305C"
    readonly property int unColumnedPages: 1
    readonly property int commonMargin:    5
    readonly property int heightOfTabs:    50
    property int widthOfTabs: 150
    property bool isMinimize: false

    property string profileTitle:    "Профиль"
    property string journalTitle:    "Журнал"
    property string statisticsTitle: "Статистика"
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

   // data from DB
    ProfileInfo {
        id: userInfo
    }

    onSignedUpLoginChanged: {
        userInfo.setUsername(signedUpLogin);
        imgs[1] = userInfo.image;
        console.log(userInfo.image);

        // setting image to the left panel's button
        repeaterPages.itemAt(0).children[0].source = imgs[1];
    }
   // end data from DB

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
                    anchors.fill: mask;

                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: mask
                    }
                }

                Rectangle {
                    id: mask
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: commonMargin
                    width: height
                    opacity: 0;

                }
                Text {
                    id: _textHide
                    anchors.right: parent.right
                    anchors.left: mask.right
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
                id: repeaterPages
                model: view.count - unColumnedPages
                Rectangle {
                    id: rect
                    width: widthOfTabs
                    height: heightOfTabs
                    color: page_color
                    opacity: 0.5

                    Image {
                        id: _img
                        source: imgs[index + unColumnedPages]
                        anchors.fill: _mask;

                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: _mask
                        }
                    }

                    Rectangle {
                        id: _mask
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: commonMargin
                        width: height
                        radius: width / 2;
                        opacity: 0


                    }
                    Text {
                        id: _text
                        anchors.right: parent.right
                        anchors.left: _mask.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: commonMargin
                        verticalAlignment: Qt.AlignVCenter
                        text: view.getTab(index).title
                        color: "white"
                    }
                    MouseArea {
                        id: mouseAreaOfRect
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
                            forceActiveFocus();
                            _mainWin.title = qsTr("e-journal | %1".arg(view.getTab(index).title))
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
                    title = qsTr("e-journal | " + settingTitle);
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
                id: profieTab
                title: profileTitle

                Profile {
                    id: proflePage
                    color: page_color;
                    login: signedUpLogin;

                    onLoginChanged: {
                        proflePage.userName    = userInfo.name;
                        proflePage.userGroups  = userInfo.groups;
                        proflePage.userSubject = userInfo.subjects;
                        proflePage.userImgPath = userInfo.image;

                        if (userGroups === qsTr("<no items>"))
                            userGroups = qsTr("нет групп");

                        if (userSubject === qsTr("<no items>"))
                            userSubject = qsTr("нет предметов");
                    }
                }


            }
            Tab {
                title: journalTitle
                Statistics {
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
        easing.type: Easing.OutBack
    }
    NumberAnimation {
        id: minimizeAnim;
        target: _mainWin
        property: "widthOfTabs"
        to: heightOfTabs
        duration: 200
        easing.type: Easing.OutBack
    }

    onWidthChanged: {
        if (width <= widthOfTabs)
            tabMinimize();
    }

    onSignalLogout: {
        userInfo.clearUserData();
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
