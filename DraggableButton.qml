import QtQuick 2.9
import QtQuick.Controls 2.5

Item{
    id: root
    width: 200
    height: 50

    property string displayedName: qsTr("Button")
    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled
    property var componentType: GlobalDefinitions.ComponentType.Button
    property alias componentColor: buttonBackground.color

    Button{
        id: button
        anchors.fill: parent
        text: qsTr("New Button")
        enabled: false
        font.pointSize: 12
        background: Rectangle{
            id: buttonBackground
            anchors.fill: parent
            color: "lightgray"
            radius: 2
        }

        onTextChanged: GlobalDefinitions.layoutEdited()

        onPressed:{
            serialConnection.writeToSerial(eventName);
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: !button.enabled
    }

    ScaleKnob{
        root: root
        enabled: !button.enabled
    }

    RightClickEdit{
        root: root
        enabled: true
    }
}
