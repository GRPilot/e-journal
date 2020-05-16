import QtQuick 2.12
import QtQuick.Controls 2.12

FramelessWindow {
    id: _GlobSetWin

    width: 500
    height: 750

    minimumWidth: 500
    minimumHeight: 500

    hasDropMenu: false

    property string backColor: "#242246"
    property string blockColor: "#32305C"
    property int widthOfBlock: width / 1.1

    color: backColor

    ScrollView {
        anchors.fill: parent

        Column {
            id: _column
            spacing: 5;
            // Sorry, but I had no different solution :c
            x: (_GlobSetWin.width - widthOfBlock) / 2
            y: 10

            SettingBlockPrefub {
                width: widthOfBlock
                height: 100
                header: "first"
                color: blockColor

                Rectangle {
                    anchors.top: parent.headerBottomAnchor
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5

                    color: "transparent"
                }
            }

            SettingBlockPrefub {
                width: widthOfBlock
                height: 100
                header: "second"
                color: blockColor

                Rectangle {
                    anchors.top: parent.headerBottomAnchor
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5

                    color: "transparent"
                }
            }
        }

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff;
    }


}
