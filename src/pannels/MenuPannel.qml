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
            id: backgroundImage
            source: "/assets/general/icon.jpg"
            scale: 0.7

            x: window.width / 2 - width / 2
            y: window.height / 2 - height / 1.5
        }


        Button {

            id: playButton
            x: window.width / 2 - width / 2
            y: window.height / 1.5

            width: 100
            height: 80

            style: ButtonStyle {

                background: null
            }

            Text {

                id: textPlay
                text: qsTr("PLAY")
                font.bold: true
                font.pointSize: 60

            }

            onClicked: globalManager.playStart()
        }

        Button {

            id: helpButton
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

        id: help

        width: window.width
        height: window.height
        color: "gray"
        visible: false

        Text {

            text: qsTr(
                      "\n       Mario Kart - The Famous game created with robots\n


        Controls\n

        The purpose of this 2D Game is to reach three times the end of the circuit. To move and rotate the robot, let's see how the pannel works :\n

        - The circle at the bottom left of the screen helps moving the robot. Place a finger around the circle, the angle will be calculated and the
          robot will move in the right direction. The further from the center of the circle you are, the faster the robot will move\n
        - The two arrows at the bottom right are used to rotate the robot. We'll se later the utility of rotating the robot\n
        - The bonus image at the center of the screen can be used once, to avoid the required rotation of the robot. Again, we'll se later\n
          why this is useful
        - The I am stuck button shouldn't be used. If you can't move your robot despite the fact that all the leds are green,
          or if the leds are red but the robot is not moving, this means a bug appeared, so you can unlock the robot with this button\n
        - The Red / Green Rectangle shows either the robot is kidnapped or not\n

        GamePlay\n

        - Every 12 seconds, a blue led will appear. A timer is represented by the red leds that will appear, and you have to point the blue led towards
          the north of the map before all the leds become red, otherwise you will get stuck during a period of 3 seconds\n
        - You can also notice coins and mushrooms on the circuit. You can only take these bonus once per round.\n
          Both give you points at the end of the race, and in addition the mushrooms increases your speed during 5 seconds of 66%\n
        - Each map contains checkpoints, as soon as you cross the border of the road the robot will be moved to the last checkpoint"

                      )
        }

        Button {

            width: 150
            height: 80

            onClicked: help.visible = false
            text: "Close"
            y: window.height - height

        }
    }



}
