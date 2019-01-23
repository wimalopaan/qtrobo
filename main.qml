import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("MicroControl")

    menuBar: MenuBar{
        Menu{
            title: qsTr("&File")

            MenuItem{
                text: qsTr("&Save Layout")
                onTriggered: layoutStoreDialog.open()

                FileDialog{
                    id: layoutStoreDialog
                    title: "Save Layout"
                    selectExisting: false

                    favoriteFolders: false
                    nameFilters: "Layout files (*.json)"

                    onAccepted: {
                        layoutPersist.filename = fileUrl
                        layoutPersist.layout = root.layoutToArray()
                    }
                }
            }

            MenuItem{
                text: qsTr("&Load Layout")
                onTriggered:{
                    if(root.children.length > 0){
                        for(var i = root.children.length; i > 0; i--)
                            root.children[i-1].destroy()
                    }

                    layoutLoadDialog.open();
                }

                FileDialog{
                    id: layoutLoadDialog
                    title: "Load Layout"
                    selectExisting: true
                    nameFilters: "Layout files (*.json)"

                    onAccepted: {
                        layoutPersist.filename = fileUrl
                        root.arrayToLayout(layoutPersist.layout)
                    }
                }
            }
        }
    }

    MouseArea{
        id: windowArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton

        property int dragPadding: 5

        onPressed: {
            if(pressedButtons & Qt.RightButton){
                contextMenu.popup()

                deviceMenu.enabled = !serialConnection.isConnected()
                disconnect.enabled = serialConnection.isConnected()
            }
            else if(pressedButtons & Qt.LeftButton && root.isEditMode){
                var child = root.childAt(mouseX, mouseY)
                if(child !== null){
                    console.log(child)
                    drag.target = child
                    drag.axis = Drag.XAndYAxis
                    drag.minimumX = dragPadding
                    drag.maximumX = root.width - dragPadding - drag.target.width
                    drag.minimumY = dragPadding
                    drag.maximumY = root.height - dragPadding - drag.target.height
                }else{
                    drag.target = null
                }
            }
        }

        Item{
            id: root
            anchors.fill: parent

            property bool isEditMode: true

            onIsEditModeChanged: {
                for(var i = 0; i < children.length; i++){
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

            function createLED(){
                var component = Qt.createComponent("DraggableLED.qml")
                component.createObject(root, {x:50, y:50})
            }

            function layoutToArray(){
                var objs = []

                for(var i = 0; i < root.children.length; i++){
                    var child = root.children[i]

                    var obj = {
                        type: child.objectName,
                        x: child.x,
                        y: child.y,
                        rotation: child.rotation,
                        width: child.width,
                        height: child.height,
                        label: child.label,
                        eventName: child.eventName
                    }

                    objs.push(obj)
                }

                return objs;
            }

            function arrayToLayout(layout){
                for(var i = 0; i < layout.length; i++){
                    var obj = layout[i]

                    var component = null;
                    if(obj.type === "DraggableButton"){
                        component = Qt.createComponent("DraggableButton.qml")
                    }else if(obj.type === "DraggableSlider"){
                        component = Qt.createComponent("DraggableSlider.qml")
                    }else
                        component = Qt.createComponent("DraggableSerialDisplay.qml")

                    component.createObject(root,  {x: obj.x, y: obj.y, rotation: obj.rotation, width: obj.width, height: obj.height, label: obj.label, eventName: obj.eventName});
                }
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
            }
        }
    }
}
