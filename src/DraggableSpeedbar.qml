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
    width: 239
    height: 80

    property string eventName
    property string label: qsTr("New Speedbar")
    property int minimumValue: 0
    property int maximumValue: 100

    property int itemHeight: 80
    property int itemWidth: 239

    property var componentType: GlobalDefinitions.ComponentType.Speedbar
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
    onWidthChanged: itemWidth = width
    onHeightChanged: itemHeight = height


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
        id: rectangle
        width: itemWidth
        height: itemHeight
        color: "#ffffff"
        radius: 0
        border.width: 2

        Rectangle {
            id: speedanimationvalue1
            x: 2
            y: 2
            width: parent.width * 0.8
            height:parent.height/2 -2
            color: "#ffffff"
            border.width: 0

            Rectangle {
                id: speedvalue1
                x: parent.width
                y: 0
                width: itemWidth * 0.2
                height: parent.height
                opacity: 0.5
                color: "#ffffff"
                border.width: 0

                Text {
                    id: text1
                    text: speed1Value
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: speedbar3
                x: 0
                y: 0
                width: speed1Frame
                height: itemHeight/2-2
                color: "#00ff33"
            }
        }

        Rectangle {
            id: speedanimationvalue2
            x: 2
            y: itemHeight/2
            width: parent.width * 0.8
            height:parent.height/2 -2
            color: "#ffffff"
            border.width: 0
            Rectangle {
                id: speedvalue2
                x: parent.width
                y: 0
                width: itemWidth * 0.2
                height: parent.height
                opacity: 0.5
                color: "#ffffff"
                border.width: 0

                Text {
                    id: text2
                    text: speed2Value
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: speedbar2
                x: 0
                y: 0
                width: speed2Frame
                height: itemHeight/2-2
                color: "#ffa700"
                border.width: 0
                scale: 1
            }
        }
    }





    Timeline {
        id: speed1
        animations: [
            TimelineAnimation {
                id: speedanimation1
                duration: 1000
                loops: 1
                running: false
                to: 1000
                from: 0
            }
        ]
        enabled: true
        //endFrame: 1000
        //startFrame: 0

        KeyframeGroup {
            target: speedbar3
            property: "width"
            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                value: itemWidth * 0.8
                frame: 1000
            }
        }
    }

    Timeline {
        id: speed2
        animations: [
            TimelineAnimation {
                id: speedanimation2
                duration: 1000
                loops: 1
                running: false
                to: 1000
                from: 0
            }
        ]
        enabled: true
        //startFrame: 0
        //endFrame: 1000

        KeyframeGroup {
            target: speedbar2
            property: "width"
            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                frame: 1000
                value: itemWidth *0.8
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
