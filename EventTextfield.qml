import QtQuick 2.0


TextInput {
    property var dragcomponent
    text: dragcomponent.eventName
    width: 40
    height: 20
    onTextChanged: {
        dragcomponent.eventName = text
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Return)
            destroy()
    }
}
