import QtQuick 2.0
import QtGraphicalEffects 1.0


Rectangle {
    id: _settingBlock
    radius: 5
    clip: true
    width: 50;

    property int headerWidht: 25
    property string header: qsTr("<header>")
    property alias headerBottomAnchor: _header.bottom

    Rectangle {
        id: _header
        anchors.left: _settingBlock.left
        anchors.right: _settingBlock.right
        height: headerWidht
        color: Qt.rgba(0, 0, 0, 0.3)
        radius: _settingBlock.radius
        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            verticalAlignment: Qt.AlignVCenter
            text: header
            color: "white"
            font.pointSize: 10

        }

    }

    Component.onCompleted: {
        if (_settingBlock.width <= 50)
            _settingBlock.width = 50;
    }
}
