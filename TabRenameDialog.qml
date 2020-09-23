import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Dialog{
    id: root
    focus: true
    implicitWidth: 400
    implicitHeight: 350
    closePolicy: Qt.CloseOnPressOutside
    property var component
    property var tabBar
    title: qsTr("Connection")

    onAboutToShow: {
        listModel.clear()
        for(var i = 0; i < tabBar.count; ++i){
            listModel.append({"tabId": i})
        }
    }

    ListModel{
        id: listModel
    }

    ColumnLayout{
    spacing: 10
    ListView{
        id: list
        //anchors.fill: parent
        Layout.fillWidth: true
        height: 200
        model: listModel
        delegate: RowLayout{
            spacing: 10
            Label{
                width: 50
                text: "Tab " + tabId + ":"
            }

            TextField{
                text: tabBar.itemAt(tabId).text
                onTextChanged: tabBar.itemAt(tabId).text = text
            }

            Label{
                text: "Value:"
            }

            TextField{
                text: tabBar.itemAt(tabId).eventValue !== undefined ? tabBar.itemAt(tabId).eventValue : ""
                onTextChanged: {
                    GlobalDefinitions.projectEdited()
                    tabBar.itemAt(tabId).eventValue = text
                }
            }
        }

        ScrollBar.vertical: ScrollBar{}
    }

    RowLayout{

        Label{
            text:"Event:"
        }

        TextField{
            text: tabBar.eventName !== undefined ? tabBar.eventName : ""
            onTextChanged: {
                GlobalDefinitions.projectEdited()
                tabBar.eventName = text
            }
        }
    }
    }
}
