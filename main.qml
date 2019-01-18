import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5

import org.hskl.serialconnection 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("OpenRoboRemo")

    SerialConnection{
        id: serialConnection
    }

    Item{
        id: root
        anchors.fill: parent


        property bool isEditMode: true

        onIsEditModeChanged: {
            for(var i = 0; i < children.length; i++){
                if(children[i] instanceof DraggableButton ||
                        children[i] instanceof DraggableSlider)
                    children[i].enabled = !isEditMode
            }

            controlsMenu.enabled = isEditMode
        }

        function createButton(){
            var component = Qt.createComponent("DraggableButton.qml")
            component.createObject(root,  {serial: serialConnection})
        }

        function createSlider(){
            var component = Qt.createComponent("DraggableSlider.qml")
            component.createObject(root, {serial: serialConnection})
        }

        function createDisplay(){
            var component = Qt.createComponent("DraggableSerialDisplay.qml")
            component.createObject(root, {serial: serialConnection})
        }

        MouseArea{
            id: windowArea
            anchors.fill: parent
            acceptedButtons: Qt.RightButton | Qt.LeftButton
            onPressed: {
                if(pressedButtons & Qt.RightButton){
                    contextMenu.popup()
                    componentPreferences.enabled = root.isEditMode && (root.childAt(mouseX, mouseY) instanceof DraggableButton || root.childAt(mouseX, mouseY) instanceof DraggableSlider)
                    deviceMenu.enabled = !serialConnection.isConnected()
                    disconnect.enabled = serialConnection.isConnected()
                }
                else if(pressedButtons & Qt.LeftButton && root.isEditMode)
                {
                    drag.target = root.childAt(mouseX, mouseY)
                    drag.axis = Drag.XAndYAxis
                }
            }

            Menu{
                id: contextMenu
                MenuItem{
                    id: controlsMenu
                    text: "New Control >"
                    onTriggered: controlsSubMenu.popup()

                    ControlsMenu{
                        id: controlsSubMenu
                        root: root
                    }
                }

                MenuItem{
                    id: deviceMenu
                    text: "Devices >"
                    onTriggered: deviceSubMenu.popup()

                    DeviceMenu{
                        id: deviceSubMenu
                        serialConnection: serialConnection
                    }
                }

                MenuItem{
                    id: componentPreferences
                    text: "Component Preferences"
                    onTriggered: {
                        var component = root.childAt(windowArea.mouseX, windowArea.mouseY)

                        if(component){
                            if(component instanceof DraggableButton ||
                                    component instanceof DraggableSlider){
                                var editPopupComponent = Qt.createComponent("EditMenuPopup.qml")
                                var editPopup = editPopupComponent.createObject(component,  {component: component})
                                editPopup.open()
                            }
                        }
                    }
                }

                MenuItem{
                    text: "Editmode " + (root.isEditMode ? "enabled" : "disabled")
                    onTriggered: root.isEditMode = !root.isEditMode
                }

                MenuItem{
                    id: disconnect
                    text: "Disconnect"
                    onTriggered: serialConnection.disconnectFromSerial()
                }
            }
        }
    }
}
