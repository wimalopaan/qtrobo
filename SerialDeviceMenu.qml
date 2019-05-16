import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Devices")
    property var root
    property string selectedConnection

    onAboutToShow: {
        repeater.model = serialConnection.serialInterfaces()
    }

    Repeater{
        id: repeater

        MenuItem{
            text: modelData
            onTriggered: {
                serialConnectionConfigDialog.open()
                selectedConnection = text
            }

            SerialConnectionConfigDialog{
                id: serialConnectionConfigDialog
                onAccepted: {
                    serialConnection.connectToSerial(selectedConnection)
                }
            }
        }
    }
}
