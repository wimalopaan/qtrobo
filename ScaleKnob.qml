import QtQuick 2.0

Text{
    property var root
    text: "⇲"
    color: "#3F51B5"
    font.bold: true
    width: 15
    height: 15
    anchors.top: parent.bottom
    anchors.left: parent.right
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        drag{target: parent; axis: Drag.XAndYAxis}
        onPositionChanged: {
            if(drag.active){
                root.width = root.width + mouseX
                if(root.width < 30)
                    root.width = 30

                root.height= root.height + mouseY
                if(root.height < 30)
                    root.height = 30
            }
        }
    }
}
