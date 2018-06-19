import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4

import "../core"
Item {

    property MarioKartManager globalManager: null
    visible: false

    Rectangle {

        id: menu
        width: window.width
        height: window.height

        Image {
            id: name
            source: "/assets/general/icon.jpg"
            scale: 0.7

            x: window.width / 2 - width / 2
            y: window.height / 2 - height / 1.5
        }


        Button {

            x: window.width / 2 - width / 2
            y: window.height / 1.5

            width: 100
            height: 80

            Text {

                id: textPlay
                text: qsTr("PLAY")
                font.bold: true
                font.pointSize: 60

            }

            style: ButtonStyle {

                background: null
            }

            onClicked: globalManager.playStart()
        }

        Button {

            width: 200
            height: 80

            x: window.width - width
            y: window.height - height

            text: "Help"

            onClicked: {

                help.visible = true
            }
        }

    }

    Rectangle {

        width: 600
        height: 800

        color: "gray"

        id: help
        visible: false

        Text {

            text: qsTr("Welcome to the help interface !\nUnfortunately help page is not done yet...")
            x: parent.width / 2 - width
            color: "blue"
            font.bold: true
        }

        Button {

            width: 50
            height: 40

            onClicked: help.visible = false
            text: "Close"
            y: window.height - height
        }
    }



}
