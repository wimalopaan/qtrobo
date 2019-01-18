import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
    property var serial
    width: 200
    height: 100

    border.color: "lightgray"
    border.width: 2
    Text{
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        font.family: "Monospaced"
        font.pointSize: 20

        Timer{
            interval: 100
            repeat: true
            running: true
            onTriggered: {
                var response = serial.readFromSerial();
                if(response.length > 0)
                    parent.text = response;
            }
        }
    }

    MouseArea{
        anchors.fill: parent

        acceptedButtons: Qt.RightButton

        onClicked: popup.open()

        Popup{
            id: popup
            width: 200
            height: 200
            focus: true
            closePolicy: Popup.CloseOnPressOutside
        }
    }
}
