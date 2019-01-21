import QtQuick 2.0
import QtQuick.Controls 2.4

Button{
    property string eventName
    text: "New Button"
    enabled: false

    onPressed:{
        serialConnection.writeToSerial(eventName);
    }

    onReleased: {
        //serial.writeToSerial(eventName + ":0");
    }
}
