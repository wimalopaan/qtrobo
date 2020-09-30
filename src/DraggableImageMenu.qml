import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2

GridLayout{
    property var component
    columns: 2

    Label{
        Layout.fillWidth: true
        text: qsTr("Image file:")
    }

    TextField{
        id: fileTextField
        Layout.fillWidth: true
        text: component.imageSource

        onTextChanged: component.imageSource = text

        MouseArea{
            anchors.fill: parent

            onClicked: fileDialog.open()
        }

        FileDialog{
            id: fileDialog
            nameFilters: ["Image files (*.jpg *.png *.gif *.bmp)", "All files (*)"]
            folder: shortcuts.home

            onAccepted: fileTextField.text = fileUrl
        }
    }
}
