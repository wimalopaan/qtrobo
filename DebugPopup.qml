import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog{
    id: root

    width: 400
    height: 500


    ScrollView{
        anchors.fill: parent
        TextArea{
            id: debugTextArea
            anchors.fill: parent
            readOnly: true
        }


        Connections{
            target: serialConnection
            onDebugChanged: {
                var debugString = debug.toString()
                debugString = debugString.replace("\n", "\\n").replace("\r", "\\r").replace("\0", "\\0")
                debugTextArea.append(debugString)
            }
        }
    }
}
