import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    width: 500;
    height: 300;
    title: qsTr("e-journal")

    // for login out
    signal signalLogout

    header: Hat {

    }

    SwipeView {
        id: _view
        anchors.fill: parent

       /* Repeater {
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
        }*/
    }


}
