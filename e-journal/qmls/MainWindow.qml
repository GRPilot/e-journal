import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.13

Window {
    width: 1200
    height: 800
    title: qsTr("e-journal")

    SwipeView {
        id: _view
        anchors.fill: parent

        Repeater {
            model: 6
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                sourceComponent: Text {
                    anchors.fill: parent
                    text: index
                    Component.onCompleted: console.log("created:", index)
                    Component.onDestruction: console.log("destroyed:", index)
                }
            }
        }
    }
}
