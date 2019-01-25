import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("MicroControl")
    Material.theme: Material.Light
    Material.accent: Material.Indigo

    property bool isEditMode: true

    onIsEditModeChanged: {
        for(var i = 0; i < stackView.count; i++){
            var children = stackView.itemAt(i).children
            for(var j = 0; j < children.length; j++){
                children[j].enabled = !isEditMode
            }
        }

        controlsMenu.enabled = isEditMode
        menuBar.visible = isEditMode
        rootMouseArea.drag.target = null
    }

    MouseArea{
        id: rootMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton

        property int dragPadding: 5

        onPressed: {
            if(pressedButtons & Qt.RightButton){
                contextMenu.popup()

                deviceMenu.enabled = !serialConnection.isConnected
                disconnect.enabled = serialConnection.isConnected
            }
            else if(pressedButtons & Qt.LeftButton && window.isEditMode){
                var child = stackView.currentItem.childAt(mouseX, mouseY)
                if(child !== null){
                    drag.target = child
                    drag.axis = Drag.XAndYAxis
                    drag.minimumX = dragPadding
                    drag.maximumX = stackView.width - dragPadding - drag.target.width
                    drag.minimumY = dragPadding
                    drag.maximumY = stackView.height - dragPadding - drag.target.height
                }else{
                    drag.target = null
                }
            }
        }

    }

    menuBar: MenuBar{
        id: menuBar
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
                        layoutPersist.layout = window.layoutToArray()
                    }
                }
            }

            MenuItem{
                text: qsTr("&Load Layout")
                onTriggered:{

                    for(var i = 0; i < stackView.count; i++){
                        var children = stackView.itemAt(i).children
                        for(var j = children.length; j > 0; j--){
                            children[j-1].destroy()
                        }
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
                        window.arrayToLayout(layoutPersist.layout)
                    }
                }
            }
        }
    }

    header: TabBar{
        id: tabBar
        width: parent.width


        TabButton{
            text: "Layout 1"
        }

        TabButton{
            text: "Layout 2"
        }

        TabButton{
            text: "Layout 3"
        }
    }

    footer: Rectangle{
            width: parent.width
            height: 20
            color: "lightgray"

            Text{
                id: connectionStatus
                text: connectionStatus.text = (serialConnection.isConnected ? "Connected to: " + serialConnection.portName : "Not connected")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Connections{
                target: serialConnection
                onConnectionStateChanged: connectionStatus.text = (serialConnection.isConnected ? "Connected to: " + serialConnection.portName : "Not connected")
            }

        }


    StackLayout{
        id: stackView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        property var currentItem: itemAt(currentIndex)

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    Menu{
        id: contextMenu

        ControlsMenu{
            id: controlsMenu
            root: window
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
            text: qsTr(window.isEditMode ? "Control Mode" : "Edit Mode")
            onTriggered: window.isEditMode = !window.isEditMode
        }
    }

    function createButton(){
        var component = Qt.createComponent("DraggableButton.qml")
        component.createObject(stackView.itemAt(stackView.currentIndex),  {x: 50, y:50})
    }

    function createSlider(){
        var component = Qt.createComponent("DraggableSlider.qml")
        component.createObject(stackView.itemAt(stackView.currentIndex), {x:50, y:50})
    }

    function createDisplay(){
        var component = Qt.createComponent("DraggableSerialDisplay.qml")
        component.createObject(stackView.itemAt(stackView.currentIndex), {x:50, y:50})
    }

    function createLED(){
        var component = Qt.createComponent("DraggableLED.qml")
        component.createObject(stackView.itemAt(stackView.currentIndex), {x:50, y:50})
    }

    function layoutToArray(){
        var objs = []

        for(var i = 0; i < stackView.count; i++){
            var children = stackView.itemAt(i).children
        for(var j = 0; j < children.length; j++){
            var child = children[j]

            var obj = {
                layoutTab: i,
                type: child.objectName,
                x: child.x,
                y: child.y,
                orientation: child.orientation,
                width: child.width,
                height: child.height,
                label: child.label,
                eventName: child.eventName,
                color: child.color
            }

            objs.push(obj)
        }
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
            }else if(obj.type === "DraggableSerialDisplay"){
                component = Qt.createComponent("DraggableSerialDisplay.qml")
            }else
                component = Qt.createComponent("DraggableLED.qml")
            var object = component.createObject(stackView.itemAt(obj.layoutTab),  {x: obj.x, y: obj.y, width: obj.width, height: obj.height, label: obj.label, eventName: obj.eventName})
            if(obj.color)
                object.color = Qt.rgba(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
            if(obj.orientation)
                object.orientation = obj.orientation
        }
    }
}


