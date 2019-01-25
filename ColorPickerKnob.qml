import QtQuick 2.0
import QtQuick.Dialogs 1.3

Text{
    property var root

    id: colorKnob
    text: "▧"
    color: "#3F51B5"
    font.bold: true
    width: 15
    height: 15
    anchors.top: parent.bottom
    anchors.right: parent.left
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: colorPicker.open()
    }

    ColorDialog{
        id: colorPicker
        color: "red"
        showAlphaChannel: false
        onAccepted: root.color = color
    }
}
