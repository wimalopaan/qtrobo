import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle{
    id: root
    width: 200
    height: 100
    border.width: 2
    border.color: componentColor

    property string eventName
    property alias label: label.text
    property alias enabled: spinbox.enabled
    property var componentType: GlobalDefinitions.ComponentType.Spinbox
    property color componentColor: "lightgray"
    property color fontColor: "black"
    property alias minimumValue: spinbox.from
    property alias maximumValue: spinbox.to
    property bool edible: true
    onEdibleChanged: enabled = !edible

    ColumnLayout{
        anchors.fill: parent

        Text{
            id: label
            text: qsTr("New Spinbox")
            font.pointSize: 12
            Layout.alignment: Layout.Center
            color: fontColor
        }

        SpinBox{
            id: spinbox
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            enabled: false
            editable: true
            from: 0
            to: 100
            contentItem: TextInput{
                z:2
                text: parent.textFromValue(parent.value, parent.locale)
                font: parent.font
                color: fontColor
                opacity: enabled ? 1.0 : 0.3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                readOnly: !parent.editable
                validator: parent.validator
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }

            up.indicator: Rectangle{
                x: parent.mirrored ? 0 : parent.width - width
                height: parent.height
                implicitWidth: 40
                implicitHeight: 40
                color: componentColor
                opacity: enabled ? 1.0 : 0.3
                border.color: parent.up.pressed ? "gray" : "black"

                Text {
                    text: "+"
                    font.pixelSize: spinbox.font.pixelSize * 2
                    color: fontColor
                    opacity: spinbox.up.pressed ? 0.5 : 1.0
                    anchors.fill: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            down.indicator: Rectangle {
                x: parent.mirrored ? parent.width - width : 0
                height: parent.height
                implicitWidth: 40
                implicitHeight: 40
                color: componentColor
                opacity: enabled ? 1.0 : 0.3
                border.color: parent.down.pressed ? "gray" : "black"

                Text {
                    text: "-"
                    font.pixelSize: spinbox.font.pixelSize * 2
                    color: fontColor
                    opacity: spinbox.down.pressed ? 0.5 : 1.0
                    anchors.fill: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            background: Rectangle{
                anchors.fill: parent
                color: componentColor
            }

            onValueChanged: {
                if(eventName && eventName.length > 0)
                    serialConnection.writeToSerial(eventName, value)
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }

    RightClickEdit{
        root: root
        enabled: root.edible
    }

    ScaleKnob{
        root: root
        enabled: root.edible
    }
}
