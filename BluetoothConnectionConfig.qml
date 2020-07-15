import QtQuick 2.3
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout{
    anchors.fill: parent
    spacing: 20
    Rectangle{
        Layout.fillHeight: true
        Layout.fillWidth: true
        border.width: 1
        border.color: "gray"

        ListView{

            id: list
            ScrollBar.vertical: ScrollBar{}
            anchors.fill: parent

            model: ListModel{
                id: bluetoothServices
            }

            delegate: Rectangle{
                id: entry
                anchors.left: parent.left
                anchors.right: parent.right
                property alias deviceName: deviceName
                border.width: 1
                border.color: "gray"
                height: 25
                color: list.currentIndex == index ? "lightblue" : "white"

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        list.currentIndex = index
                        output.text = "Choice: " + bluetoothServices.get(index).name + "{" + bluetoothServices.get(index).addr + "}"
                    }
                }

                RowLayout{
                    anchors.fill: parent
                    spacing: 10

                    Label{
                        text: key
                    }
                    Label{
                        id: deviceName
                        text: name
                    }
                    Label{
                        id: deviceAddr
                        text: addr
                    }
                }
            }
        }
    }

    RowLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true
        Button{
            id: scanButton
            enabled: !qtRobo.connection.isDiscovering
            text: qsTr("Scan")
            onClicked: {
                bluetoothServices.clear()
                qtRobo.connection.startDiscovery()
            }
        }

        Button{
            id: stopButton
            enabled: qtRobo.connection.isDiscovering
            text: qsTr("Stop")
            onClicked: qtRobo.connection.stopDiscovery()
        }
        Button{
            text: "test"
            property int index: 0
            onClicked: bluetoothServices.append({"key": index++, "name": "tets", "addr":"00:11:22:33:33"})
        }
    }

    Label{
        id: output
        height: 20
        Layout.fillWidth: true
    }

    Connections{
        target: qtRobo.connection

        function onError(error){
            output.text = "Error:" + error
        }

        function onServicesChanged(){
            var services = qtRobo.connection.services
            bluetoothServices.clear()


            for(const key in services){
                var service = services[key]
                bluetoothServices.append({
                                             "key": key,
                                             "name": service.name,
                                             "addr": service.addr
                                         })
            }
        }
    }
}
