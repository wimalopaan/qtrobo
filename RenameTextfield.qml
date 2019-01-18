import QtQuick 2.0


TextInput {
    property var dragcomponent
    text: dragcomponent.text
    width: 40
    height: 20
    objectName: "menutextfield"
    onTextChanged: {
        dragcomponent.text = text
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Return)
            destroy()
    }
}
