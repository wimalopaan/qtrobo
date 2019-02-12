import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QSerialPort 0.1

Dialog{
    id: root
    width: 300
    height: 300
    title: qsTr("Serial Connection Config")
    closePolicy: Popup.CloseOnReleaseOutside
    property var component

    function getIndexFromValue(listModel, value){
         for(var i = 0; i < listModel.count; ++i){
             if(listModel.get(i).value === value)
                 return i
         }

         return 0
    }

    GridLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 2
        rows: 3

        Text{
            text: "Baudrate:"
        }

        ComboBox{
            id: baudrateCombobox
            Layout.fillWidth: true
            textRole: "description"
            currentIndex: getIndexFromValue(baudrateModel, serialConnection.baudrate)
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


        Text{
            text: "Stopbits:"
        }

        ComboBox{
            id: stopbitCombobox
            Layout.fillWidth: true
            textRole: "description"
            currentIndex: getIndexFromValue(stopbitModel, serialConnection.stopbit)
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

        Text{
            text: "Parity:"
        }

        ComboBox{
            id: paritybitCombobox
            Layout.fillWidth: true
            textRole: "description"
            currentIndex: getIndexFromValue(paritybitModel, serialConnection.paritybit)
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

    footer: RowLayout{
        Button{
            text: "OK"
            Layout.alignment: Qt.AlignCenter
            onClicked:  root.accept()
        }

        Button{
            text: "Cancel"
            Layout.alignment: Qt.AlignCenter
            onClicked: root.reject()
        }
    }

    onAccepted: {
        serialConnection.baudrate = baudrateCombobox.currentItem.value
        serialConnection.stopbit = stopbitCombobox.currentItem.value
        serialConnection.paritybit = paritybitCombobox.currentItem.value
    }
}
