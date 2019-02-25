 import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog{
    id: root
    width: 200
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
            text: "Event Start:"
        }

        TextField{
            id: eventStart
            Layout.fillWidth: true
            text: String.fromCharCode(serialConnection.eventStart)
            onTextChanged: text.length > 1 ? text = text.charAt(text.length - 1) : text
        }

        Text{
            text: "Separator:"
        }

        TextField{
            id: separator
            Layout.fillWidth: true
            text: String.fromCharCode(serialConnection.eventValueDivider)
            onTextChanged: text.length > 1 ? text = text.charAt(text.length - 1) : text
        }

        Text{
            text: "EOL"
        }

        ComboBox{
            id: eol
            Layout.fillWidth: true
            textRole: "description"
            currentIndex: getIndexFromValue(eolModel, serialConnection.eventEOL)
            property var currentItem: eolModel.get(currentIndex)

            model: ListModel{
                id: eolModel
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
            text: "OK"
            Layout.alignment: Qt.AlignCenter
            onClicked:  root.accept()
        }

        Button{
            text: "Cancel"
            Layout.alignment: Qt.AlignCenter
            onClicked: root.reject()
        }
    }

    onAccepted: {
        if(eventStart.text)
            serialConnection.eventStart = eventStart.text.charCodeAt(0)

        if(separator.text)
            serialConnection.eventValueDivider = separator.text.charCodeAt(0)

        serialConnection.eventEOL = eol.currentItem.value.charCodeAt(0)
    }
}
