import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5

//import org.hskl.serialconnection 1.0

Window {
    visible: true
    width: 1024
    height: 768
    title: qsTr("MicroControl")

    MouseArea{
        id: windowArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        onPressed: {
            if(pressedButtons & Qt.RightButton){
                contextMenu.popup()
                componentPreferences.enabled = root.isEditMode && root.childAt(mouseX, mouseY) !== null && (root.childAt(mouseX, mouseY) instanceof DraggableButton || root.childAt(mouseX, mouseY) instanceof DraggableSlider || root.childAt(mouseX, mouseY) instanceof DraggableSerialDisplay)

                deviceMenu.enabled = !serialConnection.isConnected()
                disconnect.enabled = serialConnection.isConnected()
            }
            else if(pressedButtons & Qt.LeftButton && root.isEditMode){
                drag.target = root.childAt(mouseX, mouseY)
                drag.axis = Drag.XAndYAxis
            }
        }

        Item{
            id: root
            anchors.fill: parent

            property bool isEditMode: true

            onIsEditModeChanged: {
                for(var i = 0; i < children.length; i++){
                    if(children[i] instanceof DraggableButton ||
                            children[i] instanceof DraggableSlider ||
                            children[i] instanceof DraggableSerialDisplay)
                        children[i].enabled = !isEditMode
                }

                controlsMenu.enabled = isEditMode
            }

            function createButton(){
                var component = Qt.createComponent("DraggableButton.qml")
                component.createObject(root,  {x: 50, y:50})
            }

            function createSlider(){
                var component = Qt.createComponent("DraggableSlider.qml")
                component.createObject(root, {x:50, y:50})
            }

            function createDisplay(){
                var component = Qt.createComponent("DraggableSerialDisplay.qml")
                component.createObject(root, {x:50, y:50})
            }


            Menu{
                id: contextMenu

                ControlsMenu{
                    id: controlsMenu
                    root: root
                }

                DeviceMenu{
                    id: deviceMenu
                }


                MenuItem{
                    id: componentPreferences
                    text: qsTr("Component Preferences")
                    onTriggered: {
                        var component = root.childAt(windowArea.mouseX, windowArea.mouseY)

                        if(component){
                            if(component instanceof DraggableButton ||
                                    component instanceof DraggableSlider ||
                                    component instanceof DraggableSerialDisplay){

                                var editPopupComponent = Qt.createComponent(qsTr("EditMenuPopup.qml"))
                                var editPopup = editPopupComponent.createObject(component,  {component: component})
                                editPopup.open()
                            }
                        }
                    }
                }

                MenuItem{
                    text: qsTr(root.isEditMode ? "Control Mode" : "Edit Mode")
                    onTriggered: root.isEditMode = !root.isEditMode
                }

                MenuItem{
                    id: disconnect
                    text: qsTr("Disconnect")
                    onTriggered: serialConnection.disconnectFromSerial()
                }
            }
        }
    }
}
