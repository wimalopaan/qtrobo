import QtQuick 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

GridLayout{
    property var component
    columns: 2

    Label{
        Layout.fillWidth: true
        text: qsTr("Shortcut:")
        enabled: component.shortcut !== undefined
    }

    ShortcutInput{
        Layout.fillWidth: true
        enabled: component.shortcut !== undefined
        sequence: component.shortcut
        onSequenceChanged: component.shortcut = sequence
    }
}
