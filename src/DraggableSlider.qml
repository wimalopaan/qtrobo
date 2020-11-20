import QtQuick 2.13
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
    property int mappedMinimumValue: slider.from
    property int mappedMaximumValue: slider.to
    property int initialValue: 0
    property bool isBalanced: false
    property string inputScript
    property string outputScript
    property string decreaseShortcut
    property string increaseShortcut

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.componentColor = origin.componentColor
        root.fontColor = origin.fontColor
        root.label = origin.label
        root.minimumValue = origin.minimumValue
        root.maximumValue = origin.maximumValue
        root.mappedMinimumValue = origin.mappedMinimumValue
        root.mappedMaximumValue = origin.mappedMaximumValue
        root.initialValue = origin.initialValue
        root.isBalanced = origin.isBalanced
        root.decreaseShortcut = origin.decreasedShortcut
        root.increaseShortcut = origin.increasedShortcut
    }

    onIsBalancedChanged: {
        markedBackgroundLoader.sourceComponent =  isBalanced ? balancedMarkedBackground : normalMarkedBackground
        if(isBalanced)
            sliderValueAnimation.start()
    }

    onEdibleChanged: enabled = !edible

    Slider{
        id: slider
        anchors.fill: parent
        to: 100
        from: 0
        stepSize: 1
        enabled: false

        Shortcut{
            sequence: decreaseShortcut
            onActivated: {
                if(slider.value - slider.stepSize > minimumValue)
                        slider.value = slider.value - slider.stepSize
            }
        }

        Shortcut{
            sequence: increaseShortcut
            onActivated: {
                if(slider.value + slider.stepSize < maximumValue)
                        slider.value = slider.value + slider.stepSize
            }
        }

        handle:Rectangle{
            id: handle
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
            width: slider.orientation === Qt.Horizontal ? slider.width - slider.handle.width + handle.width : 4
            height: slider.orientation === Qt.Horizontal ? 4 : slider.height - slider.handle.height + handle.height
            radius: 2
            color: "lightgray"

            Loader{
                id: markedBackgroundLoader
                sourceComponent: normalMarkedBackground
                Component{
                    id: normalMarkedBackground

                    Rectangle{
                        width: slider.orientation === Qt.Horizontal ? slider.handle.x - slider.x : 4
                        x: slider.orientation === Qt.Horizontal ? slider.x : 0
                        y: slider.orientation !== Qt.Horizontal ? slider.handle.y : 0
                        height: slider.orientation === Qt.Horizontal ? 4 : slider.height - slider.handle.y
                        color: componentColor
                    }
                }

                Component{
                    id: balancedMarkedBackground
                    Rectangle {
                        id: markedBackground
                        property int middle: slider.orientation === Qt.Horizontal ? slider.x + slider.width * 0.5 : slider.y + slider.height * 0.5
                        width: slider.orientation === Qt.Horizontal ? (slider.visualPosition > 0.5 ? slider.handle.x - middle : middle - slider.handle.x - slider.x) : 4
                        x: slider.orientation === Qt.Horizontal ? slider.visualPosition > 0.5 ? middle : slider.handle.x : 0
                        y: slider.orientation !== Qt.Horizontal ? slider.visualPosition > 0.5 ? middle : slider.handle.y : 0
                        height: slider.orientation === Qt.Horizontal ? 4 : (slider.visualPosition > 0.5 ? slider.handle.y - middle : middle - slider.handle.y)
                        radius: 2
                        color: componentColor
                    }
                }
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

        onPressedChanged: {
            if(isBalanced && !pressed)
                sliderValueAnimation.start()
        }

        NumberAnimation {
            id: sliderValueAnimation
            target: slider
            property: "value"
            to: slider.from + ((slider.to - slider.from) / 2)
            duration: 200
            easing.type: Easing.InOutQuad
        }

        onValueChanged: {
            var modifiedEvent = eventName
            var modifiedData = GlobalDefinitions.mapToValueRange(slider.value, slider.from, slider.to, mappedMinimumValue, mappedMaximumValue)
            if(outputScript){
                var result = qtRobo.connection.javascriptParser.runScript(modifiedEvent, modifiedData, outputScript)
                if(result.value)
                    modifiedData = result.value
                if(result.event)
                    modifiedEvent = result.event
            }
            qtRobo.connection.write(modifiedEvent, modifiedData)
        }
    }

    Connections{
        target: qtRobo.connection
        function onDataChanged(eventName, data){
            if(eventName === root.eventName && data){
                var receivedValue = +data
                slider.value = GlobalDefinitions.mapToValueRange(receivedValue, mappedMinimumValue, mappedMaximumValue, slider.from, slider.to)
            }
        }

        function onConnectionStateChanged(isConnected){
            if(isConnected && !isBalanced)
                slider.value = root.initialValue
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
