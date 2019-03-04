import QtQuick 2.9
import QtQuick.Controls 2.5

Item{
    id: root
    width: 200
    height: 50
    objectName: "DraggableButton"
    property string displayedName: qsTr("Button")
    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled

    Button{
        id: button
        anchors.fill: parent
        text: qsTr("New Button")
        enabled: false
        font.pointSize: 12

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
