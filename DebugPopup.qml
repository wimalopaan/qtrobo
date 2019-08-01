import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtRobo.DebugInfoDirection 1.0

Window{
    id: root
    width: 400
    height: 500

    property string red: "#b3ffe6"
    property string blue: "#ffb3b3"

    ScrollView{
        id: scrollView
        anchors.fill: parent
        anchors.margins: 10
        contentWidth: width
        focus: true

        TextArea{
            id: debugTextArea
            readOnly: true
            textFormat: Text.RichText
            focus: true


            function createDebugText(direction, debugText, color){
                var formattedText = "<table align=\"center\" width=\"100%\">";
                formattedText = formattedText.concat("<tr width=\"100%\" style=\"background-color:" + color + "\"><td width=\"10%\">")
                formattedText = formattedText.concat(direction)
                formattedText = formattedText.concat("</td><td>" + debugText + "</td></tr>")

                formattedText = formattedText.concat("</table>")

                return formattedText
            }
        }

        Connections{
            id: connection
            target: qtRobo.connection
            onDebugChanged:  {

                if(direction === DebugInfoDirection.In)
                    debugTextArea.append(debugTextArea.createDebugText("In", debug, root.red))
                else if(direction === DebugInfoDirection.Out)
                    debugTextArea.append(debugTextArea.createDebugText("Out", debug, root.blue))
            }


        }
    }
}

