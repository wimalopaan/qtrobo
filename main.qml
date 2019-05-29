import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtRobo.ConnectionType 1.0

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
        onIsEditModeChanged: setLayoutEdible(GlobalDefinitions.isEditMode)

        onHasLayoutBeenEditedChanged: layoutSaveMenu.enabled = GlobalDefinitions.hasLayoutBeenEdited && qtRobo.persistance.isFilenameValid

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

                connections.enabled = !qtRobo.connection.isConnected
                disconnect.enabled = qtRobo.connection.isConnected
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
                    qtRobo.persistance.filename = ""
                }
            }

            MenuItem{
                id: layoutSaveMenu
                text: qsTr("&Save File")
                enabled: qtRobo.persistance.isFilenameValid && GlobalDefinitions.hasLayoutBeenEdited
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
                            qtRobo.persistance.filename = fileUrl + ".json"
                        else
                            qtRobo.persistance.filename = fileUrl

                        qtRobo.persistance.layout = window.layoutToArray()
                        qtRobo.persistance.persist()
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
                        qtRobo.persistance.filename = fileUrl

                        qtRobo.persistance.restore()

                        window.arrayToLayout(qtRobo.persistance.layout)
                        GlobalDefinitions.layoutPersisted()
                    }
                }
            }
        }

        Menu{
            title: qsTr("&Devices")

            Menu{
                id: connections
                title: qsTr("Connection")

                MenuItem{
                    text: qsTr("Serial")

                    onTriggered: {
                        qtRobo.connectionType = ConnectionType.Serial
                        connectionConfigDialog.open()
                    }

                    ConnectionConfigDialog{
                        id: connectionConfigDialog
                    }
                }

                MenuItem{
                    text: qsTr("Local Socket")

                    onTriggered: {
                        qtRobo.connectionType = ConnectionType.Socket
                        connectionConfigDialog.open()
                    }
                }
            }



            MenuItem{
                id: disconnect
                text: qsTr("Disconnect")
                enabled: qtRobo.connection.isConnected
                onTriggered: qtRobo.connection.disconnect()
            }

            Connections{
                target: qtRobo.connection
                onConnectionStateChanged: {
                    connections.enabled = !qtRobo.connection.isConnected
                    disconnect.enabled = qtRobo.connection.isConnected
                }
            }
        }
    }

    header: RowLayout{
        spacing: 2
        width: parent.width

        Button{
            Layout.fillHeight: true
            icon.source: "qrc:/bug_logo.png"
            onClicked: {
                var component = Qt.createComponent("DebugPopup.qml")
                if(component){
                    var debugWindow = component.createObject(window)
                    if(debugWindow)
                        debugWindow.show()
                }

            }

        }

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

        GridLayout{
            anchors.fill: parent
            columns: 3
            Text{
                id: connectionStatus
                Layout.alignment: Layout.Center
                text: connectionStatus.text = "Serial Port: " + (qtRobo.connection.isConnected ? "Connected"  : "Not connected")
            }

            Connections{
                target: qtRobo.connection
                onConnectionStateChanged: connectionStatus.text = "Serial Port: " + (qtRobo.connection.isConnected ? "Connected" : "Not connected")
            }

            Text{
                id: keepAlive
                Layout.alignment: Layout.Center
                text: "Hardware response: "
                visible: qtRobo.connection.heartbeatEnabled

                Rectangle{
                    id: heartbeatStatusLED
                    width: parent.height
                    height: width

                    radius: 25
                    anchors.left: parent.right
                    color: "lightgreen"


                    ColorAnimation on color{
                        id: heartbeatLEDColorAnimation
                        from: "lightgreen"
                        to: "darkgreen"
                        duration: 250
                    }

                    Connections{
                        target: qtRobo.connection
                        onHeartbeatTriggered: {
                            heartbeatStatus ? heartbeatLEDColorAnimation.start() : heartbeatStatusLED.color = "darkred"
                            setLayoutEnabled(heartbeatStatus)
                        }
                    }
                }
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

    function createComponent(componentType, x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var componentFile = GlobalDefinitions.componentName[componentType]

        if(componentFile){
            componentFile = componentFile.concat(".qml")
            var component = Qt.createComponent(componentFile)
            component.createObject(contentPane.itemAt(contentPane.currentIndex),  {x: x, y:y})

            GlobalDefinitions.layoutEdited()
        }
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

    function setLayoutEdible(isEdible){
        for(var i = 0; i < contentPane.count; ++i){
            var children = contentPane.itemAt(i).children
            for(var j = 0; j < children.length; ++j){
                children[j].edible = isEdible
            }
        }

        for(i = 0; i < tabBar.count; ++i){
            var tab = tabBar.itemAt(i)
            tab.editEnabled = isEdible
        }
    }

    function setLayoutEnabled(isEnabled){
        for(var i = 0; i < contentPane.count; ++i){
            var children = contentPane.itemAt(i).children
            for(var j = 0; j < children.length; ++j){
                if(!children[j].edible)
                    children[j].enabled = isEnabled
            }
        }
    }

    function layoutToArray(){

        var tabs = []

        for(var i = 0; i < contentPane.count; ++i){
            var children = contentPane.itemAt(i).children

            var tab = {
                tabIndex: i,
                tabName: tabBar.itemAt(i).text,
                content:[]
            }

            for(var j = 0; j < children.length; ++j){
                var child = children[j]


                var modelEntries = [];

                if(child.model){
                    for(var modelIndex = 0; modelIndex < child.model.count; ++modelIndex)
                        modelEntries.push(child.model.get(modelIndex))
                }

                var widget = {
                    type: child.componentType,
                    x: child.x,
                    y: child.y,
                    orientation: child.orientation,
                    width: child.width,
                    height: child.height,
                    label: child.label,
                    eventName: child.eventName,
                    fontColor: child.fontColor,
                    componentColor: child.componentColor,
                    minimumValue: child.minimumValue,
                    maximumValue: child.maximumValue,
                    mappedMinimumValue: child.mappedMinimumValue,
                    mappedMaximumValue: child.mappedMaximumValue,
                    showValue: child.showValue,
                    modelEntries: modelEntries.length > 0 ? modelEntries : undefined,
                    imageSource: child.imageSource ? child.imageSource.toString() : undefined,
                    numberOfValues: child.numberOfValues
                }

                tab.content.push(widget)
            }

            tabs.push(tab)
        }

        return tabs;
    }

    function arrayToLayout(tabs){
        for(var i = 0; i < tabs.length; ++i){
            var tab = tabs[i]

            if(tab.tabIndex > 0)
                createTab()

            tabBar.itemAt(tab.tabIndex).text = tab.tabName

            for(var j = 0; j < tab.content.length; ++j){
                var widget = tab.content[j]
                var componentFile = GlobalDefinitions.componentName[widget.type]

                if(componentFile){
                    componentFile = componentFile.concat(".qml")

                    var component = Qt.createComponent(componentFile)

                    if(component){
                        var componentObject = component.createObject(contentPane.itemAt(tab.tabIndex),
                                                                     {
                                                                         x: widget.x,
                                                                         y: widget.y,
                                                                         width: widget.width,
                                                                         height: widget.height,
                                                                         label: widget.label,
                                                                         eventName: widget.eventName
                                                                     })
                        if(widget.fontColor)
                            componentObject.fontColor = Qt.rgba(widget.fontColor.r, widget.fontColor.g, widget.fontColor.b, widget.fontColor.a)
                        if(widget.componentColor)
                            componentObject.componentColor = Qt.rgba(widget.componentColor.r, widget.componentColor.g, widget.componentColor.b, widget.componentColor.a)
                        if(widget.orientation)
                            componentObject.orientation = widget.orientation
                        if(widget.minimumValue)
                            componentObject.minimumValue = widget.minimumValue
                        if(widget.maximumValue)
                            componentObject.maximumValue = widget.maximumValue
                        if(widget.showValue)
                            componentObject.showValue = widget.showValue
                        if(widget.mappedMinimumValue)
                            componentObject.mappedMinimumValue = widget.mappedMinimumValue
                        if(widget.mappedMaximumValue)
                            componentObject.mappedMaximumValue = widget.mappedMaximumValue
                        if(widget.numberOfValues)
                            componentObject.numberOfValues = widget.numberOfValues
                        if(widget.modelEntries){
                            componentObject.model.clear()
                            for(var modelIndex = 0; modelIndex < widget.modelEntries.length; ++modelIndex)
                                componentObject.model.append(widget.modelEntries[modelIndex])
                        }
                        if(widget.imageSource)
                            componentObject.imageSource = widget.imageSource
                    }
                }
            }
        }
    }

    function saveCurrentChanges(){
        if(qtRobo.persistance.isFilenameValid){
            qtRobo.persistance.layout = window.layoutToArray()
            qtRobo.persistance.persist()

            GlobalDefinitions.layoutPersisted()
        }
    }
}
