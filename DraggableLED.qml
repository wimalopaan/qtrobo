import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    property string eventName: "led"
    property alias label: label.text
    property alias enabled: led.enabled
    property bool enableLED: false

    id: root
    width: 20
    height: 20

    Rectangle{
        id: led
        width: parent.width < parent.height ? parent.width : parent.height
        height: width
        radius: width * 0.5
        enabled: false

        color: Qt.rgba(0.3, 0.3, 0.3, 1)

        Rectangle{
            id: bulb
            property color red: Qt.rgba(1, 0, 0, 1)

            anchors.fill: parent
            anchors.margins: 4
            radius: width * 0.5
            color: red
        }

        Rectangle{
            id: dim
            anchors.fill: parent
            anchors.margins: 4
            radius: width * 0.5

            color: enableLED ? Qt.rgba(1, 1, 1, 0) : Qt.rgba(0.2, 0.2, 0.2, 0.8)
        }

        Label{
            id: label
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            text: "My LED"
        }
    }

    Connections{
        target: serialConnection
        onDataChanged:{
            if(data.startsWith(eventName + ":")){
                 enableLED = !!+data.substring(eventName.length + 1)
            }
        }

        Component.onDestruction: target = null
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
