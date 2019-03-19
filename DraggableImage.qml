import QtQuick 2.9
import QtQuick.Controls 2.5

Item{
    id: root
    width: 200
    height: width * (image.sourceSize.height / image.sourceSize.width)
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
