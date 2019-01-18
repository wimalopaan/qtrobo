import QtQuick 2.0
import QtQuick.Controls 2.4

Button{
    property var serial
    property string eventName
    text: "New Button"
    enabled: false

    onPressed:{
        serial.writeToSerial(eventName + ":1");
    }

    onReleased: {
        serial.writeToSerial(eventName + ":0");
    }
}
