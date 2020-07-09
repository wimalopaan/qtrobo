import QtQuick 2.0

Text{
    property var root
    text: "✏"
    color: "#3F51B5"
    font.pointSize: 18
    font.bold: true
    width: 30
    height: 30
    anchors.bottom: parent.top
    anchors.right: parent.left
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            var editPopupComponent = Qt.createComponent("EditMenuDialog.qml")
            var editPopup = editPopupComponent.createObject(root,  {component: root})
            editPopup.open()
        }
    }
}


