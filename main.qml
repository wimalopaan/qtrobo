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
    title: qsTr("QtRobo")
    Material.theme: Material.Light
    Material.accent: Material.Indigo

    property bool isEditMode: true

    onIsEditModeChanged: {
        for(var i = 0; i < contentPane.count; ++i){
            var children = contentPane.itemAt(i).children
            for(var j = 0; j < children.length; ++j){
                children[j].enabled = !isEditMode
            }
        }

        for(i = 0; i < tabBar.count; ++i){
            var tab = tabBar.itemAt(i)
            tab.editEnabled = isEditMode
        }
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
                var child = contentPane.currentItem.childAt(mouseX, mouseY)
                if(child !== null){
                    drag.target = child
                    drag.axis = Drag.XAndYAxis
                    drag.minimumX = dragPadding
                    drag.maximumX = contentPane.width - dragPadding - drag.target.width
                    drag.minimumY = dragPadding
                    drag.maximumY = contentPane.height - dragPadding - drag.target.height
                }
            }
        }
        onReleased: drag.target = null

        onPositionChanged: {
            if(drag.active && drag.target !== null && GlobalDefinitions.isGridMode){
                drag.target.x = drag.target.x - (drag.target.x % 20)
                drag.target.y = drag.target.y - (drag.target.y % 20)
            }
        }
    }

    menuBar: MenuBar{
        id: menuBar
        visible: isEditMode

        Menu{
            title: qsTr("&File")

            MenuItem{
                text: qsTr("&New Layout")
                onTriggered: clearTabBar()
            }

            MenuItem{
                text: qsTr("&Save Layout")
                onTriggered: layoutStoreDialog.open()

                FileDialog{
                    id: layoutStoreDialog
                    title: "Save Layout"
                    sidebarVisible: false
                    selectExisting: false
                    favoriteFolders: false
                    nameFilters: "Layout files (*.json)"

                    onAccepted: {
                        if(!fileUrl.toString().endsWith(".json"))
                            layoutPersist.filename = fileUrl + ".json"
                        else
                            layoutPersist.filename = fileUrl

                        layoutPersist.layout = window.layoutToArray()

                    }
                }
            }

            MenuItem{
                text: qsTr("&Load Layout")
                onTriggered: layoutLoadDialog.open()


                FileDialog{
                    id: layoutLoadDialog
                    title: qsTr("Load Layout")
                    selectExisting: true
                    sidebarVisible: false
                    nameFilters: "Layout files (*.json)"
                    onAccepted: {
                        clearTabBar()
                        layoutPersist.filename = fileUrl
                        window.arrayToLayout(layoutPersist.layout)
                    }
                }
            }
        }

        Menu{
            title: qsTr("&Serial Port")

            DeviceMenu{
                id: deviceMenu
                root: window
                enabled: !serialConnection.isConnected
            }

            MenuItem{
                id: disconnect
                text: qsTr("Disconnect")
                enabled: serialConnection.isConnected
                onTriggered: serialConnection.disconnectFromSerial()
            }
        }
    }

    header: RowLayout{
        spacing: 2
        width: parent.width

        TabBar{
            id: tabBar
            Layout.fillWidth: true

            EditableTab{
                text: ("Layout")
            }
        }

        Button{
            text: "+"
            font.pointSize: 14
            font.bold: true
            enabled: isEditMode
            onClicked: window.createTab()
        }

        Button{
            text: "-"
            enabled: tabBar.count > 1 && isEditMode
            font.pointSize: 14
            font.bold: true
            onClicked: window.destroyTab()
        }
    }

    footer: Rectangle{
        width: parent.width
        height: 20
        color: "lightgray"

        Text{
            id: connectionStatus
            text: connectionStatus.text = "Status: " + (serialConnection.isConnected ? "Connected to " + serialConnection.portName : "Not connected")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Connections{
            target: serialConnection
            onConnectionStateChanged: connectionStatus.text = "Status: " + (serialConnection.isConnected ? "Connected to " + serialConnection.portName : "Not connected")
        }

    }

    StackLayout{
        id: contentPane
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        property var currentItem: itemAt(currentIndex)

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    Menu{
        id: contextMenu

        ControlsMenu{
            id: controlsMenu
            enabled: isEditMode
            root: window
        }

        MenuItem{
            text: qsTr(window.isEditMode ? "Control Mode" : "Edit Mode")
            onTriggered: window.isEditMode = !window.isEditMode
        }

        MenuItem{
            text: qsTr(GlobalDefinitions.isGridMode ? "Floating Positioning" : "Grid Positioning")
            enabled: window.isEditMode
            onTriggered: GlobalDefinitions.isGridMode = !GlobalDefinitions.isGridMode
        }
    }

    function createButton(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableButton.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex),  {x: x, y:y})
    }

    function createButtonWithIndicator(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableIndicatorButton.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex),  {x: x, y:y})
    }

    function createSlider(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableSlider.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})
    }

    function createDisplay(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableSerialDisplay.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})
    }

    function createLED(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableLED.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})
    }

    function createBalanceSlider(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableBalanceSlider.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})
    }

    function createTab(){
        var component = Qt.createComponent("EditableTab.qml")
        var newTab = component.createObject(tabBar)
        newTab.text = newTab.text + " " + tabBar.count
        var tabPane = Qt.createQmlObject("import QtQuick 2.9; Item{}", contentPane)
        tabPane.Layout.fillWidth = true
        tabPane.Layout.fillHeight = true
    }

    function destroyTab(){
        if(tabBar.count > 1){
            var paneChildren = contentPane.itemAt(tabBar.count - 1).children
            for(var i = paneChildren.length; i > 0; --i)
                paneChildren[i-1].destroy()

            tabBar.removeItem(tabBar.count - 1)
        }
    }

    function clearTabBar(){
        while(tabBar.count > 1)
            window.destroyTab()

        var childrenFirstPane = contentPane.itemAt(0).children
        for(var j = childrenFirstPane.length; j > 0; --j){
            childrenFirstPane[j-1].destroy()
        }
    }

    function layoutToArray(){
        var objs = []

        for(var i = 0; i < contentPane.count; ++i){
            var children = contentPane.itemAt(i).children
            for(var j = 0; j < children.length; ++j){
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
        for(var i = 0; i < layout.length; ++i){
            var obj = layout[i]

            while(obj.layoutTab >= tabBar.count)
                createTab()

            var component = null;
            if(obj.type === "DraggableButton"){
                component = Qt.createComponent("DraggableButton.qml")
            }else if(obj.type === "DraggableSlider"){
                component = Qt.createComponent("DraggableSlider.qml")
            }else if(obj.type === "DraggableBalanceSlider"){
                component = Qt.createComponent("DraggableBalanceSlider.qml")
            }else if(obj.type === "DraggableSerialDisplay"){
                component = Qt.createComponent("DraggableSerialDisplay.qml")
            }else if(obj.type === "DraggableIndicatorButton")
                component = Qt.createComponent("DraggableIndicatorButton.qml")
            else if("DraggableLED.qml")
                component = Qt.createComponent("DraggableLED.qml")

            if(component){
                var object = component.createObject(contentPane.itemAt(obj.layoutTab),  {x: obj.x, y: obj.y, width: obj.width, height: obj.height, label: obj.label, eventName: obj.eventName})
                if(obj.color)
                    object.color = Qt.rgba(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
                if(obj.orientation)
                    object.orientation = obj.orientation
            }
        }
    }
}
