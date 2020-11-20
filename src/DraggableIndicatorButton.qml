import QtQuick 2.13
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.12

Item{
    id: root
    width: 200
    height: 50

    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled
    property var componentType: GlobalDefinitions.ComponentType.IndicatorButton
    property color componentColor: "lightgray"
    property color fontColor: "black"
    property bool edible: true
    property bool initialValue: false
    property string shortcut

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.componentColor = origin.componentColor
        root.fontColor = origin.fontColor
        root.label = origin.label
        root.initialValue = origin.initialValue
        root.shortcut = origin.shortcut
    }

    onEdibleChanged: enabled = !edible

    Button{
        id: button
        anchors.fill: parent
        text: qsTr("New Button")
        enabled: false
        font.pointSize: 12
        property bool isOn: false
        property bool isPressed: false

        onPressed: {
            qtRobo.connection.write(eventName, +isOn)
            isPressed = true
        }

        onReleased: isPressed = false

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
            anchors.fill: parent
            color: componentColor
            radius: 2

            Rectangle{
                anchors.fill: parent
                color: Qt.rgba(0.5, 0.5, 0.5, (button.isPressed ? 0.5 : 0))
                radius: 2
            }
        }


        RadialGradient{
            width: parent.width/10
            height: parent.height / 5
            anchors.right: parent.right
            anchors.margins: width
            anchors.verticalCenter: parent.verticalCenter

            gradient: Gradient{
                GradientStop{position: 0.0; color: button.isOn ? "red" : Qt.rgba(0.5, 0.2, 0.2, 0.6)}
                GradientStop{position: 1; color: Qt.rgba(0.4, 0.0, 0.0, 1)}
            }

        }

        PropertyAnimation{id: changeAnimation; duration: 100; target: button; property:"isPressed"; from: true; to: false}
        Shortcut{
            sequence: shortcut
            onActivated: qtRobo.connection.write(eventName, +isOn)
        }

    }

    Connections{
        id: serialConnector
        target: qtRobo.connection
        function onDataChanged(eventName, data){
            if(eventName === root.eventName && data){
                button.isOn = !!+data
            }
        }

        function onConnectionStateChanged(isConnected){
            if(isConnected)
                button.isOn = root.initialValue
        }

        Component.onDestruction: serialConnector.target = null
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
