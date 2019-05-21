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
        else
            return "LocalSocketConnectionConfig.qml"

    }

    contentItem: ColumnLayout{
        spacing: 50
        TabBar{
            id: tabBar
            Layout.fillWidth: true
            TabButton{
                text: "Connection"
                font.capitalization: Font.MixedCase
            }

            TabButton{
                text: "Heartbeat"
                font.capitalization: Font.MixedCase
            }

            TabButton{
                text: "Events"
                font.capitalization: Font.MixedCase
            }
        }

        StackLayout{
            Layout.fillWidth: true
            currentIndex: tabBar.currentIndex

            Loader{
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
            text: "OK"
            Layout.alignment: Qt.AlignCenter
            onClicked:  root.accept()
        }

        Button{
            text: "Cancel"
            Layout.alignment: Qt.AlignCenter
            onClicked: root.reject()
        }
    }

    onAccepted: {

    }
}
