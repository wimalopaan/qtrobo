import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Dialog{
    focus: true
    implicitWidth: 300
    implicitHeight: 200
    closePolicy: Qt.CloseOnPressOutside
    title: qsTr("Component Preferences")

    property var component

    contentItem:  GridLayout{
        columns: 2
        rows: 2

        Text{
            text: "Component Name:"
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
            Layout.fillWidth: true
            text: component.eventName

            onTextChanged: component.eventName = text
        }

        Text{
            text: "Delete Component:"
        }

        CheckBox{
            id: deleteToggle
        }
    }

    onClosed: {
        if(deleteToggle.checked)
            component.destroy()
    }
}
