import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QSerialPort 0.1


GridLayout{
    anchors.left: parent.left
    anchors.right: parent.right
    columns: 2
    rows: 3

    Component.onCompleted: {
        var interfaces = qtRobo.connection.serialInterfaces()

        for(var i = 0; i < interfaces.length; ++i)
            interfaceModel.append({'interfaceName': interfaces[i]})
    }

    function getIndexFromValue(listModel, value){
        for(var i = 0; i < listModel.count; ++i){
            if(listModel.get(i).value === value)
                return i
        }

        return 0
    }

    Label{
        text: "Interface:"
        Layout.fillWidth: true
    }

    ComboBox{
        id: interfaceCombobox
        Layout.fillWidth: true
        textRole: "interfaceName"
        currentIndex: 0
        model: ListModel{
            id: interfaceModel
        }
    }

    Label{
        text: "Baudrate:"
        Layout.fillWidth: true
    }

    ComboBox{
        id: baudrateCombobox
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(baudrateModel, qtRobo.connection.preferences.baudrate)
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
        text: "Stopbits:"
        Layout.fillWidth: true
    }

    ComboBox{
        id: stopbitCombobox
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(stopbitModel, qtRobo.connection.preferences.stopbit)
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
        text: "Parity:"
        Layout.fillWidth: true
    }

    ComboBox{
        id: paritybitCombobox
        Layout.fillWidth: true
        textRole: "description"
        currentIndex: getIndexFromValue(paritybitModel, qtRobo.connection.preferences.paritybit)
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

