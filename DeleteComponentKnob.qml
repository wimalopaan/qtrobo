import QtQuick 2.0

Text{
    property var root

    text: "🗑"
    font.pointSize: 12
    color: "red"
    anchors.bottom: root.top
    anchors.left: root.right
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: root.destroy()
    }
}
