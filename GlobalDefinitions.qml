pragma Singleton
import QtQuick 2.0

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
}
