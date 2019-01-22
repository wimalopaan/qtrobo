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
                    id: disconnect
                    text: qsTr("Disconnect")
                    onTriggered: serialConnection.disconnectFromSerial()
                }

                MenuItem{
                    text: qsTr(root.isEditMode ? "Control Mode" : "Edit Mode")
                    onTriggered: root.isEditMode = !root.isEditMode
                }
                /*MenuItem{
                    text: "Save Layout"
                    onTriggered: {
                        var objs = []

                        for(var i = 0; i < root.children.length; i++){
                            var child = root.children[i]

                                var obj = {
                                    type: (child instanceof DraggableButton ? "DraggableButton" : child instanceof DraggableSlider ? "DraggableSlider" : "DraggableDisplay"),
                                    x: child.x,
                                    y: child.y,
                                    width: child.width,
                                    height: child.height,
                                    name: child.text,
                                    event: child.eventName
                                }

                                objs.push(obj)
                            }

                        serialConnection.test(objs)

                    }
                }*/

                /*MenuItem{
                    text: "Load Layout"
                    onTriggered:{
                        var objs = serialConnection.testRead()

                        console.log(objs)
                        for(var i = 0; i < objs.length; i++){
                            var obj = objs[i]
                            console.log(obj);
                            if(obj.type === "DraggableButton"){
                                //var component = Qt.createComponent("DraggableButton.qml")
                                //component.createObject(root,  {x: obj.x, y: obj.y, width: obj.width, height: obj.height, text: object.text, eventName: obj.eventName})
                            }
                        }                  }
                }*/
            }
        }
    }
}
