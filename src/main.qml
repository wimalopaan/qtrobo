import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtRobo.ConnectionType 1.0
import QtRobo.DebugInfoDirection 1.0

import DebugMessage 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("QtRobo")
    Material.theme: Material.Light
    Material.accent: Material.Indigo

    property bool closingWindow: false
    property var selectedWidget

    onSelectedWidgetChanged: {
        if(selectedWidget){
            selectedWidget
        }
    }

    onClosing: {
        if(GlobalDefinitions.hasLayoutBeenEdited && !closingWindow){
            close.accepted = false
            closingWindow = true

            layoutStoreDialog.open()
        }
    }

    Connections{
        target: GlobalDefinitions
        function onIsEditModeChanged(){
            setLayoutEdible(GlobalDefinitions.isEditMode)
        }

        function onHasLayoutBeenEditedChanged(){
            layoutSaveMenu.enabled = GlobalDefinitions.hasLayoutBeenEdited && qtRobo.persistance.isFilenameValid
        }
    }

    Component.onCompleted: GlobalDefinitions.projectPersisted()

    Shortcut{
        sequence: StandardKey.Save
        onActivated: saveCurrentChanges()
    }

    Dialog{
           id: layoutStoreDialogMobile
           x: parent ? ((parent.width - width) / 2) : 0
           y: parent ? ((parent.height - height) / 2) : 0
           width: parent.width
           height:parent.height
           contentItem: Rectangle{
               property int default_width: (Screen.primaryOrientation === Qt.PortraitOrientation) ? 360 : 672  //pixel density of my current screen
               property double widthFactor: Screen.width/default_width
               property  int default_height:(Screen.primaryOrientation === Qt.PortraitOrientation) ? 672 : 360
               property double heightFactor: Screen.height/default_height
               width: 300 * widthFactor
               height: 200 * heightFactor
               Column{
                   width: parent.width
                   height: parent.height

                   TextField {
                     id: filenameTextField
                     width: parent.width
                     height: parent.height * 0.5
                     text: "Your filename"
                     horizontalAlignment: TextInput.AlignHCenter
                     focus: true
                     onFocusChanged: console.log("Focus changed " + focus)
                 }

                 Row{
                     id:row
                     width: parent.width
                     height: parent.height * 0.5

                     Rectangle{
                         id: r1
                         width: parent.width * 0.5
                         height: parent.height

                         Button{
                             text:"Cancel"
                             width:parent.width * 0.6
                             height: parent.height * 0.6
                             anchors.horizontalCenter: r1.horizontalCenter
                             anchors.verticalCenter: r1.verticalCenter
                             onClicked: layoutStoreDialogMobile.close()
                         }


                     }

                     Rectangle{
                         id: r2
                         width: parent.width * 0.5
                         height: parent.height

                         Button{
                             text: "Save"
                             width:parent.width * 0.6
                             height: parent.height * 0.6
                             anchors.horizontalCenter: r2.horizontalCenter
                             anchors.verticalCenter: r2.verticalCenter
                             onClicked: {
                                 filenameTextField.editingFinished()
                                 console.log(filenameTextField.displayText)
                                 if(!filenameTextField.text.endsWith(".json"))
                                     qtRobo.persistance.filename = filenameTextField.displayText + ".json"
                                 else
                                     qtRobo.persistance.filename = filenameTextField.displayText
                                 qtRobo.persistance.layout = window.layoutToArray()
                                 qtRobo.persistance.persist()
                                 GlobalDefinitions.projectPersisted()
                                 layoutStoreDialogMobile.close()

                             }
                         }


                     }


                 }


               }

           }


       }

       Dialog{
           id: tellUserAboutQtRoboLocation
           x: parent ? ((parent.width - width) / 2) : 0
           y: parent ? ((parent.height - height) / 2) : 0
           width: parent.width
           height:parent.height
           contentItem: Rectangle{
               property int default_width: (Screen.primaryOrientation === Qt.PortraitOrientation) ? 360 : 672  //pixel density of my current screen
               property double widthFactor: Screen.width/default_width
               property  int default_height:(Screen.primaryOrientation === Qt.PortraitOrientation) ? 672 : 360
               property double heightFactor: Screen.height/default_height
               width: 300 * widthFactor
               height: 200 * heightFactor
               Column{
                   width: parent.width
                   height: parent.height



                   Rectangle{
                       id: rec1
                       width: parent.width
                       height: parent.height * 0.5

                       Label {
                         id: tellUserAboutQtRoboLocationText
                         x: (parent.width - width) / 2
                         y: (parent.height - height) / 2
                         width: parent.width * 0.8
                         height: parent.height * 0.6
                         wrapMode: Label.WordWrap
                         text: "The Layout Files are stored under DeviceName/QtRobo"
                         anchors.horizontalCenter: rec1.horizontalCenter
                         anchors.verticalCenter: rec1.verticalCenter

                       }


                   }


                   Rectangle{
                       id: rec2
                       width: parent.width
                       height: parent.height * 0.5

                       Button{
                           text:"Ok"
                           width:parent.width * 0.6
                           height: parent.height * 0.6
                           anchors.horizontalCenter: rec2.horizontalCenter
                           anchors.verticalCenter: rec2.verticalCenter
                           onClicked: {
                               tellUserAboutQtRoboLocation.close()
                               layoutLoadDialog.open()
                           }
                       }


                   }

               }

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

                connections.enabled = !qtRobo.connection.isConnected
                disconnect.enabled = qtRobo.connection.isConnected
            }
            else if(pressedButtons & Qt.LeftButton && GlobalDefinitions.isEditMode){
                var child = contentPane.currentItem.childAt(mouseX, mouseY)
                if(child){
                    selectedWidget = child
                    drag.target = child
                    drag.axis = Drag.XAndYAxis
                    drag.minimumX = dragPadding
                    drag.maximumX = contentPane.width - dragPadding - drag.target.width
                    drag.minimumY = dragPadding
                    drag.maximumY = contentPane.height - dragPadding - drag.target.height
                    GlobalDefinitions.projectEdited()
                }else{
                    selectedWidget = undefined
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
                    onTriggered: qrRoboUtil.isMobileDevice() ? layoutStoreDialogMobile.open() : layoutStoreDialog.open()



                    FileDialog{
                        id: layoutStoreDialog
                        title: qsTr("Save Layout File")
                        sidebarVisible: false
                        selectExisting: false
                        favoriteFolders: false
                        defaultSuffix: "json"
    //                    favoriteFolders: false
                        nameFilters: "Layout files (*.json)"
                        folder: shortcuts.documents

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
                            GlobalDefinitions.projectPersisted()

                            if(closingWindow)
                                window.close()
                        }
                    }

                }




                MenuItem{
                    text: qsTr("&Open File")
                    onTriggered: {
                        if (qrRoboUtil.isMobileDevice()){
                            if (qtRobo.persistance.qtRoboFolderSelectedOnMobile()){
                                layoutLoadDialog.open();
                            }else{
                                tellUserAboutQtRoboLocation.open();
                            }
                        }else{
                            layoutLoadDialog.open();
                        }


                    }



                    FileDialog{
                        id: layoutLoadDialog
                        title: qsTr("Open Layout File")
                        selectExisting: true
                        sidebarVisible: false
                        nameFilters: "*json"
                        folder: shortcuts.documents
                        onAccepted: {
                            clearTabBar()
                            qtRobo.persistance.filename = fileUrl
                            qtRobo.persistance.restore()
                            window.arrayToLayout(qtRobo.persistance.layout)
                            GlobalDefinitions.projectPersisted()
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

                MenuItem{
                    text: qsTr("Bluetooth")

                    onTriggered:{
                        qtRobo.connectionType = ConnectionType.Bluetooth
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
                function onConnectionStateChanged() {
                    connections.enabled = !qtRobo.connection.isConnected
                    disconnect.enabled = qtRobo.connection.isConnected
                }
            }
        }

        Menu{
            title: qsTr("&Context")

            ControlsMenu{
                widgetX: window.width / 2
                widgetY: window.height / 2
                enabled: GlobalDefinitions.isEditMode
                root: window
            }

            MenuItem{
                text: GlobalDefinitions.isEditMode ? qsTr("Control Mode") : qsTr("Edit Mode")
                onTriggered: GlobalDefinitions.isEditMode = !GlobalDefinitions.isEditMode
            }

            MenuItem{
                text: GlobalDefinitions.isGridMode ? qsTr("Floating Positioning") : qsTr("Grid Positioning")
                enabled: GlobalDefinitions.isEditMode
                onTriggered: GlobalDefinitions.isGridMode = !GlobalDefinitions.isGridMode
            }

            MenuItem{
                text: selectedWidget ? (qsTr("Copy ") + GlobalDefinitions.getDisplayName(selectedWidget.componentType)) : qsTr("Copy")
                enabled: GlobalDefinitions.isEditMode && selectedWidget !== undefined
                onTriggered:{
                    if(selectedWidget){
                       var component = window.createComponent(selectedWidget.componentType, selectedWidget.x, selectedWidget.y);
                       if(component)
                           component.setConfig(selectedWidget);
                       }
                }
            }

            MenuItem{
                text: qsTr("Tab Names")
                enabled: GlobalDefinitions.isEditMode
                onTriggered: {
                    tabRenameDialog.tabBar = tabBar
                    tabRenameDialog.open()
                }

                TabRenameDialog{
                    id: tabRenameDialog
                }
            }
        }

        Menu{
            title: qsTr("&Tabs")

            MenuItem{
                text: qsTr("&New Tab")
                onTriggered: {
                    window.createTab()
                }
            }


                MenuItem{
                    text: qsTr("&Delete Tab")
                    onTriggered: {
                        window.destroyTab()

                    }
            }
        }

    }

    header: RowLayout{
        spacing: 2
        width: parent.width

        Button{
            Layout.fillHeight: true
            text: !GlobalDefinitions.isEditMode ? "✏" : "🕹"
            font.pointSize: !GlobalDefinitions.isEditMode ? 18 : 14
            font.bold: true
            onClicked: {
                GlobalDefinitions.isEditMode = !GlobalDefinitions.isEditMode
                GlobalDefinitions.isShowingDebugWindow = false;
            }

        }

        Button{
            Layout.fillHeight: true

            text: GlobalDefinitions.recording ? "⏸" : "🛑"
            onClicked: {
                GlobalDefinitions.invertRecording()
                debugMessageList.invertRecording()
            }
        }

        Button{
            Layout.fillHeight: true
            icon.source: "qrc:/bug_logo.png"
            onClicked: {
                GlobalDefinitions.invertDebugWindow()
            }
        }

        TabBar{
            id: tabBar
            property string eventName
            Layout.fillWidth: true
            EditableTab{
                text: qsTr("Layout")
            }

            onCurrentIndexChanged: {
                var eventValue = tabBar.itemAt(currentIndex).eventValue
                if(eventName && eventValue){
                    qtRobo.connection.write(eventName, eventValue)
                }
            }
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
                text: connectionStatus.text = qsTr("connection status: ") + (qtRobo.connection.isConnected ? qsTr("connected")  : qsTr("not connected"))
            }

            Connections{
                target: qtRobo.connection
                function onConnectionStateChanged(){
                    connectionStatus.text = qsTr("connection status: ") + (qtRobo.connection.isConnected ? qsTr("connected")  : qsTr("not connected"))
                }
            }

            Text{
                id: keepAlive
                Layout.alignment: Layout.Center
                text: qsTr("hardware response:")
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
                        function onHeartbeatTriggered() {
                            if(qtRobo.connection.heartbeatStatus){
                                heartbeatLEDColorAnimation.start();
                            }else{
                                heartbeatStatusLED.color = "darkred";
                            }

                            setLayoutEnabled(heartbeatStatus)
                        }
                    }
                }
            }


        Text{
            text: qsTr("project status: ") + (GlobalDefinitions.hasLayoutBeenEdited ? qsTr("unsaved changes") : qsTr("saved"))
            Layout.alignment: Layout.Center
        }
    }
    }

    StackLayout{
        id: switchdebugview
        width: parent.width
        height:parent.height
        currentIndex: GlobalDefinitions.isShowingDebugWindow ? 0 : 1

        Rectangle{
            id: root
            width: parent.width
            height: parent.height




            ListView{



                       id: debugList
                       anchors.fill: parent
                       model: DebugMessageModel{
                            list: debugMessageList
                       }
                       onCountChanged: {
                           Qt.callLater( debugList.positionViewAtEnd )
                       }
                       clip: true
                       cacheBuffer: 0
                       delegate: Text{
                           text: model.message
                           verticalAlignment: Text.AlignBottom
                           font.pointSize: 10
                           leftPadding: 20
                           //rightPadding: 20
                       }




        }

            Button{
                text: "Clear"
                x: parent.width -100
                y: parent.height -100
                onClicked: {
                 console.log("btn clear called")
                 debugMessageList.clear()

                }

            }

        }

        StackLayout{
            id: contentPane
            currentIndex: tabBar.currentIndex

            property var currentItem: itemAt(currentIndex)

            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
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
            text: GlobalDefinitions.isEditMode ? qsTr("Control Mode") : qsTr("Edit Mode")
            onTriggered: GlobalDefinitions.isEditMode = !GlobalDefinitions.isEditMode
        }

        MenuItem{
            text: GlobalDefinitions.isGridMode ? qsTr("Floating Positioning") : qsTr("Grid Positioning")
            enabled: GlobalDefinitions.isEditMode
            onTriggered: GlobalDefinitions.isGridMode = !GlobalDefinitions.isGridMode
        }

        MenuItem{
            text: selectedWidget ? (qsTr("Copy ") + GlobalDefinitions.getDisplayName(selectedWidget.componentType)) : qsTr("Copy")
            enabled: GlobalDefinitions.isEditMode && selectedWidget !== undefined
            onTriggered:{
                if(selectedWidget){
                   var component = window.createComponent(selectedWidget.componentType, selectedWidget.x, selectedWidget.y);
                   if(component)
                       component.setConfig(selectedWidget);
                   }
            }
        }
    }

    function createComponent(componentType, x, y){
        if(x === undefined)
            x = rootMouseArea.mouseX
        if(y === undefined)
            y = rootMouseArea.mouseY

        var componentFile = GlobalDefinitions.componentName[componentType]
        var obj;
        if(componentFile){
            componentFile = componentFile.concat(".qml")
            var component = Qt.createComponent(componentFile)
            obj = component.createObject(contentPane.itemAt(contentPane.currentIndex),  {x: x, y: y})
            GlobalDefinitions.projectEdited()
        }
        return obj;
    }

    function createTab(){
        var component = Qt.createComponent("EditableTab.qml")
        var newTab = component.createObject(tabBar)
        newTab.text = newTab.text + " " + tabBar.count
        var tabPane = Qt.createQmlObject("import QtQuick 2.9; Item{}", contentPane)
        tabPane.Layout.fillWidth = true
        tabPane.Layout.fillHeight = true

        GlobalDefinitions.projectEdited()
    }

    function destroyTab(){
        if(tabBar.count > 1){
            var paneChildren = contentPane.itemAt(tabBar.count - 1).children
            for(var i = paneChildren.length; i > 0; --i)
                paneChildren[i-1].destroy()

            tabBar.removeItem(tabBar.count - 1)

            GlobalDefinitions.projectEdited()
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
                eventName: tabBar.eventName,
                eventValue: tabBar.itemAt(i).eventValue,
                content:[]
            }

            for(var j = 0; j < children.length; ++j){
                var child = children[j]


                var modelEntries = [];

                if(child.model){
                    for(var modelIndex = 0; modelIndex < child.model.count; ++modelIndex)
                        modelEntries.push(child.model.get(modelIndex))
                }

                var buttonGroup = []

                if(child.buttonGroup){
                    for(var index = 0; index < child.buttonGroup.children.length; ++index){
                        var btn = child.buttonGroup.children[index]
                        buttonGroup.push({
                                              eventValue: btn.eventValue,
                                              text: btn.text
                                          })
                    }
                }

                var widget = {
                    componentType: child.componentType,
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
                    buttonGroup: buttonGroup.length > 0 ? buttonGroup : undefined,
                    highlightOnly: child.highlightOnly,
                    imageSource: child.imageSource ? child.imageSource.toString() : undefined,
                    numberOfValues: child.numberOfValues,
                    isFixedYAxis: child.isFixed,
                    fixedYAxisMax: child.maxYAxis,
                    initialValue: child.initialValue,
                    isBalanced: child.isBalanced,
                    outputScript: child.outputScript,
                    inputScript: child.inputScript,
                    shortcut: child.shortcut,
                    decreaseShortcut: child.decreaseShortcut,
                    increaseShortcut: child.increaseShortcut,
                    innerNeedleColor: child.innerNeedleColor,
                    outerNeedleColor: child.outerNeedleColor
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

            if(!tabBar.eventName && tab.eventName)
                tabBar.eventName = tab.eventName

            if(tab.eventValue)
                tabBar.itemAt(tab.tabIndex).eventValue = tab.eventValue

            for(var j = 0; j < tab.content.length; ++j){
                var widget = tab.content[j]

                var componentFile = GlobalDefinitions.componentName[widget.componentType]

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
                        if(widget.buttonGroup){
                            componentObject.clearButtons()
                            for(var index = 0; index < widget.buttonGroup.length; ++index){
                                componentObject.createButton(widget.buttonGroup[index].text, widget.buttonGroup[index].eventValue)
                            }
                        }
                        if(widget.highlightOnly !== undefined)
                            componentObject.highlightOnly = widget.highlightOnly
                        if(widget.imageSource)
                            componentObject.imageSource = widget.imageSource
                        if(widget.isFixedYAxis)
                            componentObject.isFixed = widget.isFixedYAxis
                        if(widget.fixedYAxisMax)
                            componentObject.maxYAxis = widget.fixedYAxisMax
                        if(widget.initialValue)
                            componentObject.initialValue = widget.initialValue
                        if(widget.isBalanced)
                            componentObject.isBalanced = widget.isBalanced
                        if(widget.outputScript)
                            componentObject.outputScript = widget.outputScript
                        if(widget.inputScript)
                            componentObject.inputScript = widget.inputScript
                        if(widget.shortcut)
                            componentObject.shortcut = widget.shortcut
                        if(widget.decreaseShortcut)
                            componentObject.decreaseShortcut = widget.decreaseShortcut
                        if(widget.increaseShortcut)
                            componentObject.increaseShortcut = widget.increaseShortcut         
                        if(widget.innerNeedleColor)
                            componentObject.innerNeedleColor = Qt.rgba(widget.innerNeedleColor.r, widget.innerNeedleColor.g, widget.innerNeedleColor.b, widget.innerNeedleColor.a)
                        if(widget.outerNeedleColor)
                            componentObject.outerNeedleColor = Qt.rgba(widget.outerNeedleColor.r, widget.outerNeedleColor.g, widget.outerNeedleColor.b, widget.outerNeedleColor.a)
                    }
                }
            }
        }
    }

    function saveCurrentChanges(){
        if(qtRobo.persistance.isFilenameValid){
            qtRobo.persistance.layout = window.layoutToArray()
            qtRobo.persistance.persist()

            GlobalDefinitions.projectPersisted()
        }
    }
}


