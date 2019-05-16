import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog{
    id: root
    width: 300
    title: qsTr("Event Settings")

    function getIndexFromValue(listModel, value){
         for(var i = 0; i < listModel.count; ++i){
             if(listModel.get(i).value.charCodeAt(0) === value)
                 return i
         }

         return 0
    }

    GridLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 2
        rows: 3

        Text{
            text: qsTr("Event Start:")
        }

        TextField{
            id: eventStart
            Layout.fillWidth: true
            text: String.fromCharCode(qtRobo.connection.messageParser.eventStart)
            onTextChanged: text.length > 1 ? text = text.charAt(text.length - 1) : text
        }

        Text{
            text: qsTr("Event Value Separator:")
        }

        TextField{
            id: eventValueDivider
            Layout.fillWidth: true
            text: String.fromCharCode(qtRobo.connection.messageParser.eventValueDivider)
            onTextChanged: text.length > 1 ? text = text.charAt(text.length - 1) : text
        }

        Text{
            text: qsTr("Event End:")
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

    footer: RowLayout{
        Button{
            text: qsTr("OK")
            Layout.alignment: Qt.AlignCenter
            onClicked:  root.accept()
        }

        Button{
            text: qsTr("Cancel")
            Layout.alignment: Qt.AlignCenter
            onClicked: root.reject()
        }
    }

    onAccepted: {
        if(eventStart.text)
            serialConnection.eventStart = eventStart.text.charCodeAt(0)

        if(eventValueDivider.text)
            serialConnection.eventValueDivider = eventValueDivider.text.charCodeAt(0)

        serialConnection.eventEnd = eventEnd.currentItem.value.charCodeAt(0)
    }
}
