import QtQuick 2.9
import QtQuick.Controls 2.5
import QtCharts 2.3
import QtQuick.Layouts 1.3

Item{
    id: root
    width: 300
    height: 300

    property string eventName
    property alias label: series.name
    property alias enabled: chart.enabled
    property var componentType: GlobalDefinitions.ComponentType.Chart
    property alias componentColor: series.color
    property color fontColor: "black"
    property bool edible: true
    onEdibleChanged: enabled = !edible

    ChartView{
        id: chart
        anchors.fill: parent
        antialiasing: true
        enabled: false


        LineSeries{
            id: series
            property int counter: 0

            function addValue(y){
                series.append(counter++, y)
                if(y > yAxis.max)
                    yAxis.max = Math.ceil(y)
            }

            onCountChanged: {
                if(count > xAxis.max + 1){
                    xAxis.min++;
                    xAxis.max++;
                }
                count
            }

            axisX: ValueAxis{
                id: xAxis
                min: 0
                max: 10
                tickCount: 10
                gridLineColor: "gray"
                labelFormat: "%i"
                labelsColor: fontColor
            }

            axisY: ValueAxis{
                id: yAxis
                gridLineColor: "gray"
                labelsColor: fontColor
                min: 0
                max: 1
            }
        }
    }

    Connections{
        id: connection
        target: serialConnection
        onDataChanged: {
            console.log(data)
            if(eventName && root.eventName === eventName){
                var parsedVal = parseInt(data)
                if(!isNaN(parsedVal))
                    series.addValue(parsedVal)
            }
        }

        Component.onDestruction: connection.target = null
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
