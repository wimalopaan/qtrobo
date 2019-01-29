import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Controls")
    property var root

    MenuItem{
        text: qsTr("Button")
        onTriggered: root.createButton()

    }

    MenuItem{
        text: qsTr("Indicator Button")
        onTriggered: root.createButtonWithIndicator()
    }

    MenuItem{
        text: qsTr("Slider")
        onTriggered: root.createSlider()
    }

    MenuItem{
        text: qsTr("Balance Slider")
        onTriggered: root.createBalanceSlider()
    }

    MenuItem{
        text: qsTr("Display")
        onTriggered: root.createDisplay()
    }

    MenuItem{
        text: qsTr("LED")
        onTriggered: root.createLED()
    }
}
