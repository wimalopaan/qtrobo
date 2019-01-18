import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    property var root

    MenuItem{
        text: "Delete"
        onTriggered:{
            var object = root.childAt(windowArea.mouseX, windowArea.mouseY)
            if(object){
                if(object instanceof DraggableButton ||
                        object instanceof DraggableSlider ||
                        object instanceof DraggableSerialDisplay)
                {
                    object.serial = undefined
                    object.destroy()
                }
            }
        }
    }

    MenuItem{
        text: "Rename"

        onTriggered:{
            var textfield = Qt.createComponent("RenameTextfield.qml")
            var selectedButton = root.childAt(windowArea.mouseX, windowArea.mouseY)

            if(selectedButton)
            {
                if(selectedButton instanceof DraggableButton ||
                        selectedButton instanceof DraggableSlider)
                {
                    textfield.createObject(root, {x: selectedButton.x + selectedButton.width/2, y: selectedButton.y + selectedButton.height/3, dragcomponent: selectedButton, focus: true})
                }
            }
        }
    }

    MenuItem{
        text: "Set Event Name"

        onTriggered:{
            var textfield = Qt.createComponent("EventTextfield.qml")

            var selectedButton = root.childAt(windowArea.mouseX, windowArea.mouseY)
            if(selectedButton)
            {
                if(selectedButton instanceof DraggableButton ||
                        selectedButton instanceof DraggableSlider)
                {
                    textfield.createObject(root, {x: selectedButton.x + selectedButton.width/2, y: selectedButton.y + selectedButton.height/3, dragcomponent: selectedButton, focus: true})
                }
            }
        }
    }
}
