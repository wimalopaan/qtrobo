import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    width: 200
    height: 100
    border.width: 2
    border.color: componentColor

    property string displayedName: qsTr("Dropdown")
    property string eventName
    property alias label: label.text
    property alias enabled: comboBox.enabled
    property alias comboBox: comboBox
    property alias model: comboBox.model
    property var componentType: GlobalDefinitions.ComponentType.Dropdown
    property color componentColor: "lightgray"
    property color fontColor: "black"

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 2

        Label{
            id: label
            text: qsTr("New Dropdown")
            font.pointSize: 12
            Layout.alignment: Layout.Center
            color: fontColor
        }

        ComboBox{
            id: comboBox
            enabled: false
            textRole: "entry"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 15
            background: Rectangle{
                id: comboBoxBackground
                color: componentColor
                anchors.fill: parent
            }

            contentItem: Text{
                color: fontColor
                text: parent.currentText
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: enabled ? 1.0 : 0.3
                elide: Text.ElideRight
            }

            model: ListModel{
                ListElement{
                    entry: "Entry 1"
                }
            }
            onCurrentIndexChanged: {
                if(eventName && eventName.length > 0)
                    serialConnection.writeToSerial(eventName, comboBox.currentIndex)
            }
        }
    }

    RightClickEdit{
        root: root
        enabled: !root.enabled
    }

    ScaleKnob{
        root: root
        enabled: !root.enabled
    }

    DeleteComponentKnob{
        root: root
        enabled: !root.enabled
    }
}
