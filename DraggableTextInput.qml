import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle{
    id: root
    width: 200
    height: 100
    border.width: 2

    property string eventName
    property string label: qsTr("New Textinput")
    property alias enabled: layout.enabled
    property var componentType: GlobalDefinitions.ComponentType.TextInput
    property bool edible: true
    onEdibleChanged: enabled = !edible

    GridLayout{
        id: layout
        enabled: false
        columns: 2
        anchors.fill: parent
        anchors.margins: 5

        Label{
            text: label
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: 12
        }

        TextField{
            id: textinput
            Layout.fillWidth: true
        }

        Button{
            text: "Send"
            onClicked: {
                if(eventName && eventName.length > 0 && textinput.text.length > 0){
                    serialConnection.writeToSerial(eventName, textinput.text)
                    textinput.clear()
                }
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }

    ScaleKnob{
        root: root
        enabled: root.edible
    }

    RightClickEdit{
        root: root
        enabled: root.edible
    }
}
