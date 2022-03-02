import QtQuick 2.0
import QtQuick.Controls 2.5

Menu{
    title: qsTr("Controls")
    property var root
    property int widgetX
    property int widgetY
    contentHeight: 400


        Repeater{
            model: GlobalDefinitions.componentName
            MenuItem{
                text: qsTr(GlobalDefinitions.componentDisplayName[index])
                onTriggered: {
                    if(widgetX && widgetY)
                        root.createComponent(index, widgetX, widgetY)
                    else
                        root.createComponent(index)
                }
            }
        }



}
