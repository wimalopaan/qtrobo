import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Window{
    id: root
    width: 400
    height: 500

    ScrollView{
        anchors.fill: parent
        anchors.margins: 10

        TextArea{
            id: debugTextArea
            anchors.fill: parent
            readOnly: true
            textFormat: Text.RichText
        }

        Connections{
            target: qtRobo.connection
            onDebugChanged:  {
                var formattedText = "";
                if(debug.startsWith("In")){
                    formattedText = formattedText.concat("<span style=\"background-color: #b3ffe6;\">" + debug + "</span>");
                }else{
                    formattedText = formattedText.concat("<span style=\"background-color: #ffb3b3;\">" + debug + "</span>");
                }
                debugTextArea.append(formattedText)
            }
        }
    }
}

