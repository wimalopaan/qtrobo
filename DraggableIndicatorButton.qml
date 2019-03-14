import QtQuick 2.0
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.12

Item{
    id: root
    width: 200
    height: 50

    property string displayedName: qsTr("Indicator Button")
    property string eventName
    property alias label: button.text
    property alias enabled: button.enabled
    property var componentType: GlobalDefinitions.ComponentType.IndicatorButton
    property color componentColor: "lightgray"
    property color fontColor: "black"
    property bool edible: true
    onEdibleChanged: enabled = !edible

    Button{
        id: button
        anchors.fill: parent
        text: qsTr("New Button")
        enabled: false
        font.pointSize: 12

        property bool isOn: false

        onPressed: serialConnection.writeToSerial(eventName, +isOn);

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
    }

    Connections{
        id: serialConnector
        target: serialConnection
        onDataChanged:{
            if(eventName === root.eventName && data){
                button.isOn = !!+data
            }
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
