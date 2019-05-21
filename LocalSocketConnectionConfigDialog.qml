import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QSerialPort 0.1

Dialog{
    id: root
    width: 300
    title: qsTr("Local Socket Connection Config")
    closePolicy: Popup.CloseOnEscape
    property var component


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

        if(socketName.text.length > 0) {
            qtRobo.connection.preferences = {"socketName": socketName.text}
            qtRobo.connection.connect()
        }
    }
}
