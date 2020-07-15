import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtRobo.ConnectionType 1.0

Dialog{
    id: root
    focus: true
    implicitWidth: 350
    closePolicy: Qt.CloseOnPressOutside
    title: qsTr("Connection")

    property var component


    function loadComponentMenu(){
        if(Number(qtRobo.connectionType) === ConnectionType.Serial){
            return "SerialConnectionConfig.qml"
        }
        else if(Number(qtRobo.connectionType) === ConnectionType.Socket){
            return "LocalSocketConnectionConfig.qml"
        }else
            return "BluetoothConnectionConfig.qml"

    }

    contentItem: ColumnLayout{
        spacing: 50
        TabBar{
            id: tabBar
            Layout.fillWidth: true
            TabButton{
                text: qsTr("Connection")
                font.capitalization: Font.MixedCase
            }

            TabButton{
                text: qsTr("Heartbeat")
                font.capitalization: Font.MixedCase
            }

            TabButton{
                text: qsTr("Events")
                font.capitalization: Font.MixedCase
            }
        }

        StackLayout{
            id: stackLayout
            Layout.fillWidth: true
            currentIndex: tabBar.currentIndex

            Loader{
                id: connectionConfigLoader
                source: loadComponentMenu()
            }

            HeartbeatSettings{
                id: heartbeatDialog

            }

            EventSettings{
                id: eventSettingsDialog
            }
        }
        Keys.onReturnPressed: root.accept()
    }

    footer: RowLayout{
        Button{
            text: qsTr("OK")
            Layout.alignment: Qt.AlignCenter
            onClicked:  root.accept()
        }

        Button{
            text: qsTr("Cancel")
            Layout.alignment: Qt.AlignCenter
            onClicked: root.reject()
        }
    }

    onAccepted: {
        var preferences = {};

        if(Number(qtRobo.connectionType) === ConnectionType.Serial){
            preferences.serialInterfaceName = connectionConfigLoader.item.interfaceName
            preferences.serialBaudrate = connectionConfigLoader.item.baudrate.value
            preferences.serialStopbit = connectionConfigLoader.item.stopbits.value
            preferences.serialParitybit = connectionConfigLoader.item.paritybits.value
        }else if(Number(qtRobo.connectionType) === ConnectionType.Socket){
            preferences.socketName = connectionConfigLoader.item.socketName
        }

        qtRobo.connection.preferences = preferences

        qtRobo.connection.heartbeatTimeout = heartbeatDialog.heartbeatTimeout
        qtRobo.connection.heartbeatRequest = heartbeatDialog.heartbeatRequest
        qtRobo.connection.heartbeatResponse = heartbeatDialog.heartbeatResponse
        qtRobo.connection.heartbeatEnabled = heartbeatDialog.heartbeatEnabled

        qtRobo.connection.messageParser.eventStart = eventSettingsDialog.eventStart
        qtRobo.connection.messageParser.eventEnd = eventSettingsDialog.eventEnd
        qtRobo.connection.messageParser.eventValueDivider = eventSettingsDialog.eventValueDivider

        qtRobo.connection.connect()

        GlobalDefinitions.projectEdited()
    }
}
