import QtQuick 2.9
import QtQuick.Controls 2.5

Item{
    id: root
    width: 200
    height: 50

    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled
    property var componentType: GlobalDefinitions.ComponentType.Button
    property alias componentColor: buttonBackground.color
    property color fontColor: "black"
    property bool edible: true
    onEdibleChanged: enabled = !edible

    Button{
        id: button
        anchors.fill: parent
        text: qsTr("New Button")
        enabled: false
        font.pointSize: 12

        property bool isPressed: false

        contentItem: Text{
            text: parent.text
            font: parent.font
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color: fontColor
        }

        background: Rectangle{
            id: buttonBackground
            anchors.fill: parent
            color: "lightgray"
            radius: 2

            Rectangle{
                anchors.fill: parent
                color: Qt.rgba(0.5, 0.5, 0.5, (button.isPressed ? 0.5 : 0))
            }
        }

        onTextChanged: GlobalDefinitions.layoutEdited()

        onPressed:{
            serialConnection.writeToSerial(eventName)
            isPressed = true
        }

        onReleased: isPressed = false

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
