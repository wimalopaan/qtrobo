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
                text: component.displayedName
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
                Text{
                    Layout.fillWidth: true
                    text: "Control Name:"
                }

                TextField{
                    Layout.fillWidth: true
                    text: component.label

                    onTextChanged: component.label = text
                }

                Text{
                    Layout.fillWidth: true
                    text: "Event Name:"
                }

                TextField{
                    Layout.fillWidth: true
                    text: component.eventName

                    onTextChanged: component.eventName = text
                }

                Text{
                    Layout.fillWidth: true
                    text: "Font Color:"
                }

                TextField{
                    Layout.fillWidth: true
                    text: fontColorPicker.color


                    MouseArea{
                        anchors.fill: parent
                        onClicked: fontColorPicker.open()
                    }

                    SpecialDialogs.ColorDialog{
                        id: fontColorPicker
                        color: "black"
                    }
                }

                Text{
                    Layout.fillWidth: true
                    text: "Component Color:"
                }

                TextField{
                    Layout.fillWidth: true
                    text: componentColorPicker.color


                    MouseArea{
                        anchors.fill: parent
                        onClicked: componentColorPicker.open()
                    }

                    SpecialDialogs.ColorDialog{
                        id: componentColorPicker
                        color: component.componentColor ? component.componentColor : "lightgray"
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
        else
            return ""
    }

    onAccepted: GlobalDefinitions.layoutEdited()
}
