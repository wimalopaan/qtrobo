import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle{
    id: root
    width: 300
    height: 150
    border.color: componentColor
    border.width: 2

    property alias label: displayName.text
    property alias enabled: textArea.enabled
    property string eventName
    property var componentType: GlobalDefinitions.ComponentType.SerialDisplay
    property color componentColor: "lightgray"
    property color fontColor: "black"
    property bool edible: true
    onEdibleChanged: enabled = !edible

    Label{
        id: displayName
        font.pointSize: 12
        text: qsTr("New Display")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: fontColor
    }

    ScrollView{
        padding: 6
        width: root.width
        anchors.horizontalCenter: parent.horizontalCenter
        height: root.height - displayName.height
        anchors.bottom: root.bottom


        TextArea{
            id: textArea
            anchors.fill: parent
            enabled: false
            padding: 10
            font.family: "Monospaced"
            font.pointSize: 10
            color: fontColor
            readOnly: true

            background: Rectangle{
                anchors.fill: parent
                color: componentColor
            }


            Connections{
                id: serialListener
                target: qtRobo.connection

                function onDataChanged(eventName, data){
                    var newTextLine = "[" + Qt.formatTime(new Date(), "hh:mm:ss")
                    newTextLine += "]\t"
                    if(eventName){
                        newTextLine += eventName + "->"
                    }

                    newTextLine += data + "\n"

                    if(root.eventName){
                        if(root.eventName === eventName)
                            textArea.append(newTextLine)
                    }else{
                        textArea.append(newTextLine)
                    }
                }

                Component.onDestruction: serialListener.target = null
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



