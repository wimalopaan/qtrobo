import QtQuick 2.0
import QtQuick.Controls 2.5

TabButton{
    text: qsTr("New Tab")
    font.capitalization: Font.MixedCase
    property alias editEnabled: editMouseArea.enabled

    onTextChanged: GlobalDefinitions.projectEdited()

    MouseArea{
        id: editMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: textEdit.visible = textEdit.focus = true
    }
    TextField{
        property string textCache
        id: textEdit
        anchors.centerIn: parent
        visible: false
        text: parent.text

        onFocusChanged: {
            if(!focus)
                visible = false
        }

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

