import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Dialog{
    id: root
    focus: true
    implicitWidth: 350
    closePolicy: Qt.CloseOnPressOutside
    title: qsTr("Control Preferences")

    property var component

    contentItem:  ColumnLayout{
        id: layout

        //------ General
        RowLayout{

            Text{
                text: "Control Name:"
                Layout.minimumWidth: layout.width / 2
            }

            TextField{
                Layout.fillWidth: true
                text: component.label

                onTextChanged: component.label = text
            }
        }

        RowLayout{
            Text{
                text: "Event Name:"
                Layout.minimumWidth: layout.width / 2
            }

            TextField{
                Layout.fillWidth: true
                text: component.eventName

                onTextChanged: component.eventName = text
            }

        }

        //----- Slider

        IntValidator{
            id: rangeValidator
        }

        RowLayout{
            visible: (component instanceof DraggableSlider)
            Text{
                Layout.minimumWidth: layout.width / 2
                text: qsTr("Min Value:")
            }

            SpinBox{
                id: sliderMinValue
                Layout.fillWidth: true
                from: rangeValidator.bottom
                to: rangeValidator.top
                value: component.minimumValue !== undefined ? component.minimumValue : 0
                editable: true
                onValueChanged:{
                    value = value > sliderMaxValue.value ? sliderMaxValue.value : value
                    component.minimumValue = value
                }

            }
        }

        RowLayout{
            visible: (component instanceof DraggableSlider)
            Text{
                Layout.minimumWidth: layout.width / 2
                text: qsTr("Max Value:")
            }

            SpinBox{
                id: sliderMaxValue
                Layout.fillWidth: true
                from: rangeValidator.bottom
                to: rangeValidator.top
                value: component.maximumValue !== undefined ? component.maximumValue : 0
                editable: true
                onValueChanged: {
                    value = value < sliderMinValue.value ? sliderMinValue.value : value
                    component.maximumValue = value
                }
            }
        }

        RowLayout{
            visible: (component instanceof DraggableSlider || component instanceof DraggableBalanceSlider)
            Text{
                Layout.minimumWidth: layout.width / 2
                text: "Show Value:"
            }

            CheckBox{
                checked:  component.showValue !== undefined ? component.showValue : false
                onCheckedChanged: component.showValue = checked
            }
        }

        Keys.onReturnPressed: root.accept()
    }
}
