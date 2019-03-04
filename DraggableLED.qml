import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtQuick.Dialogs 1.3

Item {
    id: root
    width: 30
    height: 30

    property string displayedName: qsTr("LED")
    property string eventName
    property alias label: label.text
    property alias enabled: led.enabled
    property bool enableLED: false
    property alias color: bulb.color
    property var componentType: GlobalDefinitions.ComponentType.LED

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

            text: qsTr("New LED")
        }
    }

    Connections{
        target: serialConnection
        onDataChanged:{
            if(eventName === root.eventName){
                 enableLED = !!+data
            }
        }

        Component.onDestruction: target = undefined
    }

    ColorPickerKnob{
        root: root
        enabled: !led.enabled
    }

    DeleteComponentKnob{
        root: root
        enabled: !led.enabled
    }

    ScaleKnob{
        root: root
        enabled: !led.enabled
    }

    RightClickEdit{
        root: root
        enabled: !led.enabled
    }
}
