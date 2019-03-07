import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3

Item{
    id: root
    width: 200
    height: 30

    property string displayedName: qsTr("Balance Slider")
    property alias label: label.text
    property string eventName
    property alias orientation: slider.orientation
    property alias enabled: slider.enabled
    property alias showValue: currentValue.visible
    property var componentType: GlobalDefinitions.ComponentType.BalanceSlider
    property color componentColor: Material.color(Material.Indigo)
    onComponentColorChanged: setColor()

    Component.onCompleted: setColor()

    function setColor(){
        markedBackground.color = componentColor
        slider.handle.color = componentColor
    }

    Slider{
        id: slider
        anchors.fill: parent
        to: 100
        from: -100
        stepSize: 1
        enabled: false
        value: 0

        handle:Rectangle{
            x: slider.orientation === Qt.Horizontal ? parent.visualPosition * (parent.width - width) : (parent.width - width) / 2
            y: slider.orientation === Qt.Horizontal ? (parent.height - height) / 2 : parent.visualPosition * (parent.height - height)
            width: 20
            height: 20
            radius: 25
        }

        background: Rectangle {
            x: slider.orientation === Qt.Horizontal ? slider.leftPadding : (parent.width - width) / 2
            y: slider.orientation === Qt.Horizontal ? (parent.height - height) / 2 : slider.topPadding

            width: slider.orientation === Qt.Horizontal ? slider.width - slider.handle.width : 4
            height: slider.orientation === Qt.Horizontal ? 4 : slider.height - slider.handle.height
            radius: 2
            color: "lightgray"

            Rectangle {
                id: markedBackground
                property int middle: slider.orientation === Qt.Horizontal ? slider.x + slider.width * 0.5 : slider.y + slider.height * 0.5
                width: slider.orientation === Qt.Horizontal ? (slider.visualPosition > 0.5 ? slider.handle.x - middle : middle - slider.handle.x - slider.x) : 4
                x: slider.orientation === Qt.Horizontal ? slider.visualPosition > 0.5 ? middle : slider.handle.x : 0
                y: slider.orientation !== Qt.Horizontal ? slider.visualPosition > 0.5 ? middle : slider.handle.y : 0
                height: slider.orientation === Qt.Horizontal ? 4 : (slider.visualPosition > 0.5 ? slider.handle.y - middle : middle - slider.handle.y)
                radius: 2
            }
        }

        onPressedChanged: {
            if(!pressed)
                sliderValueAnimation.start()
        }

        NumberAnimation {
            id: sliderValueAnimation
            target: slider
            property: "value"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }

        Label{
            id: label
            height: 20
            text: qsTr("New Balance Slider")
            font.pointSize: 12
            anchors.bottom: parent.top
            anchors.left: parent.left
        }

        Label{
            id: currentValue
            text: parent.value.toFixed(0) + " / " + Math.abs(parent.value).toFixed(2) + "%"
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
        enabled: !slider.enabled
    }

    ScaleKnob{
        root: root
        enabled: !slider.enabled
    }

    RightClickEdit{
        root: root
        enabled: !slider.enabled
    }

    RotateKnob{
        root: root
        orientation: slider
        enabled: !slider.enabled
    }
}
