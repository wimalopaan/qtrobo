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
    property int numberOfValues: 10
    property alias maxYAxis: yAxis.max
    property bool isFixed: false
    property string inputScript

    onNumberOfValuesChanged: {
        while(series.count > numberOfValues)
            series.remove(0)
    }

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
            useOpenGL: true
            property int lastYAxisAutoMax

            function addValue(y){

                if(count > Math.abs(xAxis.min))
                    series.remove(0)

                for(var i = 0; i < count; ++i){
                    replace(series.at(i).x, series.at(i).y, series.at(i).x - 1, series.at(i).y)
                }

                series.append(0, y)

                if(y > yAxis.max){
                    lastYAxisAutoMax = Math.ceil(y)
                }

                if(!isFixed)
                    yAxis.max = lastYAxisAutoMax
            }

            axisX: ValueAxis{
                id: xAxis
                min: numberOfValues * -1
                max: 0
                tickCount: 5
                minorTickCount: 5
                gridLineColor: "gray"
                minorGridLineColor: "lightgray"
                labelFormat: "%i"
                labelsColor: fontColor

                onMinChanged: applyNiceNumbers()
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
        target: qtRobo.connection
        onDataChanged: {
            if(eventName && root.eventName === eventName){
                var parsedVal = parseInt(data)
                if(!isNaN(parsedVal)){
                    var result = qtRobo.connection.javascriptParser.runScript(eventName, parsedVal, outputScript)
                    if(result.value)
                        parsedVal = result.value
                    series.addValue(parsedVal)
                }
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
