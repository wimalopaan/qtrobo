import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle{
    id: root
    width: 200
    height: 100
    objectName: "DraggableSpinbox"
    border.width: 2
    border.color: "lightgray"
    property string displayedName: qsTr("Spinbox")
    property string eventName
    property alias label: label.text
    property alias enabled: spinbox.enabled

    IntValidator{
        id: rangeValidator
    }

    ColumnLayout{
        anchors.fill: parent

        Text{
            id: label
            text: qsTr("New Spinbox")
            Layout.alignment: Layout.Center
        }

        SpinBox{
            id: spinbox
            Layout.fillWidth: true
            enabled: false
            editable: true
            from: rangeValidator.bottom
            to: rangeValidator.top

            onValueChanged: {
                if(eventName && eventName.length > 0)
                    serialConnection.writeToSerial(eventName, value)
            }
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: !root.enabled
    }

    RightClickEdit{
        root: root
        enabled: !root.enabled
    }

    ScaleKnob{
        root: root
        enabled: !root.enabled
    }
}
