import QtQuick 2.9
import QtQuick.Controls 2.5

Item{
    id: root

    property string displayedName: qsTr("Image")
    property alias enabled: image.enabled
    property var componentType: GlobalDefinitions.ComponentType.Image
    property bool edible: true
    property alias imageSource: image.source
    onEdibleChanged: enabled = !edible


    Image{
        id: image
        anchors.fill: parent
        source: "placeholder_image.png"

        onStatusChanged: {
            if(status === Image.Error || status === Image.Null)
                source = "placeholder_image.png"
            else if(status === Image.Ready){
                root.width = 200
                root.height = root.width * (sourceSize.height / sourceSize.width)
            }

        }
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }

    ScaleKnob{
        root: root
        enabled: root.edible
    }

    RightClickEdit{
        root: root
        enabled: root.edible
    }
}
