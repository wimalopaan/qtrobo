import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2 as SpecialDialogs

Dialog{
    id: root
    focus: true
    implicitWidth: 500
    closePolicy: Qt.CloseOnPressOutside
    title: qsTr("Control Preferences")

    property var component

    contentItem: ColumnLayout{
        spacing: 10
        TabBar{
            id: tabBar
            Layout.fillWidth: true
            TabButton{
                text: qsTr("General")
                font.capitalization: Font.MixedCase
            }

            TabButton{
                text: qsTr("Output Script")
                font.capitalization: Font.MixedCase
                enabled: component.hasOwnProperty('outputScript')
            }

            TabButton{
                text: qsTr("Input Script")
                font.capitalization: Font.MixedCase
                enabled: component.hasOwnProperty('inputScript')
            }

            TabButton{
                text: GlobalDefinitions.getDisplayName(component.componentType)
                font.capitalization: Font.MixedCase
                enabled: loadComponentMenu(component) !== ""
            }
        }

        StackLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: tabBar.currentIndex

            GridLayout{
                columns: 2
                Layout.fillWidth: true
                Label{
                    Layout.fillWidth: true
                    text: qsTr("Control Name:")
                    enabled: component.label !== undefined
                }

                TextField{
                    Layout.fillWidth: true
                    text: component.label ? component.label : ""
                    enabled: component.label !== undefined

                    onTextChanged: component.label = text
                }

                Label{
                    Layout.fillWidth: true
                    text: qsTr("Event Name:")
                    enabled: component.eventName !== undefined
                }

                TextField{
                    Layout.fillWidth: true
                    text: component.eventName ? component.eventName : ""
                    enabled: component.eventName !== undefined

                    onTextChanged: component.eventName = text
                }

                Label{
                    Layout.fillWidth: true
                    text: qsTr("Font Color:")
                    enabled: component.fontColor !== undefined
                }

                TextField{
                    Layout.fillWidth: true
                    text: fontColorPicker.color
                    enabled: component.fontColor !== undefined


                    MouseArea{
                        anchors.fill: parent
                        onClicked: fontColorPicker.open()
                    }

                    SpecialDialogs.ColorDialog{
                        id: fontColorPicker
                        color: component.fontColor ? component.fontColor : "black"
                        onAccepted: {
                            if(component.fontColor)
                                component.fontColor = color
                        }
                    }
                }

                Label{
                    Layout.fillWidth: true
                    text: qsTr("Component Color:")
                    enabled: component.componentColor !== undefined
                }

                TextField{
                    Layout.fillWidth: true
                    text: componentColorPicker.color
                    enabled: component.componentColor !== undefined


                    MouseArea{
                        anchors.fill: parent
                        onClicked: componentColorPicker.open()
                    }

                    SpecialDialogs.ColorDialog{
                        id: componentColorPicker
                        color: component.componentColor ? component.componentColor : "black"
                        onAccepted: {
                            if(component.componentColor)
                                component.componentColor = color
                        }
                    }
                }
            }

            ScrollView{
                id: outputScriptScrollView
                Layout.fillWidth: true
                anchors.margins: 10
                contentWidth: width
                focus: true
                background: Rectangle{
                    anchors.fill: parent
                    anchors.margins: -5
                    color: "lightgray"
                    border.width: 2
                    border.color: "gray"

                    Text{
                        text: "🛈"
                        font.pointSize: 14
                        anchors.horizontalCenter: parent.right
                        anchors.bottom: parent.top

                        MouseArea{

                            anchors.fill: parent

                            onClicked: outputScriptInfoPopup.open()

                            Popup{
                                id: outputScriptInfoPopup
                                x: parent.mouseX
                                y: parent.mouseY
                                width: 350

                                TextArea{
                                    anchors.fill: parent
                                    textFormat: "RichText"

                                    text: "<h3>Information</h3><p>Javascript based output modification.</p><p>Global input / output variables are:</p><b>value</b>: string<br><b>event</b>: string"

                                }

                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                            }
                        }
                    }
                }

                TextArea{
                    id: outputScriptTextArea
                    readOnly: false
                    focus: true
                    text: component.outputScript ? component.outputScript : ""

                    onTextChanged: component.outputScript = text
                }
            }

            ScrollView{
                id: inputScriptScrollView
                Layout.fillWidth: true
                anchors.margins: 10
                contentWidth: width
                focus: true
                background: Rectangle{
                    anchors.fill: parent
                    anchors.margins: -5
                    color: "lightgray"
                    border.width: 2
                    border.color: "gray"

                    Text{
                        text: "🛈"
                        font.pointSize: 14
                        anchors.horizontalCenter: parent.right
                        anchors.bottom: parent.top

                        MouseArea{

                            anchors.fill: parent

                            onClicked: inputScriptInfoPopup.open()

                            Popup{
                                id: inputScriptInfoPopup
                                x: parent.mouseX
                                y: parent.mouseY
                                width: 350

                                TextArea{
                                    anchors.fill: parent
                                    textFormat: "RichText"

                                    text: "<h3>Information</h3><p>Javascript based output modification.</p><p>Global input / output variables are:</p><b>value</b>: string<br>"

                                }

                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                            }
                        }
                    }
                }

                TextArea{
                    id: inputScriptTextArea
                    readOnly: false
                    focus: true
                    text: component.inputScript ? component.inputScript : ""

                    onTextChanged: component.inputScript = text
                }
            }

            Loader{
                source:loadComponentMenu(component)
                onLoaded: {
                    item.component = component

                    if(item.loaded){
                        item.loaded()
                    }
                }
                Layout.fillWidth: true
            }
        }
        Keys.onReturnPressed: root.accept()
    }

    function loadComponentMenu(component){
        if(component instanceof DraggableDropdown)
            return "DraggableDropdownMenu.qml"
        else if(component instanceof DraggableSlider)
            return "DraggableSliderMenu.qml"
        else if(component instanceof DraggableImage)
            return "DraggableImageMenu.qml"
        else if(component instanceof DraggableCircularGauge || component instanceof DraggableLinearGauge)
            return "DraggableGaugeMenu.qml"
        else if(component instanceof DraggableChart)
            return "DraggableChartMenu.qml"
        else if(component instanceof DraggableSpinbox)
            return "DraggableSpinboxMenu.qml"
        else if(component instanceof DraggablePotentiometer)
            return "DraggablePotentiometerMenu.qml"
        else if(component instanceof DraggableButton)
            return "DraggableButtonMenu.qml"
        else if(component instanceof DraggableIndicatorButton)
            return "DraggableIndicatorButtonMenu.qml"
        else if(component instanceof DraggableTextInput)
            return "DraggableTextInputMenu.qml"
        else if(component instanceof DraggableButtonGroup)
            return "DraggableButtonGroupMenu.qml"
        else
            return ""
    }

    onAccepted: GlobalDefinitions.projectEdited()
}
