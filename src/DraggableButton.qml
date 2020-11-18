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
    property string outputScript
    property string shortcut

    onEdibleChanged: enabled = !edible

    Button{
        id: button
        anchors.fill: parent
        text: qsTr("New Button")
        enabled: false
        font.pointSize: 12

        property bool isPressed: false
        onPressed:{
//            onIsPressedChanged:{
            isPressed = true
            var modifiedEvent = eventName
            var modifiedData = null
            if(outputScript){
                var result = qtRobo.connection.javascriptParser.runScript(modifiedEvent, modifiedData, outputScript)
                if(result.value)
                    modifiedData = result.value
                if(result.event)
                    modifiedEvent = result.event
            }
            if(modifiedData)
                qtRobo.connection.write(modifiedEvent, modifiedData)
            else
                qtRobo.connection.write(modifiedEvent)
        }

        PropertyAnimation{id: changeAnimation; duration: 100; target: button; property:"isPressed"; from: true; to: false}
        Shortcut{
            sequence: shortcut
            onActivated: {
                button.isPressed = true
                changeAnimation.running = true
            }
        }

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

        onTextChanged: GlobalDefinitions.projectEdited()

//        onPressed: isPressed = true
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
