import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Controls")
    property var root

    MenuItem{
        text: qsTr("Button")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.Button)
    }

    MenuItem{
        text: qsTr("Indicator Button")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.IndicatorButton)
    }

    MenuItem{
        text: qsTr("Slider")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.Slider)
    }

    MenuItem{
        text: qsTr("Balance Slider")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.BalanceSlider)
    }

    MenuItem{
        text: qsTr("Display")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.SerialDisplay)
    }

    MenuItem{
        text: qsTr("LED")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.LED)
    }

    MenuItem{
        text: qsTr("Dropdown")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.Dropdown)
    }

    MenuItem{
        text: qsTr("Spinbox")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.Spinbox)
    }

    MenuItem{
        text: qsTr("Image")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.Image)
    }

    MenuItem{
        text: qsTr("Text Input")
        onTriggered: root.createComponent(GlobalDefinitions.ComponentType.TextInput)
    }
}
