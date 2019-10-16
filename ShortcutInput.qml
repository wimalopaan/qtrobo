import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item {
    id: root
    width: 150
    height: 50
    property string sequence: ""
    onSequenceChanged: {
        if(sequence.length > 0)
            shortcutButton.text = sequence
        else
            shortcutButton.text = "None"

        GlobalDefinitions.projectEdited()
    }

    Button{
        width: 100
        id: shortcutButton
        text: "None"
        Layout.fillWidth: true
        onClicked: {
            focus = true
            sequence = ""
        }

        Keys.onPressed: {
            if(shortcutButton.focus){

                switch(event.modifiers){
                case Qt.ShiftModifier:
                    root.sequence = "Shift"
                    break
                case Qt.ControlModifier:
                    root.sequence = "Ctrl"
                    break
                case Qt.AltModifier:
                    root.sequence = "Alt"
                    break
                }

                if(event.modifiers === Qt.NoModifier){
                    shortcutButton.focus = false
                    if(root.sequence.length > 0)
                        root.sequence = root.sequence + "+"

                    root.sequence = root.sequence + event.text
                }
                event.accepted = true
            }
        }
    }

    Button{
        anchors.left:  shortcutButton.right
        anchors.leftMargin: 10
        text: "🗑"
        onClicked: root.sequence = ""
    }
}
