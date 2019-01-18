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
            editMenu.enabled = isEditMode
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
                    text: "New Control >"
                    onTriggered: controlsMenu.popup()

                    ControlsMenu{
                        id: controlsMenu
                        root: root
                    }
                }

                MenuItem{
                    text: "Edit >"
                    onTriggered: editMenu.popup()

                    EditMenu{
                        id: editMenu
                        root: root
                    }
                }

                MenuItem{
                    text: "Devices >"
                    onTriggered: deviceMenu.popup()

                    DeviceMenu{
                        id: deviceMenu
                        serialConnection: serialConnection
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
