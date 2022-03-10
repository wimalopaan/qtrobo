import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Timeline 1.0


Item{
    id: root
    width: 270
    height: 130

    property string eventName
    property string label: qsTr("New Speed Gauge")
    property int minimumValue: 0
    property int maximumValue: 100
    property int orientation: 1

    property int itemHeight: 130
    property int itemWidth: 270

    property var componentType: GlobalDefinitions.ComponentType.SpeedGauge
    property bool edible: true
    property string outputScript

    property alias speed1timelineCurrentFrame: speed1timeline.currentFrame
    property alias speed2TimelineCurrentFrame: speed2Timeline.currentFrame

    property int speed1ValueData: 0
    property int speed2ValueData: 0


    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.minimumValue = origin.minimumValue
        root.maximumValue = origin.maximumValue
        root.orientation = origin.orientation
    }



    onEdibleChanged: enabled = !edible
    onWidthChanged: {
        if (width <= 270){
            itemWidth = 270;
        }else{
            itemWidth = width;
        }
    }

    onHeightChanged: {
        if (height <= 130){
            itemHeight = 130;
        }else{
            itemHeight = height;
        }
    }


    Connections{
        id: connection
        target: qtRobo.connection
        function onDataChanged(eventName, data){
            if(eventName === root.eventName && data){
                var nums = data.split(':', 2);
                var isValue = parseInt(nums[0]);
                var shouldValue = parseInt(nums[1]);
                speed1ValueData = isValue;
                speed2ValueData = shouldValue;
                speed1timelineCurrentFrame = GlobalDefinitions.mapToValueRange(isValue,minimumValue,maximumValue,0,1000);
                speed2TimelineCurrentFrame = GlobalDefinitions.mapToValueRange(shouldValue,minimumValue,maximumValue,0,1000);
            }
        }

        Component.onDestruction: connection.target = null
    }


    Rectangle {
        id: speedgauge
        width: itemWidth
        height: itemHeight
        color: "#e1e6ed"

        border.width: 2
        rotation: if (root.orientation == 0){
                      return 270;
                  }else{
                      return 0;
                  }

        property int sv0 : root.minimumValue;
        property int sv1 : root.minimumValue + (root.maximumValue - root.minimumValue)/5;
        property int sv2 : root.minimumValue + ((root.maximumValue - root.minimumValue)/5)*2;
        property int sv3 : root.minimumValue + ((root.maximumValue - root.minimumValue)/5)*3;
        property int sv4 : root.minimumValue + ((root.maximumValue - root.minimumValue)/5)*4;
        property int sv5 : root.maximumValue;

        function calculateXOffset(value){
            var width = speedgauge.width - speedgauge.width * 0.3;
            if (root.orientation == 0){
                if (value === 0){
                    return -3;
                }else{
                    switch(value){
                    case sv0:
                        return - (Math.floor(Math.log10(Math.abs(speedgauge.sv0))) + 1)*3;
                    case sv1:
                        return width/5 - (Math.floor(Math.log10(Math.abs(speedgauge.sv1))) + 1)*3  ;
                    case sv2:
                        return (width/5)*2 - (Math.floor(Math.log10(Math.abs(speedgauge.sv2))) + 1)*3;
                    case sv3:
                        return (width/5)*3 - (Math.floor(Math.log10(Math.abs(speedgauge.sv3))) + 1)*3;
                    case sv4:
                        return (width/5)*4 -(Math.floor(Math.log10(Math.abs(speedgauge.sv4))) + 1)*3 ;
                    case sv5:
                        return width - (Math.floor(Math.log10(Math.abs(speedgauge.sv5))) + 1)*3;
                    }
                }

            }else{
                if (value === 0){
                    return -3;
                }else{
                    switch(value){
                    case sv0:
                        return - (Math.floor(Math.log10(Math.abs(speedgauge.sv0))) + 1)* speedgauge.width/100;
                    case sv1:
                        return width/5 - (Math.floor(Math.log10(Math.abs(speedgauge.sv1))) + 1)* speedgauge.width/100;
                    case sv2:
                        return (width/5)*2 - (Math.floor(Math.log10(Math.abs(speedgauge.sv2))) + 1)* speedgauge.width/100;
                    case sv3:
                        return (width/5)*3 - (Math.floor(Math.log10(Math.abs(speedgauge.sv3))) + 1)* speedgauge.width/100;
                    case sv4:
                        return (width/5)*4 - (Math.floor(Math.log10(Math.abs(speedgauge.sv1))) + 1)* speedgauge.width/100;
                    case sv5:
                        return width - (Math.floor(Math.log10(Math.abs(speedgauge.sv1))) + 1)* speedgauge.width/100;
                    }
                }
            }
        }




        Rectangle {
            id: speedbar1
            x: speedgauge.width * 0.03
            y: speedgauge.height/ 6 * 3
            width: parent.width - parent.width * 0.3
            height: 4
            color: "#000000"

            Rectangle {
                id: rectangle2
                x: 0
                y: -8
                width: 2
                height: 20

                color: "#ffffff"
            }

            Rectangle {
                id: rectangle3
                x: parent.width / 5
                y: -8
                width: 2
                height: 20

                color: "#ffffff"
            }

            Rectangle {
                id: rectangle4
                x: (parent.width/5)*2
                y: -8
                width: 2
                height: 20

                color: "#ffffff"
            }

            Rectangle {
                id: rectangle5
                x: (parent.width/5)*3
                y: -8
                width: 2
                height: 20

                color: "#ffffff"
            }

            Rectangle {
                id: rectangle6
                x: (parent.width/5)*4
                y: -8
                width: 2

                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: rectangle7
                x: parent.width
                y: -8
                width: 2
                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: speed1
                x: (parent.width/5) * 6
                width: parent.width/9 >= 30.0 ? 30.0 :parent.width/9
                height: parent.width/9 >= 30.0 ? 30.0 :parent.width/9
                rotation: speedgauge.rotation % 180

                color: "#00ffffff"
                radius: 100
                border.width: 1
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: spped1value
                    text: speed1ValueData
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    font.pixelSize: parent.width/3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            TriangleItem {
                id: triangle
                x: -5
                y: -12
                width:12
                height:12
                radius: 0
                strokeColor: "#00ff33"
                strokeWidth: 0
                rotation: 180
                fillColor: "#00ff33"
            }

            Rectangle {
                id: speedbar3
                x: 0
                y: 0
                width: speedgauge.width - speedgauge.width * 0.3
                height: 4
                color:"#00ff33"
            }

        }

        Rectangle {
            id: speedbar2
            x: speedgauge.width * 0.03
            y: speedgauge.height/ 6 * 4.5
            width: parent.width - parent.width * 0.3
            height: 4

            color: "#000000"
            Rectangle {
                id: rectangle8
                x: 0
                y: -8
                width: 2
                height: 20

                color: "#ffffff"
            }

            Rectangle {
                id: rectangle9
                x: parent.width/ 5
                y: -8
                width: 2

                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: rectangle10
                x: (parent.width/ 5)
                y: -8
                width: 2

                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: rectangle11
                x: (parent.width/ 5)*2
                y: -8
                width: 2
                height: 20

                color: "#ffffff"
            }

            Rectangle {
                id: rectangle12
                x: (parent.width/ 5)*3
                y: -8
                width: 2

                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: rectangle13
                x: (parent.width/ 5)*4
                y: -8
                width: 2
                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: rectangle23
                x: parent.width
                y: -8
                width: 2
                height: 20
                color: "#ffffff"
            }

            Rectangle {
                id: speed2
                x: (parent.width/ 5)*6
                width: parent.width/9 >= 30 ? 30 :parent.width/9
                height: parent.width/9 >= 30 ? 30 :parent.width/9
                color: "#00ffffff"
                radius: 100
                border.width: 1
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: speed2value
                    text: speed2ValueData
                    anchors.fill: parent
                    rotation: speedgauge.rotation % 180
                    font.pixelSize: parent.width/3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            TriangleItem {
                id: triangle1
                x: -5
                y: 5
                width: 12
                height: 12
                radius: 0
                strokeColor: "#ffa700"
                strokeWidth: 0
                rotation: 0
                fillColor: "#ffa700"
            }
            Rectangle {
                id: speedbar4
                x: 0
                y: 0
                width: speedgauge.width - speedgauge.width * 0.3
                height: 4
                color:"#ffa700"
            }

        }

        Rectangle {
            id: rectangle
            x: speedgauge.width * 0.03
            y: speedgauge.height/6
            width: speedgauge.width - speedgauge.width * 0.3
            height: 4
            color: "#00ffffff"

            Text {
                id: speedvalue1
                x: {speedgauge.calculateXOffset(speedgauge.sv0);}
                y: 0
                width: 13
                text: speedgauge.sv0
                rotation: speedgauge.rotation % 180
                font.pixelSize: speedgauge.width * 0.05 >= 15 ? 15 : speedgauge.width * 0.05
            }

            Text {
                id: speedvalue2
                x: {speedgauge.calculateXOffset(speedgauge.sv1);}
                y: 0
                text: speedgauge.sv1
                rotation:speedgauge.rotation % 180
                font.pixelSize: speedgauge.width * 0.05 >= 15 ? 15 : speedgauge.width * 0.05
            }

            Text {
                id: speedvalue3
                x: {speedgauge.calculateXOffset(speedgauge.sv2);}
                y: 0
                text: speedgauge.sv2
                rotation: speedgauge.rotation % 180
                font.pixelSize: speedgauge.width * 0.05 >= 15 ? 15 : speedgauge.width * 0.05
            }

            Text {
                id: speedvalue4
                x: {speedgauge.calculateXOffset(speedgauge.sv3);}
                y: 0
                text: speedgauge.sv3
                rotation: speedgauge.rotation % 180
                font.pixelSize: speedgauge.width * 0.05 >= 15 ? 15 : speedgauge.width * 0.05
            }

            Text {
                id: speedvalue5
                x: {speedgauge.calculateXOffset(speedgauge.sv4);}
                y: 0
                rotation: speedgauge.rotation % 180
                text: speedgauge.sv4
                font.pixelSize: speedgauge.width * 0.05 >= 15 ? 15 : speedgauge.width * 0.05
            }

            Text {
                id: speedvalue6
                x: {speedgauge.calculateXOffset(speedgauge.sv5);}
                y: 0
                rotation: speedgauge.rotation % 180
                text: speedgauge.sv5
                font.pixelSize: speedgauge.width * 0.05 >= 15 ? 15 : speedgauge.width * 0.05
            }
        }
    }

    Timeline {
        id: speed1timeline
        animations: [
            TimelineAnimation {
                id: speed1Animation
                loops: 1
                running: false
                duration: 1000
                to: 1000
                from: 0
            }
        ]
        startFrame: 0
        enabled: true
        endFrame: 1000

        KeyframeGroup {
            target: triangle
            property: "x"
            Keyframe {
                frame: 0
                value: -5
            }

            Keyframe {
                frame: 1000
                value: speedgauge.width - speedgauge.width * 0.3 - 5
            }
        }

        KeyframeGroup {
            target: speedbar3
            property: "width"
            Keyframe {
                frame: 1000
                value: speedgauge.width - speedgauge.width * 0.3
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

    }

    Timeline {
        id: speed2Timeline
        animations: [
            TimelineAnimation {
                id: speed2Animation
                loops: 1
                running: false
                duration: 1000
                to: 1000
                from: 0
            }
        ]
        startFrame: 0
        enabled: true
        endFrame: 1000

        KeyframeGroup {
            target: triangle1
            property: "x"
            Keyframe {
                frame: 0
                value: -5
            }

            Keyframe {
                frame: 1000
                value: speedgauge.width - speedgauge.width * 0.3 - 5
            }
        }

        KeyframeGroup {
            target: speedbar4
            property: "width"
            Keyframe {
                frame: 1000
                value: speedgauge.width - speedgauge.width * 0.3
            }

            Keyframe {
                frame: 0
                value: 0
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
}
