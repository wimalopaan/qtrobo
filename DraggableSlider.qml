import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3

Item{
    id: root
    width: 200
    height: 30

    property alias label: label.text
    property string eventName
    property alias enabled: slider.enabled
    property alias orientation: slider.orientation
    property alias minimumValue: slider.from
    property alias maximumValue: slider.to
    property alias showValue: currentValue.visible
    property var componentType: GlobalDefinitions.ComponentType.Slider
    property color componentColor: Material.color(Material.Indigo)
    property color fontColor: "black"
    property bool edible: true
    onEdibleChanged: enabled = !edible

    Slider{
        id: slider
        anchors.fill: parent
        to: 100
        from: 0
        stepSize: 1
        enabled: false

        handle:Rectangle{
            x: slider.orientation === Qt.Horizontal ? parent.visualPosition * (parent.width - width) : (parent.width - width) / 2
            y: slider.orientation === Qt.Horizontal ? (parent.height - height) / 2 : parent.visualPosition * (parent.height - height)
            width: 20
            height: 20
            radius: 25
            color: componentColor
        }

        background: Rectangle {
            x: slider.orientation === Qt.Horizontal ? 0 : (parent.width - width) / 2
            y: slider.orientation === Qt.Horizontal ? (parent.height - height) / 2 : 0
            width: slider.orientation === Qt.Horizontal ? slider.width - slider.handle.width : 4
            height: slider.orientation === Qt.Horizontal ? 4 : slider.height - slider.handle.height
            radius: 2
            color: "lightgray"

            Rectangle {
                id: markedBackground
                width: slider.orientation === Qt.Horizontal ? slider.visualPosition * parent.width : parent.width
                height: slider.orientation === Qt.Horizontal ? parent.height : parent.height - (parent.height * slider.visualPosition)
                y: slider.orientation === Qt.Horizontal ? 0 : (parent.y + parent.height) * slider.visualPosition
                radius: 2
                color: componentColor
            }
        }

        Label{
            id: label
            height: 20
            text: qsTr("New Slider")
            font.pointSize: 12
            color: fontColor
            anchors.bottom: parent.top
            anchors.left: parent.left
        }

        Label{
            id: currentValue
            text: parent.value + " / " + ((parent.value + Math.abs(parent.from)) / (parent.to - parent.from) * 100).toFixed(2) + "%"
            color: fontColor
            anchors.top: parent.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        onValueChanged: serialConnection.writeToSerial(eventName, value)
    }

    Connections{
        target: serialConnection
        onDataChanged:{
            if(eventName === root.eventName && data){
                slider.value = +data
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

    RotateKnob{
        root: root
        orientation: slider
        enabled: root.edible
    }
}
