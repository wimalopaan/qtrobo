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

        TextArea{
            id: debugTextArea
            anchors.fill: parent
            readOnly: true
        }


        Connections{
            target: serialConnection
            onDebugChanged:  debugTextArea.append(debug)
        }
    }
}

