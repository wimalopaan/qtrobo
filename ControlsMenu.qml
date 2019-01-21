import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Controls")
    property var root

    MenuItem{
        text: "Button"
        onTriggered: root.createButton()

    }

    MenuItem{
        text: "Slider"
        onTriggered: root.createSlider()
    }

    MenuItem{
        text: "Display"
        onTriggered: root.createDisplay()
    }
}
