pragma Singleton
import QtQuick 2.9

QtObject{
    property bool isGridMode: false
    property bool isEditMode: true
    property int gridModeStepSize: 20
    property bool hasLayoutBeenEdited: false

    function layoutEdited(){
        hasLayoutBeenEdited = true
    }

    function layoutPersisted(){
        hasLayoutBeenEdited = false
    }

    enum ComponentType{
        Button,
        IndicatorButton,
        Slider,
        BalanceSlider,
        Dropdown,
        LED,
        SerialDisplay,
        Spinbox,
        Image,
        TextInput,
        CircularGauge,
        LinearGauge,
        Chart
    }

    property var componentName: [
        "DraggableButton",
        "DraggableIndicatorButton",
        "DraggableSlider",
        "DraggableBalanceSlider",
        "DraggableDropdown",
        "DraggableLED",
        "DraggableSerialDisplay",
        "DraggableSpinbox",
        "DraggableImage",
        "DraggableTextInput",
        "DraggableCircularGauge",
        "DraggableLinearGauge",
        "DraggableChart"
    ]

    property var componentDisplayName: [
        "Button",
        "Indicator Button",
        "Slider",
        "Balance Slider",
        "Dropdown",
        "LED",
        "Serial Display",
        "Spinbox",
        "Image",
        "Text Input",
        "Circular Gauge",
        "Linear Gauge",
        "Chart"
    ]

    function getDisplayName(componentType){
        return componentDisplayName[componentType]
    }

    function mapToValueRange(value, fromMin, fromMax, toMin, toMax){
        var result = 1 / (fromMax - fromMin)
        result = result * (value - fromMin)
        result = result * (toMax - toMin)
        result = result + toMin
        return (result | 0)
    }
}
