import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2 as SpecialDialogs

Dialog{
    id: root
    focus: true
    implicitWidth: 350
    closePolicy: Qt.CloseOnPressOutside
    title: qsTr("Control Preferences")

    property var component

    contentItem: ColumnLayout{
        spacing: 50
        TabBar{
            id: tabBar
            Layout.fillWidth: true
            TabButton{
                text: "General"
                font.capitalization: Font.MixedCase
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
                    text: "Control Name:"
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
                    text: "Event Name:"
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
                    text: "Font Color:"
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
                    text: "Component Color:"
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

            Loader{
                source:loadComponentMenu(component)
                onLoaded: item.component = component
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
        else if(component instanceof DraggableBalanceSlider)
            return "DraggableBalanceSliderMenu.qml"
        else if(component instanceof DraggableImage)
            return "DraggableImageMenu.qml"
        else if(component instanceof DraggableCircularGauge || component instanceof DraggableLinearGauge)
            return "DraggableGaugeMenu.qml"
        else if(component instanceof DraggableChart)
            return "DraggableChartMenu.qml"
        else
            return ""
    }

    onAccepted: GlobalDefinitions.layoutEdited()
}
