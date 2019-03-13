import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog{
    id: root
    width: 300
    title: qsTr("Heartbeat Settings")

    GridLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 2

        Text{
            text: qsTr("Enabled:")
        }

        CheckBox{
            id: heartbeatEnabled
            Layout.fillWidth: true
            checked: serialConnection.heartbeatEnabled
        }

        Text{
            text: qsTr("Request:")
        }

        TextField{
            id: heartbeatRequest
            Layout.fillWidth: true
            text: serialConnection.heartbeatRequest
        }

        Text{
            text: qsTr("Response:")
        }

        TextField{
            id: heartbeatResponse
            Layout.fillWidth: true
            text: serialConnection.heartbeatResponse
        }

        Text{
            text: qsTr("Timeout:")
        }

        SpinBox{
            id: heartbeatTimeout
            Layout.fillWidth: true
            value: serialConnection.heartbeatTimeout
            editable: true
            from:  500
            to: 10000
            Text{
                text: "ms"
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
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
        serialConnection.heartbeatEnabled = heartbeatEnabled.checked

        if(heartbeatRequest.text.length > 0)
            serialConnection.heartbeatRequest = heartbeatRequest.text

        if(heartbeatResponse.text.length > 0)
            serialConnection.heartbeatResponse = heartbeatResponse.text

        serialConnection.heartbeatTimeout = heartbeatTimeout.value
    }
}
