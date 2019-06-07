import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

GridLayout{
    property var component
    columns: 2

    Label{
        Layout.fillWidth: true
        text: qsTr("Initial Value:")
    }

    TextField{
        text: component.initialValue
        onTextChanged: component.initialValue = text
    }
}
