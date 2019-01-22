import QtQuick 2.0
import QtQuick.Controls 2.4

Item{
    id: root
    property alias text: label.text
    property string eventName
    property alias enabled: slider.enabled

    width: 200
    height: 30

    Slider{
        id: slider
        anchors.fill: parent
        to: 100
        from: 0
        stepSize: 1
        enabled: false

        Label{
            id: label
            height: 20
            text: qsTr("New Slider")
            font.pointSize: 12
            anchors.bottom: parent.top
            anchors.left: parent.left
        }

        onValueChanged: serialConnection.writeToSerial(eventName + ":" + value)
    }

    DeleteComponentKnob{
        root: root
        enabled: !slider.enabled
    }

    ScaleKnob{
        root: root
        enabled: !slider.enabled
    }
}
