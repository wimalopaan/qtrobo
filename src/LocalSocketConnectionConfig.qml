import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QSerialPort 0.1

    GridLayout{
        Layout.fillWidth: true

        columns: 2
        rows: 3

        property alias socketName: socketName.text

        Label{
            text: qsTr("Domain Socket:")
            Layout.fillWidth: true
        }

        TextField{
            id: socketName
            text: qtRobo.connection.preferences.socketName ? qtRobo.connection.preferences.socketName : ""
            Layout.fillWidth: true
        }
   }
