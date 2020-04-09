import QtQuick 2.12

Rectangle {
    property double heightScale: 1

    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height / heightScale
}
