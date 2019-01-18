import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    property var root
    property var serialConnection

    Repeater{
        model: serialConnection.serialInterfaces()

        MenuItem{
            text: modelData
            onTriggered: serialConnection.connectToSerial(text)
        }

    }
}
