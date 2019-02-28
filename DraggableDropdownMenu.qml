import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

    GridLayout{
        property var component
        columns: 2
        Text{
            Layout.fillWidth: true
            text: "Add Stuff:"
        }

        TextInput{
            Layout.fillWidth: true
            text: "Blub"
        }
    }
