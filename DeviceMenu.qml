import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Devices")
    property var root

    onAboutToShow: {
        repeater.model = serialConnection.serialInterfaces()
    }

    Repeater{
        id: repeater

        MenuItem{
            text: modelData
            onTriggered: serialConnection.connectToSerial(text)
        }

    }
}
