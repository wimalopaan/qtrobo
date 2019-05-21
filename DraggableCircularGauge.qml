import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item{
    id: root
    width: 300
    height: 300

    property string eventName
    property string label: qsTr("New Circular Gauge")
    property alias enabled: layout.enabled
    property alias minimumValue: gauge.minimumValue
    property alias maximumValue: gauge.maximumValue
    property int mappedMinimumValue: gauge.minimumValue
    property int mappedMaximumValue: gauge.maximumValue
    property var componentType: GlobalDefinitions.ComponentType.CircularGauge
    property color fontColor: "black"
    property color componentColor: "black"
    property bool edible: true
    property bool mapToUnsigned: false
    onEdibleChanged: enabled = !edible

    GridLayout{
        id: layout
        enabled: false
        columns: 1
        anchors.fill: parent
        anchors.margins: 5

        Label{
            text: label
            color: fontColor
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 10
            font.pointSize: 12
        }

        CircularGauge{
            id: gauge
            Layout.fillHeight: true
            Layout.fillWidth: true

            style: CircularGaugeStyle{
                tickmarkStepSize: Math.abs(parent.maximumValue - parent.minimumValue) / 10
                tickmarkLabel: Text{
                    font.pixelSize: Math.max(6, outerRadius * 0.1)
                    text: styleData.value
                    color: fontColor
                    antialiasing: true
                }

                tickmark: Rectangle{
                    implicitWidth: outerRadius * 0.02
                    antialiasing: true
                    implicitHeight: outerRadius * 0.06
                    color: componentColor
                }

                minorTickmark: Rectangle {
                    implicitWidth: outerRadius * 0.01
                    antialiasing: true
                    implicitHeight: outerRadius * 0.03
                    color: componentColor
                }
            }

            Behavior on value{
                SmoothedAnimation{
                    velocity: 75
                }
            }
        }

        Connections{
            id: connection
            target: qtRobo.connection
            onDataChanged:{
                if(eventName === root.eventName && data){
                    var receivedValue = +data
                    gauge.value = GlobalDefinitions.mapToValueRange(receivedValue, mappedMinimumValue, mappedMaximumValue, gauge.minimumValue, gauge.maximumValue)
                }
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
