import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle{
    property alias label: displayName.text
    property alias enabled: textArea.enabled
    property string eventName

    id: root
    width: 300
    height: 150
    objectName: "DraggableSerialDisplay"
    border.color: "lightgray"
    border.width: 2

    Label{
        id: displayName
        font.pointSize: 12
        text: qsTr("New Display")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
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
            readOnly: true

            background: Rectangle{
                anchors.fill: parent
                color: "lightgray"
            }


            Connections{
                id: serialListener
                target: serialConnection

                onDataChanged: {
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

                Component.onDestruction: target = undefined
            }
        }
    }
    DeleteComponentKnob{
        root: root
        enabled: !textArea.enabled
    }

    ScaleKnob{
        root: root
        enabled: !textArea.enabled
    }

    RightClickEdit{
        root: root
        enabled: !textArea.enabled
    }
}



