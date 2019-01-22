import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Dialog{
    id: root
    focus: true
    implicitWidth: 300
    implicitHeight: 200
    closePolicy: Qt.CloseOnPressOutside
    title: qsTr("Control Preferences")

    property var component

    contentItem:  GridLayout{
        columns: 2
        rows: 2

        Text{
            text: "Control Name:"
        }

        TextField{
            Layout.fillWidth: true
            text: component.text

            onTextChanged: component.text = text
        }

        Text{
            text: "Event Name:"
        }

        TextField{
            enabled: !(component instanceof DraggableSerialDisplay)
            Layout.fillWidth: true
            text: component.eventName

            onTextChanged: component.eventName = text
        }

        Keys.onReturnPressed: root.accept()
    }
}
