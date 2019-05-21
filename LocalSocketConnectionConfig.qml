import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QSerialPort 0.1

    GridLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 2
        rows: 3

        Label{
            text: "Domain Socket:"
        }

        TextField{
            id: socketName
            Layout.fillWidth: true
        }
   }
