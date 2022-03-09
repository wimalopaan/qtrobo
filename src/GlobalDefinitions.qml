pragma Singleton
import QtQuick 2.9

QtObject{
    property bool isGridMode: false
    property bool isEditMode: true
    property int gridModeStepSize: 20
    property bool hasLayoutBeenEdited: false
    property bool recording: false
    property bool isShowingDebugWindow:false

    function projectEdited(){
        hasLayoutBeenEdited = true
    }

    function projectPersisted(){
        hasLayoutBeenEdited = false
    }

    function invertRecording(){
        recording = !recording
    }

    function invertDebugWindow(){
        isShowingDebugWindow = !isShowingDebugWindow;
    }

    enum ComponentType{
        Button,
        IndicatorButton,
        Slider,
        Dropdown,
        LED,
        SerialDisplay,
        Spinbox,
        Image,
        TextInput,
        CircularGauge,
        LinearGauge,
        Chart,
        Potentiometer,
        ButtonGroup,
        CircularSpeedbar,
        Speedbar,
        Windrose,
        SpeedGauge


    }

    property var componentName: [
        "DraggableButton",
        "DraggableIndicatorButton",
        "DraggableSlider",
        "DraggableDropdown",
        "DraggableLED",
        "DraggableSerialDisplay",
        "DraggableSpinbox",
        "DraggableImage",
        "DraggableTextInput",
        "DraggableCircularGauge",
        "DraggableLinearGauge",
        "DraggableChart",
        "DraggablePotentiometer",
        "DraggableButtonGroup",
        "DraggableCircularSpeedbar",
        "DraggableSpeedbar",
        "DraggableWindrose",
        "DraggableSpeedGauge"

    ]

    property var componentDisplayName: [
        qsTr("Button"),
        qsTr("Indicator Button"),
        qsTr("Slider"),
        qsTr("Dropdown"),
        qsTr("LED"),
        qsTr("Serial Display"),
        qsTr("Spinbox"),
        qsTr("Image"),
        qsTr("Text Input"),
        qsTr("Circular Gauge"),
        qsTr("Linear Gauge"),
        qsTr("Chart"),
        qsTr("Potentiometer"),
        qsTr("Button Group"),
        qsTr("Circular Speedbar"),
        qsTr("Speedbar"),
        qsTr("Windrose"),
        qsTr("Speed Gauge")

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
