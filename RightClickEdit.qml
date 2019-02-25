import QtQuick 2.0

MouseArea{
    property var root
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked:{
        var editPopupComponent = Qt.createComponent("EditMenuDialog.qml")
        var editPopup = editPopupComponent.createObject(root,  {component: root})
        editPopup.open()
    }
}
