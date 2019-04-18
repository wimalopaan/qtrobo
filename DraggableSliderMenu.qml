import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

GridLayout{
    property var component
    columns: 2
    IntValidator{
        id: rangeValidator
    }

    Label{
        Layout.fillWidth: true
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

    Label{
        Layout.fillWidth: true
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

    Label{
        Layout.fillWidth: true
        text: qsTr("Show Value:")
    }

    CheckBox{
        checked:  component.showValue !== undefined ? component.showValue : false
        onCheckedChanged: component.showValue = checked
        Layout.fillWidth: true
    }

    Label{
        Layout.fillWidth: true
        text: qsTr("Map To Min Value:")
    }

    SpinBox{
        id: sliderMappedMinValue
        Layout.fillWidth: true
        from: rangeValidator.bottom
        to: rangeValidator.top
        value: component.mappedMinimumValue !== undefined ? component.mappedMinimumValue : 0
        editable: true
        onValueChanged: component.mappedMinimumValue = value
    }

    Label{
        Layout.fillWidth: true
        text: qsTr("Map To Max Value:")
    }

    SpinBox{
        id: sliderMappedMaxValue
        Layout.fillWidth: true
        from: rangeValidator.bottom
        to: rangeValidator.top
        value: component.mappedMaximumValue !== undefined ? component.mappedMaximumValue : 0
        editable: true
        onValueChanged: component.mappedMaximumValue = value
    }
}
