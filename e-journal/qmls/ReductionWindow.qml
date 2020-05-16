import QtQuick 2.12
import QtQuick.Window 2.12

FramelessWindow {
    width: 600
    height: 600
    minimumHeight: 100
    minimumWidth: 100

    hasDropMenu: false;

    property string backColor:  "#242246"
    property string blockColor: "#32305C"

    color: backColor
}
