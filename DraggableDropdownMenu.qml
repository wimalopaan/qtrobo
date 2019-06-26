import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

GridLayout{
    property var component
    columns: 2

    Label{
        Layout.fillWidth: true
        text: tsTr("Entries:")
    }

    ComboBox{
        id: comboBox
        Layout.fillWidth: true
        textRole: "entry"
        model: component.comboBox.model
    }

    Label{
        Layout.fillWidth: true
        text: qsTr("Edit current:")
    }

    TextField{
        Layout.fillWidth: true
        text: comboBox.currentText
        onTextChanged: component.comboBox.model.setProperty(comboBox.currentIndex, "entry", text)
    }

    Button{
        Layout.alignment: Layout.Center
        text: "+"
        onClicked: {
            component.comboBox.model.append({"entry": "New Entry"})
            comboBox.currentIndex = component.comboBox.model.count - 1
        }
    }

    Button{
        Layout.alignment: Layout.Center
        text: "-"
        onClicked: {
            if(component.comboBox.model.count > 1 && comboBox.currentIndex < component.comboBox.model.count){
                var removedIndex = comboBox.currentIndex
                comboBox.currentIndex = removedIndex > 0 ? removedIndex - 1 : removedIndex
                component.comboBox.model.remove(removedIndex)
            }
        }
    }
}
