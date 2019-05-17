import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Serial")
    property var root
    property string selectedConnection

    onAboutToShow: {
        repeater.model = qtRobo.connection.serialInterfaces()
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
                    qtRobo.connection.connect({'serial_interface': selectedConnection})
                }
            }
        }
    }
}
