import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QSerialPort 0.1


GridLayout{
    Layout.fillWidth: true
    columns: 2
    rows: 3

    property string interfaceName
    property alias baudrate: baudrateCombobox.currentItem
    property alias stopbits: stopbitCombobox.currentItem
    property alias paritybits: paritybitCombobox.currentItem

    Component.onCompleted: {
        var interfaces = qtRobo.connection.serialInterfaces()

        for(var i = 0; i < interfaces.length; ++i)
            interfaceModel.append({'value': interfaces[i]})

        if(interfaces.length > 0)
            interfaceName = interfaces[0]
    }

    function getIndexFromValue(listModel, value){
        for(var i = 0; i < listModel.count; ++i){
            if(listModel.get(i).value === value)
                return i
        }

        return 0
    }

    Label{
        text: qsTr("Interface:")
        Layout.fillWidth: true
    }

    ComboBox{
        id: interfaceCombobox
        Layout.fillWidth: true
        textRole: "value"
        currentIndex: 0

        property var currentItem: interfaceModel.get(currentIndex)

        model: ListModel{
            id: interfaceModel
        }

        onCurrentIndexChanged: {
            currentItem = interfaceModel.get(currentIndex);

            if(currentItem)
                interfaceName = currentItem.value
        }
    }

    Label{
        text: qsTr("Baudrate:")
        Layout.fillWidth: true
    }

    ComboBox{
        id: baudrateCombobox
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(baudrateModel, qtRobo.connection.preferences.serialBaudrate)
        property var currentItem: baudrateModel.get(currentIndex)

        model:ListModel{
            id: baudrateModel

            ListElement{
                description: "1200"
                value: QSerialPort.Baud1200
            }

            ListElement{
                description: "2400"
                value: QSerialPort.Baud2400
            }

            ListElement{
                description: "4800"
                value: QSerialPort.Baud4800
            }

            ListElement{
                description: "9600"
                value: QSerialPort.Baud9600
            }

            ListElement{
                description: "19200"
                value: QSerialPort.Baud19200
            }

            ListElement{
                description: "38400"
                value: QSerialPort.Baud38400
            }

            ListElement{
                description: "57600"
                value: QSerialPort.Baud57600
            }

            ListElement{
                description: "115200"
                value: QSerialPort.Baud115200
            }

            ListElement{
                description: "Unknown"
                value: QSerialPort.UnknownBaud
            }
        }
    }


    Label{
        text: qsTr("Stopbits:")
        Layout.fillWidth: true
    }

    ComboBox{
        id: stopbitCombobox
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(stopbitModel, qtRobo.connection.preferences.serialStopbit)
        property var currentItem: stopbitModel.get(currentIndex)

        model: ListModel{
            id: stopbitModel

            ListElement{
                description: "One"
                value: QSerialPort.OneStop
            }

            ListElement{
                description: "One And Half"
                value: QSerialPort.OneAndHalfStop
            }

            ListElement{
                description: "Two"
                value: QSerialPort.TwoStop
            }

            ListElement{
                description: "Unknown"
                value: QSerialPort.UnknownStopBits
            }
        }
    }

    Label{
        text: qsTr("Parity:")
        Layout.fillWidth: true
    }

    ComboBox{
        id: paritybitCombobox
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(paritybitModel, qtRobo.connection.preferences.serialParitybit)
        property var currentItem: paritybitModel.get(currentIndex)

        model: ListModel{
            id: paritybitModel

            ListElement{
                description: "None"
                value: QSerialPort.NoParity
            }

            ListElement{
                description: "Even"
                value: QSerialPort.EvenParity
            }

            ListElement{
                description: "Odd"
                value: QSerialPort.OddParity
            }

            ListElement{
                description: "Space"
                value: QSerialPort.SpaceParity
            }

            ListElement{
                description: "Mark"
                value: QSerialPort.MarkParity
            }

            ListElement{
                description: "Unknown"
                value: QSerialPort.UnknownParity
            }
        }
    }
}

