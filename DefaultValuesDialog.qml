import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog{
    id: root
    title: qsTr("Default Values")

    IntValidator{
        id: rangeValidator
    }

    ColumnLayout{
        GroupBox{
            Layout.fillWidth: true
            label: Label{
                text: "Default Min - Max"
            }

            GridLayout{
                anchors.left: parent.left
                anchors.right: parent.right
                columns: 3

                Text{
                    text: qsTr("Balance Slider:")
                }

                SpinBox{
                    id: balanceSliderMin
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > balanceSliderMax.value ? balanceSliderMax.value : value
                }

                SpinBox{
                    id: balanceSliderMax
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value < balanceSliderMin.value ? balanceSliderMin.value : value
                }

                Text{
                    text: qsTr("Slider:")
                }

                SpinBox{
                    id: sliderMin
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > sliderMax.value ? sliderMax.value : value
                }

                SpinBox{
                    id: sliderMax
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > sliderMin.value ? sliderMin.value : value
                }

                Text{
                    text: qsTr("Circular Gauge:")
                }

                SpinBox{
                    id: circularGaugeMin
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > circularGaugeMax.value ? circularGaugeMax.value : value
                }


                SpinBox{
                    id: circularGaugeMax
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > circularGaugeMin.value ? circularGaugeMin.value : value
                }

                Text{
                    text: qsTr("Linear Gauge:")
                }

                SpinBox{
                    id: linearGaugeMin
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > linearGaugeMax.value ? linearGaugeMax.value : value
                }


                SpinBox{
                    id: linearGaugeMax
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top

                    onValueChanged: value = value > linearGaugeMin.value ? linearGaugeMin.value : value
                }
            }
        }

        GroupBox{
            Layout.fillWidth: true

            label: Label{
                text: "Default Initial Values"
            }

            GridLayout{
                anchors.left: parent.left
                anchors.right: parent.right
                columns: 2

                Text{
                    text: qsTr("Spinbox:")
                }

                SpinBox{
                    editable: true
                    from: rangeValidator.bottom
                    to: rangeValidator.top
                }
            }
        }
    }
    onAccepted: {

    }
}
