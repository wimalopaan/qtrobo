import QtQuick 2.0

Rectangle{
    property var root

    radius: 45
    color: "lightblue"
    width: 15
    height: 15
    anchors.top: parent.bottom
    anchors.left: parent.right
    enabled: !display.enabled
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        drag{target: parent; axis: Drag.XAxis}
        onMouseXChanged: {
            if(drag.active){
                root.width = root.width + mouseX
                if(root.width < 50)
                    root.width = 50

                root.height= root.height + mouseY
                if(root.height < 50)
                    root.height = 50
            }
        }
    }
}
