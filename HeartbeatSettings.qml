import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5


GridLayout{
    Layout.fillWidth: true
    columns: 2

    property alias heartbeatEnabled: heartbeatEnabled.checked
    property alias heartbeatRequest: heartbeatRequest.text
    property alias heartbeatResponse: heartbeatResponse.text
    property alias heartbeatTimeout: heartbeatTimeout.value

    Text{
        text: qsTr("Enabled:")
        Layout.fillWidth: true
    }

    CheckBox{
        id: heartbeatEnabled
        Layout.fillWidth: true
        checked: qtRobo.connection.heartbeatEnabled
    }

    Text{
        text: qsTr("Request:")
        Layout.fillWidth: true
    }

    TextField{
        id: heartbeatRequest
        Layout.fillWidth: true
        text: qtRobo.connection.heartbeatRequest
    }

    Text{
        text: qsTr("Response:")
        Layout.fillWidth: true
    }

    TextField{
        id: heartbeatResponse
        Layout.fillWidth: true
        text: qtRobo.connection.heartbeatResponse
    }

    Text{
        text: qsTr("Timeout:")
        Layout.fillWidth: true
    }

    SpinBox{
        id: heartbeatTimeout
        Layout.fillWidth: true
        value: qtRobo.connection.heartbeatTimeout
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
