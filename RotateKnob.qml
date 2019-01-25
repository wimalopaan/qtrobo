import QtQuick 2.0

Text{
    property var root
    property var orientation
    text: "↻"
    color: "#3F51B5"
    font.bold: true
    width: 15
    height: 15
    anchors.top: parent.bottom
    anchors.right: parent.left
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            if(orientation){
                orientation.orientation = orientation.orientation === Qt.Horizontal ? Qt.Vertical : Qt.Horizontal
                var rootHeight = root.height
                root.height = root.width
                root.width = rootHeight
            }
        }
    }
}
