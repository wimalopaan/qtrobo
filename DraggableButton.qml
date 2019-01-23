import QtQuick 2.0
import QtQuick.Controls 2.4

Item{
    id: root
    width: 200
    height: 50
    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled
    Button{
        id: button
        anchors.fill: parent
        text: "New Button"
        enabled: false
        font.pointSize: 12

        onPressed:{
            serialConnection.writeToSerial(eventName);
        }

        onReleased: {
            //serial.writeToSerial(eventName + ":0");
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
        enabled: !button.enabled
    }
}
