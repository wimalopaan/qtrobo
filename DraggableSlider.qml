import QtQuick 2.0
import QtQuick.Controls 2.4

Slider{
    property string text: "New Slider"
    property var serial
    property string eventName

    onTextChanged: children[0].text = text
    width: 200
    height: 30
    to: 100
    from: 0
    stepSize: 1
    enabled: false

    Text{
        height: 20
        text: parent.text
        anchors.bottom: parent.top
        anchors.left: parent.left
    }

    onValueChanged: serial.writeToSerial(eventName + ":" + value)
}
