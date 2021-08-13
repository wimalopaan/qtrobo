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
    property string label: qsTr("New Windrose")
    property alias enabled: layout.enabled
    property double innerNeedleValue: 0
    property double outerNeedleValue: 0
    property var componentType: GlobalDefinitions.ComponentType.Windrose
    property color fontColor: "black"
    property color componentColor: "black"
    property color innerNeedleColor: "red"
    property color outerNeedleColor: "orange"
    property bool edible: true

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.componentColor = origin.componentColor
        root.fontColor = origin.fontColor
        root.label = origin.label
        root.minimumValue = origin.minimumValue
        root.maximumValue = origin.maximumValue

    }

    onInnerNeedleValueChanged: innerNeedleAnim.start()
    onOuterNeedleValueChanged: outerNeedleAnim.start()
    onInnerNeedleColorChanged: innerNeedle.requestPaint()
    onOuterNeedleColorChanged: outerNeedle.requestPaint()
    onComponentColorChanged: background.requestPaint()

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

        Canvas{
            id: background
            Layout.fillWidth: true
            Layout.fillHeight: true

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                const marker_width = 10;
                const x_middle = width/2;
                const y_middle = height/2;
                ctx.moveTo(x_middle, y_middle);
                for(var i = 0; i < 12; ++i){
                    var pos = (2 * Math.PI) * i / 12;
                    var x_outer = x_middle * Math.cos(pos);
                    var y_outer = y_middle * Math.sin(pos);
                    var x_inner = (x_middle - marker_width) * Math.cos(pos);
                    var y_inner = (y_middle - marker_width) * Math.sin(pos);

                    ctx.moveTo(x_middle + x_outer, y_middle + y_outer);
                    ctx.lineTo(x_middle + x_inner, y_middle + y_inner);
                    ctx.strokeStyle = componentColor;
                    ctx.stroke();
                }
            }

            Canvas{
                id: innerNeedle
                anchors.fill: parent
                property double needlePos
                property double needleLengthPercent: 100
                onNeedlePosChanged: requestPaint()
                onNeedleLengthPercentChanged: requestPaint()

                onPaint:{
                    var ctx = getContext("2d");
                    ctx.reset();
                    const marker_start = 30;
                    const x_middle = width/2;
                    const y_middle = height/2;
                    ctx.moveTo(x_middle, y_middle);
                    var pos = (2 * Math.PI) * needlePos / 1024 - Math.PI / 2;
                    var x_outer = (x_middle - marker_start) * Math.cos(pos);
                    var y_outer = (y_middle - marker_start) * Math.sin(pos);
                    var x_inner = (x_middle - marker_start - ((x_middle - marker_start) / 100 * needleLengthPercent)) * Math.cos(pos);
                    var y_inner = (y_middle - marker_start - ((y_middle - marker_start) / 100 * needleLengthPercent)) * Math.sin(pos);

                    ctx.moveTo(x_middle + x_outer, y_middle + y_outer);
                    ctx.lineTo(x_middle + x_inner, y_middle + y_inner);
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = innerNeedleColor;
                    ctx.stroke();
                }

                NumberAnimation {
                    id: innerNeedleAnim
                    target: innerNeedle
                    property: "needlePos"
                    from: innerNeedle.needlePos
                    to: innerNeedleValue
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    id: needleLengthAnim
                    target: innerNeedle
                    property: "needleLengthPercent"
                    duration: 2000
                    to: 100
                    easing.type: Easing.InOutQuad
                }
            }
            Canvas{
                id: outerNeedle
                anchors.fill: parent
                property double needlePos
                onNeedlePosChanged: requestPaint()
                onPaint:{
                    var ctx = getContext("2d");
                    ctx.reset();
                    const marker_width = 30;
                    const x_middle = width/2;
                    const y_middle = height/2;
                    ctx.moveTo(x_middle, y_middle);
                    var pos = (2 * Math.PI) * needlePos / 1024 - Math.PI / 2;
                    var x_outer = x_middle * Math.cos(pos);
                    var y_outer = y_middle * Math.sin(pos);
                    var x_inner = (x_middle - marker_width) * Math.cos(pos);
                    var y_inner = (y_middle - marker_width) * Math.sin(pos);

                    ctx.moveTo(x_middle + x_outer, y_middle + y_outer);
                    ctx.lineTo(x_middle + x_inner, y_middle + y_inner);
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = outerNeedleColor;
                    ctx.stroke();

                }
            }


            NumberAnimation {
                id: outerNeedleAnim
                target: outerNeedle
                property: "needlePos"
                from: outerNeedle.needlePos
                to: outerNeedleValue
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        Connections{
            id: connection
            target: qtRobo.connection
            function onDataChanged(eventName, data){
                if(eventName === root.eventName && data){
                    var nums = data.split(':', 3);
                    var innerNeedleNum = parseInt(nums[0]);
                    var outerNeedleNum = parseInt(nums[1]);
                    var innerNeedlePercentNum = parseInt(nums[2]);

                    if(!isNaN(innerNeedleNum) && !isNaN(outerNeedleNum) && !isNaN(innerNeedlePercentNum)){
                        innerNeedle.needlePos = innerNeedleNum;
                        outerNeedle.needlePos = outerNeedleNum;
                        innerNeedle.needleLengthPercent = Math.max(Math.min(innerNeedlePercentNum, 1024), 0) / 10.24;
                    }
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
