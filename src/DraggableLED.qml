import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtQuick.Dialogs 1.3

Item {
    id: root
    width: 30
    height: 30

    property string eventName
    property alias label: label.text
    property alias enabled: led.enabled
    property bool enableLED: false
    property alias componentColor: bulb.color
    property var componentType: GlobalDefinitions.ComponentType.LED
    property color fontColor: "black"
    property bool edible: true

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.componentColor = origin.componentColor
        root.fontColor = origin.fontColor
        root.label = origin.label
    }

    onEdibleChanged: enabled = !edible

    Rectangle{
        id: led
        width: parent.width < parent.height ? parent.width : parent.height
        height: width
        radius: width * 0.5
        enabled: false

        color: Qt.rgba(0.3, 0.3, 0.3, 1)

        Rectangle{
            id: bulb
            anchors.fill: parent
            anchors.margins: 4
            radius: width * 0.5
            color: "red"
        }

            RadialGradient{
                id: dim
                anchors.fill: parent
                anchors.margins: 3.5

                source: bulb
                gradient: Gradient{
                    GradientStop{position: 0.0; color: (enableLED ? Qt.rgba(1, 1, 1, 0) : Qt.rgba(0.1, 0.1, 0.1, 0.6))}
                    GradientStop{position: 1; color: led.color}
                }
        }

        Label{
            id: label
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: fontColor
            font.pointSize: 12
            text: qsTr("New LED")
        }
    }

    Connections{
        target: qtRobo.connection
        function onDataChanged(eventName, data){
            if(eventName === root.eventName){
                 enableLED = !!+data
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }

    ScaleKnob{
        root: root
        enabled: root.edible
    }

    RightClickEdit{
        root: root
        enabled: root.edible
    }
}
