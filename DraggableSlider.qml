import QtQuick 2.0
import QtQuick.Controls 2.4

Item{
    id: root
    property string text: "New Slider"
    property string eventName
    property alias enabled: slider.enabled

    onTextChanged: children[0].text = text

    width: 200
    height: 30

    Slider{
        id: slider
        anchors.fill: parent
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

        onValueChanged: serialConnection.writeToSerial(eventName + ":" + value)
    }

    ScaleKnob{
        root: root
        enabled: ! slider.enabled
    }
}
