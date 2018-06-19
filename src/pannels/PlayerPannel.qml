import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import "../core"
Item {

    property int orientation : 25
    property Image indication : indication
    property Rectangle waitBeforeStart : waitBeforeStart
    property MultiPointTouchArea moveZone : moveZone
    property MarioKartManager globalManager : null

    visible : false

    Rectangle {

        id: waitBeforeStart
        visible: globalManager.gameTimer.seconds <= 4 && parent.visible && globalManager.gameTimer.minutes === 0
        width: 300
        height: 300
        x: window.width / 2 - width / 2
        y: window.height / 2 - height / 2

        Text {

            property double time : 5 - globalManager.gameTimer.seconds
            text: qsTr("Début dans : "+time)
            font.bold: true
            font.pointSize: 60
        }
    }

    Rectangle {

        id: rotationLeft
        x: 560
        y: window.height - 170
        color: "blue"

        width: 100
        height: 80

        MouseArea {

            anchors.fill: parent

            Image {
                id: left
                source: "qrc:/assets/general/arrowRotate.jpeg"
                rotation: 180
                scale: 0.4
                x: parent.x - rotationLeft.width
                y: parent.y - rotationLeft.height / 2
            }

            onPressed: {

                if(canMove()) {
                    rotationTimer.rotation = -50
                    rotationTimer.running = true
                }
            }

            onReleased: {

                rotationTimer.running = false
            }
        }
    }

    Rectangle {

        id: rotationRight
        x: 770
        y: window.height - 170
        color: "blue"
        width: 100
        height: 80

        MouseArea {

            anchors.fill: parent

            Image {
                id: right
                source: "qrc:/assets/general/arrowRotate.jpeg"
                scale: 0.4
                x: parent.x - rotationRight.width
                y: parent.y - rotationRight.height / 2
            }

            onPressed: {

                if(canMove()) {
                    rotationTimer.rotation = 50
                    rotationTimer.running = true
                }
            }

            onReleased: rotationTimer.running = false

        }
    }

    Timer {

        id: rotationTimer
        property double rotation : 0

        repeat: true
        interval: 80

        onTriggered: {

            var robot = player.robot

            if(globalManager.failed)
                running = false

            if(!player.isReachingCheckPoint)
                player.robot.setGoalPose(robot.x,robot.y,robot.theta + rotation, 100, 100)
        }

    }

    MultiPointTouchArea {

        property vector2d center: Qt.vector2d(controller.x + controller.width/2, controller.y + controller.height/2)
        property TouchPoint touch : touch
        id: moveZone
        width: 220
        height: 220

        x: 20
        y: window.height - height -20

        Image {

            id:controller
            source: "qrc:/assets/general/controller.png"

            visible: window.playZone.visible
            width: 120; height: 120

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        minimumTouchPoints: 1
        maximumTouchPoints: 1


        touchPoints: [

            TouchPoint {

                id: touch
            }
        ]
        onUpdated: {

            var angle = findAngle(cursor,moveZone)
            var rAngle = angle * Math.PI / 180

            var x = player.speed * Math.cos(rAngle)
            var y = player.speed * Math.sin(rAngle)

            if(cursor.visible && canMove())
                player.robot.setGoalPose(player.robot.x + 10*x, player.robot.y - 10*y, player.robot.theta,60,10)
        }
    }

    Rectangle {

        property vector2d center : Qt.vector2d(x + width / 2, y + height / 2)
        id: cursor
        x: moveZone.touch.x - 20
        y: moveZone.touch.y + window.height / 1.7
        radius: 1000
        color: "#00FFFF"
        width: 80
        height: 80

        visible : moveZone.touch.pressed ? isRoundInCircle(moveZone, cursor) : false

        onVisibleChanged: {

            if(!visible && canMove())
                player.robot.clearTracking()
        }

        }

                Rectangle {

                    scale: 0.5

                    width: 100
                    height: 50

                    x: window.width - width * 1.5
                    y: 0

                    Button {
                        text: "I am stuck"

                        onClicked: {

                            player.robot.clearTracking()
                            player.isReachingCheckPoint = false
                        }
                    }
                }

            Rectangle {

                width: 70
                height: 70
                x: 10
                y: 10

                color: player.robot.kidnapped ? "red" : "green"
            }

            function isRoundInCircle(rec1, rec2) {

                var distanceX = (rec1.x + rec1.width/2) - (rec2.x + rec2.width / 2)
                var distanceY = (rec1.y + rec1.height/2) - (rec2.y + rec2.height/2)

                var distanceSquared = distanceX * distanceX + distanceY * distanceY

                var radius = rec1.width / 2 + rec2.width / 2
                var radiusSquared = radius * radius

                return radiusSquared > distanceSquared
            }

            function findAngle(rec1, rec2) {

                var distanceX = (rec1.x + rec1.width/2) - (rec2.x + rec2.width / 2)
                var distanceY = (rec2.y + rec2.height/2) - (rec1.y + rec1.height/2)

                var value = Math.atan(distanceY/distanceX) * 180 / Math.PI

                if(distanceX > 0 && distanceY >= 0)
                    return value

                if(distanceX < 0 && distanceY >= 0)
                    return value + 180

                if(distanceX < 0 && distanceY <= 0)
                    return value + 180

                if(distanceX > 0 && distanceY <= 0)
                    return value + 360
            }

            function canMove() {

                return !player.failedRotation && !player.isReachingCheckPoint && !window.playZone.waitBeforeStart.visible
            }
        }

