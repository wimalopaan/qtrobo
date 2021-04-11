import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2 as SpecialDialogs

GridLayout{
    columns: 2
    Layout.fillWidth: true
    Layout.fillHeight: false
    Label{
        Layout.fillWidth: true
        text: qsTr("Inner Needle Color:")
        enabled: component.innerNeedleColor !== undefined
    }

    TextField{
        Layout.fillWidth: true
        text: innerNeedleColorPicker.color
        enabled: component.innerNeedleColor !== undefined


        MouseArea{
            anchors.fill: parent
            onClicked: innerNeedleColorPicker.open()
        }

        SpecialDialogs.ColorDialog{
            id: innerNeedleColorPicker
            color: component.innerNeedleColor ? component.innerNeedleColor : "black"
            onAccepted: {
                if(component.innerNeedleColor)
                    component.innerNeedleColor = color
            }
        }
    }
    Label{
        Layout.fillWidth: true
        text: qsTr("Outer Needle Color:")
        enabled: component.outerNeedleColor !== undefined
    }

    TextField{
        Layout.fillWidth: true
        text: outerNeedleColorPicker.color
        enabled: component.outerNeedleColor !== undefined


        MouseArea{
            anchors.fill: parent
            onClicked: outerNeedleColorPicker.open()
        }

        SpecialDialogs.ColorDialog{
            id: outerNeedleColorPicker
            color: component.outerNeedleColor ? component.outerNeedleColor : "black"
            onAccepted: {
                if(component.outerNeedleColor)
                    component.outerNeedleColor = color
            }
        }
    }
}
