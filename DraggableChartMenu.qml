import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

GridLayout{
    property var component
    columns: 2

    Label{
        Layout.fillWidth: true
        text: qsTr("Number of Values:")
    }

    SpinBox{
        value: component.numberOfValues
        onValueChanged: component.numberOfValues = value
        editable: true
        from: 0
        to: 1000
        Layout.fillWidth: true
    }
}
