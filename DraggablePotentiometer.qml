import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.12
import QtQuick.Extras 1.4
import QtGraphicalEffects 1.0

Item{
    id: root
    width: 100
    height: 100

    property string eventName
    property string label: qsTr("New Potentiometer")
    property alias enabled: potentiometer.enabled
    property alias minimumValue: potentiometer.minimumValue
    property alias maximumValue: potentiometer.maximumValue
    property int mappedMinimumValue: minimumValue
    property int mappedMaximumValue: maximumValue
    property var componentType: GlobalDefinitions.ComponentType.Potentiometer
    property bool edible: true
    property color fontColor: "gray"
    property color componentColor: "lightgray"
    property int initialValue: 0
    property string outputScript

    onEdibleChanged: enabled = !edible

    Dial{
        id: potentiometer
        anchors.fill: parent
        enabled: false
        minimumValue: 0
        maximumValue: 100
        stepSize: 1

        property var scaleFactor: (root.width < root.height ? root.width / 100 : root.height / 100)

        Label{
            anchors.bottom: parent.top
            anchors.bottomMargin: 20 * parent.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: root.fontColor
            font.pointSize: 12
        }

        Label{
            anchors.centerIn: parent
            text: parent.value
            visible: parent.pressed
            font.pointSize: 10 * parent.scaleFactor
            color: root.fontColor
        }


        style: DialStyle{
            tickmark: Rectangle{
                width: 1 * potentiometer.scaleFactor
                height: 6 * potentiometer.scaleFactor
                radius: 5
                color: root.fontColor
            }

            background: Rectangle{
                anchors.fill: parent
                anchors.margins: 8 * potentiometer.scaleFactor
                radius: (width < height ? width: height) * 0.5

                color: "darkgray"
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 1 * potentiometer.scaleFactor
                    gradient: Gradient{
                        GradientStop{position: 0.0; color: root.componentColor}
                        GradientStop{position: 1.0; color: Qt.rgba(root.componentColor.r, root.componentColor.g, root.componentColor.b, 0.5)}
                    }

                    radius: (width < height ? width: height) * 0.5
                }
            }

            labelInset: -10 * potentiometer.scaleFactor
            tickmarkLabel: Label{
                text: styleData.value
                font.pointSize: 6 * potentiometer.scaleFactor
                color:  root.fontColor
            }

            labelStepSize: Math.abs(parent.maximumValue - parent.minimumValue) / 10

            tickmarkStepSize: Math.abs(parent.maximumValue - parent.minimumValue) / 10
        }

        onValueChanged: {
            if(eventName && pressed){
                var modifiedEvent = eventName
                var modifiedData = GlobalDefinitions.mapToValueRange(potentiometer.value, root.minimumValue, root.maximumValue, root.mappedMinimumValue, root.mappedMaximumValue)
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
            id: connection
            target: qtRobo.connection
            onDataChanged:{
                if(eventName === root.eventName && data){
                    var receivedValue = +data
                    potentiometer.value = GlobalDefinitions.mapToValueRange(receivedValue, root.mappedMinimumValue, root.mappedMaximumValue, root.minimumValue, root.maximumValue)
                }
            }

            onConnectionStateChanged:{
                if(isConnected)
                    potentiometer.value = root.initialValue
            }

            Component.onDestruction: connection.target = null
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
