import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
    property var serial
    width: 300
    height: 150

    border.color: "lightgray"
    border.width: 2
    TextArea{
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        font.family: "Monospaced"
        font.pointSize: 20
        enabled:  false


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
}
