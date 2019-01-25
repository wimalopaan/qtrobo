import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

Item{
    id: root
    property alias label: label.text
    property string eventName
    property alias enabled: slider.enabled
    property alias orientation: slider.orientation

    width: 200
    height: 30
    objectName: "DraggableSlider"

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

        onValueChanged: serialConnection.writeToSerial(eventName, value)
    }

    Connections{
        target: serialConnection
        onDataChanged:{
            if(eventName === root.eventName && data){
                slider.value = +data
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: !slider.enabled
    }

    ScaleKnob{
        root: root
        enabled: !slider.enabled
    }

    RightClickEdit{
        root: root
        enabled: !slider.enabled
    }

    RotateKnob{
        root: root
        orientation: slider
        enabled: !slider.enabled
    }
}
