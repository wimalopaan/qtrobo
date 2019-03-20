import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

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
}
