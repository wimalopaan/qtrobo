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

        Label{
            id: displayName
            font.pointSize: 12
            text: qsTr("New Display")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

        TextArea{
            id: textArea
            anchors.top: displayName.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            padding: 10
            font.family: "Monospaced"
            font.pointSize: 10
            readOnly: true

            Connections{
                id: serialListener
                target: serialConnection

                onDataChanged: textArea.text = Qt.formatTime(new Date(), "hh:mm:ss") + "\t" + data + "\n" + textArea.text

                Component.onDestruction: target = null
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: !display.enabled
    }

    ScaleKnob{
        root: root
        enabled: !display.enabled
    }

    RightClickEdit{
        root: root
        enabled: !display.enabled
    }
}
