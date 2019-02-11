import QtQuick 2.0
import QtQuick.Controls 2.5

TabButton{
    text: qsTr("New Tab")
    font.capitalization: Font.MixedCase
    property alias editEnabled: editMouseArea.enabled

    MouseArea{
        id: editMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: textEdit.visible = true
    }
    TextField{
        property string textCache
        id: textEdit
        anchors.centerIn: parent
        visible: false
        text: parent.text

        onVisibleChanged: {
            if(visible){
                textCache = parent.text
                parent.text = ""
            }else{
                parent.text = textCache
            }
        }
        Keys.onReturnPressed: {
            textCache = text
            visible = false
        }

    }
}

