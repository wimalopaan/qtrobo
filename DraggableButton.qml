import QtQuick 2.0
import QtQuick.Controls 2.4

Item{
    id: root
    width: 200
    height: 50
    property string eventName
    property alias text: button.text
    property alias enabled: button.enabled
    Button{
        id: button
        anchors.fill: parent
        text: "New Button"
        enabled: false

        onPressed:{
            serialConnection.writeToSerial(eventName);
        }

        onReleased: {
            //serial.writeToSerial(eventName + ":0");
        }
    }

    ScaleKnob{
        root: root
        enabled: !button.enabled
    }
}
