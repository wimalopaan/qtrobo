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
    width: itemSize
    height: itemSize

    property string eventName
    property string label: qsTr("New Circular Speedbar")
    property int minimumValue: 0
    property int maximumValue: 100

    property var componentType: GlobalDefinitions.ComponentType.CircularSpeedbar
    property bool edible: true
    property string outputScript

    property alias speed2Frame: speed2.currentFrame
    property alias speed1Frame: speed1.currentFrame

    property int speed1Value: 0
    property int speed2Value: 0

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.minimumValue = origin.minimumValue
        root.maximumValue = origin.maximumValue
    }

    onEdibleChanged: enabled = !edible
    property int itemSize: 230

    onHeightChanged: itemSize = height
    onWidthChanged: itemSize = width


    Connections{
        id: connection
        target: qtRobo.connection
        function onDataChanged(eventName, data){
            if(eventName === root.eventName && data){
                var nums = data.split(':', 2);
                var isValue = parseInt(nums[0]);
                var shouldValue = parseInt(nums[1]);
                speed1Value = isValue;
                speed2Value = shouldValue;
                speed1Frame = GlobalDefinitions.mapToValueRange(isValue,minimumValue,maximumValue,0,1000);
                speed2Frame = GlobalDefinitions.mapToValueRange(shouldValue,minimumValue,maximumValue,0,1000);
            }
        }

        Component.onDestruction: connection.target = null
    }


    Rectangle {
        id: rectangle1
        width: itemSize
        height: itemSize

        opacity: 1.0
        color: "#0000ffff"



        ArcItem {
            id: arc
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            rotation: 0
            strokeColor: "#00ff33"
            strokeWidth: 12
            begin: 200
            end: 520
            roundBegin: false
            outlineArc: false
            fillColor: "#00000000"

            ArcItem {
                id: arc1
                x: 12
                y: 12
                width: parent.width - 24
                height: parent.height - 24
                strokeColor: "#ffa700"
                strokeWidth: 12

                end: 520
                begin: 200
                fillColor: "#00000000"
            }

            Rectangle {
                id: rectangle
                x: 24
                y: 24
                width: parent.width - 46
                height: parent.height - 46
                color: "#000000"
                radius: parent.width/2
                border.color: "#ffffff"
                border.width: 2

                Rectangle {
                    id: rectangle4
                    x: parent.width * 0.25
                    y: parent.height / 2
                    width: parent.width * 0.5
                    height: parent.height * 0.03
                    color: "#ffffff"
//                    strokeWidth: 0
                }

                RectangleItem {
                    id: rectangle7
                    x: parent.width * 0.25
                    y: parent.height * 0.6
                    width: parent.width * 0.5
                    height: parent.height * 0.25
                    strokeWidth: -1
                    fillColor: "#0000ffff"

                    Text {
                        id: text2
                        color: "#ffa700"
                        text: speed2Value
                        anchors.fill: parent
                        font.pixelSize: itemSize/6
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                RectangleItem {
                    id: rectangle2
                    x: parent.width * 0.25
                    y: parent.height * 0.2
                    width: parent.width * 0.5
                    height: parent.height * 0.25
                    strokeWidth: -1
                    fillColor: "#0000ffff"

                    Text {
                        id: text1
                        color: "#00ff33"
                        text: speed1Value
                        anchors.fill: parent
                        font.pixelSize: itemSize/6
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    Timeline {
        id: speed1
        animations: [
            TimelineAnimation {
                id: speed1Animation
                loops: 1
                duration: 1000
                running: false
                to: 1000
                from: 0
            }
        ]
        enabled: true
//        startFrame: 0
//        endFrame: 1000

        KeyframeGroup {
            target: arc
            property: "end"
            Keyframe {
                value: 200
                frame: 0
            }

            Keyframe {
                value: 520
                frame: 1000
            }
        }
    }

    Timeline {
        id: speed2
        animations: [
            TimelineAnimation {
                id: speed2Animation
                loops: 1
                duration: 1000
                running: false
                to: 1000
                from: 0
            }
        ]
        enabled: true
//        startFrame: 0
//        endFrame: 1000

        KeyframeGroup {
            target: arc1
            property: "end"
            Keyframe {
                value: 200
                frame: 0
            }

            Keyframe {
                value: 520
                frame: 1000
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
