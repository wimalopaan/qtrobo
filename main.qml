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

    property bool closingWindow: false

    onClosing: {
        if(GlobalDefinitions.hasLayoutBeenEdited && !closingWindow){
            close.accepted = false
            closingWindow = true

            layoutStoreDialog.open()
        }
    }

    Connections{
        target: GlobalDefinitions
        onIsEditModeChanged:{
            for(var i = 0; i < contentPane.count; ++i){
                var children = contentPane.itemAt(i).children
                for(var j = 0; j < children.length; ++j){
                    children[j].enabled = !GlobalDefinitions.isEditMode
                }
            }

            for(i = 0; i < tabBar.count; ++i){
                var tab = tabBar.itemAt(i)
                tab.editEnabled = GlobalDefinitions.isEditMode
            }
        }

        onHasLayoutBeenEditedChanged:{
            layoutSaveMenu.enabled = GlobalDefinitions.hasLayoutBeenEdited && layoutPersist.isFilenameValid
        }
    }

    Component.onCompleted: GlobalDefinitions.layoutPersisted()

    Shortcut{
        sequence: StandardKey.Save
        onActivated: saveCurrentChanges()
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
            else if(pressedButtons & Qt.LeftButton && GlobalDefinitions.isEditMode){
                var child = contentPane.currentItem.childAt(mouseX, mouseY)
                if(child){
                    drag.target = child
                    drag.axis = Drag.XAndYAxis
                    drag.minimumX = dragPadding
                    drag.maximumX = contentPane.width - dragPadding - drag.target.width
                    drag.minimumY = dragPadding
                    drag.maximumY = contentPane.height - dragPadding - drag.target.height
                    GlobalDefinitions.layoutEdited()
                }
            }
        }
        onReleased: drag.target = undefined

        onPositionChanged: {
            if(drag.active && drag.target && GlobalDefinitions.isGridMode){
                drag.target.x = drag.target.x - (drag.target.x % GlobalDefinitions.gridModeStepSize)
                drag.target.y = drag.target.y - (drag.target.y % GlobalDefinitions.gridModeStepSize)
            }
        }
    }

    menuBar: MenuBar{
        id: menuBar
        visible: GlobalDefinitions.isEditMode

        Menu{
            title: qsTr("&File")

            MenuItem{
                text: qsTr("&New File")
                onTriggered: {
                    clearTabBar()
                    layoutPersist.filename = ""
                }
            }

            MenuItem{
                id: layoutSaveMenu
                text: qsTr("&Save File")
                enabled: layoutPersist.isFilenameValid && GlobalDefinitions.hasLayoutBeenEdited
                onTriggered: saveCurrentChanges()
            }

            MenuItem{
                text: qsTr("&Save As File")
                onTriggered: layoutStoreDialog.open()

                FileDialog{
                    id: layoutStoreDialog
                    title: qsTr("Save Layout File")
                    sidebarVisible: false
                    selectExisting: false
                    favoriteFolders: false
                    nameFilters: "Layout files (*.json)"
                    folder: shortcuts.home

                    onRejected: {
                        if(closingWindow)
                            window.close()
                    }

                    onAccepted: {
                        if(!fileUrl.toString().endsWith(".json"))
                            layoutPersist.filename = fileUrl + ".json"
                        else
                            layoutPersist.filename = fileUrl

                        layoutPersist.layout = window.layoutToArray()

                        GlobalDefinitions.layoutPersisted()

                        if(closingWindow)
                            window.close()
                    }
                }
            }

            MenuItem{
                text: qsTr("&Open File")
                onTriggered: layoutLoadDialog.open()


                FileDialog{
                    id: layoutLoadDialog
                    title: qsTr("Open Layout File")
                    selectExisting: true
                    sidebarVisible: false
                    nameFilters: "Layout files (*.json)"
                    folder: shortcuts.home
                    onAccepted: {
                        clearTabBar()
                        layoutPersist.filename = fileUrl
                        window.arrayToLayout(layoutPersist.layout)
                        GlobalDefinitions.layoutPersisted()
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

        Menu{
            title: qsTr("S&ettings")

            MenuItem{
                text: qsTr("Events")
                onTriggered: eventSettingsDialog.open()

                EventSettingsDialog{
                    id: eventSettingsDialog
                }
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
            enabled: GlobalDefinitions.isEditMode
            onClicked: window.createTab()
        }

        Button{
            text: "-"
            enabled: tabBar.count > 1 && GlobalDefinitions.isEditMode
            font.pointSize: 14
            font.bold: true
            onClicked: window.destroyTab()
        }
    }

    footer: Rectangle{
        width: parent.width
        height: 20
        color: "lightgray"

        RowLayout{
            anchors.fill: parent
            Text{
                id: connectionStatus
                Layout.alignment: Layout.Center
                text: connectionStatus.text = "Serial Port: " + (serialConnection.isConnected ? "Connected to " + serialConnection.portName : "Not connected")
            }

            Connections{
                target: serialConnection
                onConnectionStateChanged: connectionStatus.text = "Serial Port: " + (serialConnection.isConnected ? "Connected to " + serialConnection.portName : "Not connected")
            }


        Text{
            text: "Status: " + (GlobalDefinitions.hasLayoutBeenEdited ? "Unsaved changes" : "Saved")
            Layout.alignment: Layout.Center
        }
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
            enabled: GlobalDefinitions.isEditMode
            root: window
        }

        MenuItem{
            text: qsTr(GlobalDefinitions.isEditMode ? "Control Mode" : "Edit Mode")
            onTriggered: GlobalDefinitions.isEditMode = !GlobalDefinitions.isEditMode
        }

        MenuItem{
            text: qsTr(GlobalDefinitions.isGridMode ? "Floating Positioning" : "Grid Positioning")
            enabled: GlobalDefinitions.isEditMode
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

        GlobalDefinitions.layoutEdited()
    }

    function createButtonWithIndicator(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableIndicatorButton.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex),  {x: x, y:y})

        GlobalDefinitions.layoutEdited()
    }

    function createSlider(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableSlider.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})

        GlobalDefinitions.layoutEdited()
    }

    function createDisplay(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableSerialDisplay.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})

        GlobalDefinitions.layoutEdited()
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

        GlobalDefinitions.layoutEdited()
    }

    function createDropdown(x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var component = Qt.createComponent("DraggableDropdown.qml")
        component.createObject(contentPane.itemAt(contentPane.currentIndex), {x:x, y:y})

        GlobalDefinitions.layoutEdited()
    }

    function createTab(){
        var component = Qt.createComponent("EditableTab.qml")
        var newTab = component.createObject(tabBar)
        newTab.text = newTab.text + " " + tabBar.count
        var tabPane = Qt.createQmlObject("import QtQuick 2.9; Item{}", contentPane)
        tabPane.Layout.fillWidth = true
        tabPane.Layout.fillHeight = true

        GlobalDefinitions.layoutEdited()
    }

    function destroyTab(){
        if(tabBar.count > 1){
            var paneChildren = contentPane.itemAt(tabBar.count - 1).children
            for(var i = paneChildren.length; i > 0; --i)
                paneChildren[i-1].destroy()

            tabBar.removeItem(tabBar.count - 1)

            GlobalDefinitions.layoutEdited()
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

                var modelEntries = [];

                if(child.model){
                    for(var modelIndex = 0; modelIndex < child.model.count; ++modelIndex)
                        modelEntries.push(child.model.get(modelIndex))
                }

                var obj = {
                    layoutTab: i,
                    layoutTabName: tabBar.itemAt(i).text,
                    type: child.objectName,
                    x: child.x,
                    y: child.y,
                    orientation: child.orientation,
                    width: child.width,
                    height: child.height,
                    label: child.label,
                    eventName: child.eventName,
                    color: child.color,
                    minimumValue: child.minimumValue,
                    maximumValue: child.maximumValue,
                    showValue: child.showValue,
                    modelEntries: modelEntries.length > 0 ? modelEntries : undefined
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

            if(tabBar.itemAt(obj.layoutTab))
               tabBar.itemAt(obj.layoutTab).text = obj.layoutTabName

            var component = undefined;
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
            else if(obj.type === "DraggableLED.qml")
                component = Qt.createComponent("DraggableLED.qml")
            else if(obj.type === "DraggableDropdown")
                component = Qt.createComponent("DraggableDropdown.qml")

            if(component){
                var object = component.createObject(contentPane.itemAt(obj.layoutTab),  {x: obj.x, y: obj.y, width: obj.width, height: obj.height, label: obj.label, eventName: obj.eventName})
                if(obj.color)
                    object.color = Qt.rgba(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
                if(obj.orientation)
                    object.orientation = obj.orientation
                if(obj.minimumValue)
                    object.minimumValue = obj.minimumValue
                if(obj.maximumValue)
                    object.maximumValue = obj.maximumValue
                if(obj.showValue)
                    object.showValue = obj.showValue
                if(obj.modelEntries){
                    object.model.clear()
                    for(var modelIndex = 0; modelIndex < obj.modelEntries.length; ++modelIndex)
                        object.model.append(obj.modelEntries[modelIndex])
                }
            }
        }
    }

    function saveCurrentChanges(){
        if(layoutPersist.isFilenameValid){
            layoutPersist.layout = window.layoutToArray()
            GlobalDefinitions.layoutPersisted()
        }
    }
}
