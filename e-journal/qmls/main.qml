import QtQuick 2.9
import QtQuick.Window 2.3

Window {
    visible: true
    width: 500
    height: 500
    minimumWidth: 400
    minimumHeight: 500

    title: qsTr("Hello World")

    Authorization {
        visible: true
        anchors.fill: parent

    }
}
