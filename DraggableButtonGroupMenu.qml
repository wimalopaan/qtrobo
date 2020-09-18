import QtQuick 2.9
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

Item{
    property var component
    property var buttonGroup: component.buttonGroup

    function loaded(){
        listModel.clear()
        for(var i = 0; i < buttonGroup.children.length; ++i){
            listModel.append({"btnId": i})
        }
    }

    ButtonGroup{
        id: activeTypeGroup
        onCheckedButtonChanged: GlobalDefinitions.projectEdited()
    }

    ColumnLayout{
        anchors.fill: parent


        ListModel{
            id: listModel
        }

        ListView{
            id: list
            model: listModel
            Layout.fillHeight: true
            Layout.fillWidth: true
            delegate: RowLayout{
                spacing: 10
                Label{
                    text: "Name:"
                }

                TextField{
                    text: buttonGroup.children[btnId].text !== undefined ? buttonGroup.children[btnId].text : ""
                    onTextChanged: {
                        buttonGroup.children[btnId].text = text
                        GlobalDefinitions.projectEdited()
                    }
                }

                Label{
                    text: "Value:"
                }

                TextField{
                    text: buttonGroup.children[btnId].eventValue !== undefined ? buttonGroup.children[btnId].eventValue : ""
                    onTextChanged: {
                        buttonGroup.children[btnId].eventValue = text
                        GlobalDefinitions.projectEdited()
                    }
                }
            }

            ScrollBar.vertical: ScrollBar{}
        }

        RowLayout{
            id: buttonLayout
            Layout.fillWidth: true
            Button{
                text: "+"
                onClicked: {
                    component.createButton()
                    loaded()
                    GlobalDefinitions.projectEdited()
                }
            }

            Button{
                text: "-"
                enabled: buttonGroup.children.length > 1
                onClicked:{
                    var buttonList = component.buttonGroup.children
                    if(buttonList.length > 1){
                        listModel.clear()

                        buttonGroup.children = Array.from(buttonList).slice(0, buttonList.length - 1)
                        loaded()
                    }

                    GlobalDefinitions.projectEdited()
                }
            }

            Label{
                text: "Activationtype:"
            }


            RadioButton{
                text: "Highlighted"
                checked: component.highlightOnly
                ButtonGroup.group: activeTypeGroup
                onCheckedChanged: component.highlightOnly = checked
            }

            RadioButton{
                text: "Disabled"
                ButtonGroup.group: activeTypeGroup
                checked: !component.highlightOnly
            }

        }
    }
}
