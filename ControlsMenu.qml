import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Controls")
    property var root

    Repeater{
        model: GlobalDefinitions.componentName
        MenuItem{
            text: qsTr(GlobalDefinitions.componentDisplayName[index])
            onTriggered: root.createComponent(index)
        }
    }
}
