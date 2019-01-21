import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
    property alias displayText: textArea.text
    property string text
    property string eventName
    width: 300
    height: 150

    border.color: "lightgray"
    border.width: 2
    TextArea{
        id: textArea
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        font.family: "Monospaced"
        font.pointSize: 20
        enabled:  false

        Connections{
            target: serialConnection
            onDataChanged: textArea.text = data
        }
    }
}
