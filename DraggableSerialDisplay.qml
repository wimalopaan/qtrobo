import QtQuick 2.0
import QtQuick.Controls 2.5

Item{
    property alias displayText: textArea.text
    property alias enabled: display.enabled
    property string eventName

    id: root
    width: 300
    height: 150

    Rectangle{
        id: display
        anchors.fill: parent
        enabled: false
        border.color: "lightgray"
        border.width: 2
        TextArea{
            id: textArea
            anchors.fill: parent
            padding: 10
            font.family: "Monospaced"
            font.pointSize: 20
            enabled:  false

            Connections{
                target: serialConnection
                onDataChanged: textArea.text = data;
            }
        }
    }

    ScaleKnob{
        root: root
        enabled: !display.enabled
    }
}
