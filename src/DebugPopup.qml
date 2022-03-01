import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtRobo.DebugInfoDirection 1.0

import DebugMessage 1.0

Window{
    id: root
    width: 400
    height: 500

    property string red: "#b3ffe6"
    property string blue: "#ffb3b3"


    ListView{



               id: debugList
               anchors.fill: parent
               model: DebugMessageModel{
                    list: debugMessageList
               }
               onCountChanged: {
                   Qt.callLater( debugList.positionViewAtEnd )
               }
               clip: true
               delegate: Text{
                   text: model.message
                   verticalAlignment: Text.AlignBottom
                   font.pointSize: 10
                   //leftPadding: 20
                   //rightPadding: 20
               }




}

}
