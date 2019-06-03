import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5




GridLayout{
    Layout.fillWidth: true
    columns: 2
    rows: 3

    property var eventStart: eventStart.text.charCodeAt(0)
    property var eventEnd: eventEnd.currentItem.value.charCodeAt(0)
    property var eventValueDivider: eventValueDivider.text.charCodeAt(0)

    function getIndexFromValue(listModel, value){
        for(var i = 0; i < listModel.count; ++i){
            if(listModel.get(i).value.charCodeAt(0) === value)
                return i
        }

        return 0
    }

    Text{
        text: qsTr("Event Start:")
        Layout.fillWidth: true
    }

    TextField{
        id: eventStart
        Layout.fillWidth: true
        text: String.fromCharCode(qtRobo.connection.messageParser.eventStart)
        onTextChanged: text.length > 1 ? text = text.charAt(text.length - 1) : text
    }

    Text{
        text: qsTr("Event Value Separator:")
        Layout.fillWidth: true
    }

    TextField{
        id: eventValueDivider
        Layout.fillWidth: true
        text: String.fromCharCode(qtRobo.connection.messageParser.eventValueDivider)
        onTextChanged: text.length > 1 ? text = text.charAt(text.length - 1) : text
    }

    Text{
        text: qsTr("Event End:")
        Layout.fillWidth: true
    }

    ComboBox{
        id: eventEnd
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(eventEndModel, qtRobo.connection.messageParser.eventEnd)
        property var currentItem: eventEndModel.get(currentIndex)

        model: ListModel{
            id: eventEndModel
            ListElement{
                description: "\\n"
                value: "\n"
            }

            ListElement{
                description: "\\r"
                value: "\r"
            }

            ListElement{
                description: "\\0"
                value: "\0"
            }
        }
    }
}

