import QtQuick 2.0
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.12

Item{
    id: root
    width: 200
    height: 50
    objectName: "DraggableButtonWithIndicator"
    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled

    Button{
        id: button
        anchors.fill: parent
        text: "New Button"
        enabled: false
        font.pointSize: 12

        property bool isOn: false

        onPressed:{
            serialConnection.writeToSerial(eventName, +isOn);
            //isOn = !isOn
        }

        RadialGradient{
            width: parent.width/10
            height: parent.height / 5
            anchors.right: parent.right
            anchors.margins: width
            anchors.verticalCenter: parent.verticalCenter

            gradient: Gradient{
                GradientStop{position: 0.0; color: button.isOn ? "red" : Qt.rgba(0.5, 0.2, 0.2, 0.6)}
                GradientStop{position: 1; color: Qt.rgba(0.4, 0.0, 0.0, 1)}
            }

        }
    }

    Connections{
        target: serialConnection
        onDataChanged:{
            if(eventName === root.eventName && data){
                button.isOn = !!+data
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: !button.enabled
    }

    ScaleKnob{
        root: root
        enabled: !button.enabled
    }

    RightClickEdit{
        root: root
        enabled: true
    }
}
