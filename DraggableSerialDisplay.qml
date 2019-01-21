import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item{

    property alias text: displayName.text
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

        Text{
            id: displayName
            font.pointSize: 12
            text: qsTr("New Display")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextArea{
            id: textArea
            anchors.top: displayName.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
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
