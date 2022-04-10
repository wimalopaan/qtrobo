import QtQuick 2.9
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

Rectangle{
    id: root

    color: "lightblue"

    property string eventName
    property color fontColor: "black"
    property bool edible: true
    property bool highlightOnly: true
    property var componentType: GlobalDefinitions.ComponentType.ButtonGroup
    property alias buttonGroup: buttonGroup
    property string  label: qsTr("New Button Group")
    property string outputScript
    onEdibleChanged: enabled = !edible
    property alias enabled: buttonGroup.enabled


    width: buttonGroup.width + 10
    height: buttonGroup.height

    onHighlightOnlyChanged: {
        if(highlightOnly){
            var buttons = buttonGroup.children;

            for(var i = 0; i < buttons.length; ++i){
                buttons[i].enabled = true
            }
        }
    }

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.fontColor = origin.fontColor
        root.label = origin.label
    }



    RowLayout{

        onChildrenChanged:  GlobalDefinitions.projectEdited()




        id: buttonGroup
        enabled: false
        anchors.right: parent.right
        anchors.rightMargin: 5

        Button{
            property string eventValue
            height: 30
            width: 50
            highlighted: true
            text: label
            onClicked: {
                selectButton(buttonGroup, this)
                send(eventValue)

            }

        }
    }

    function selectButton(group, button){
        var buttons = group.children;

        for(var i = 0; i < buttons.length; ++i){
            var item = buttons[i];

            if(!highlightOnly)
                item.enabled = (item !== button && item instanceof Button);


            item.highlighted = (item !== button && item instanceof Button);
        }
    }

    function createButton(text, eventValue){
        var newObject = Qt.createQmlObject('import QtQuick.Controls 2.15; Button {property string eventValue; text: "newBtn"; highlighted: true; onClicked:{selectButton(buttonGroup, this); send(eventValue);}}',
                                           buttonGroup);
        if(text)
            newObject.text = text
        if(eventValue)
            newObject.eventValue = eventValue
    }

    function clearButtons(){
        buttonGroup.children = []
    }

    function send(value){
        var modifiedEvent = eventName
        var modifiedData = value
        if(outputScript){
            var result = qtRobo.connection.javascriptParser.runScript(modifiedEvent, modifiedData, outputScript)
            if(result.value)
                modifiedData = result.value
            if(result.event)
                modifiedEvent = result.event
        }

        if(eventName)
            qtRobo.connection.write(modifiedEvent, modifiedData)
    }

    Connections{
        id: btnGroupConnector
        target: qtRobo.connection
        function onDataChanged(eventName, data){

            if(eventName === root.eventName && data){
            console.log("Event:" + eventName)
                var buttons = buttonGroup.children;

                for(var i = 0; i < buttons.length; ++i){
                    var item = buttons[i];

                    if(!highlightOnly)
                        item.enabled = (item.eventValue !== data && item instanceof Button);


                    item.highlighted = (item.eventValue !== data && item instanceof Button);
                }
            }
        }

        Component.onDestruction: serialConnector.target = null
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }


    RightClickEdit{
        root: root
        enabled: root.edible
    }
}
