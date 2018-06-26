import QtQuick 2.0
import Cellulo 1.0

Item {

    signal playStart
    signal robotConnected
    signal mapChosen
    signal endReached

    property Timer gameTimer : gameTimer
    property Timer coinTimer : coinTimer
    property Timer rotationTimer : warnTimer
    property int warnNumber : 0

    onRobotConnected: {

        window.connectionPannel.visible = false
        window.mapChoosing.visible = true
        console.log("Robot is now connected")
    }

    onMapChosen: {

        window.mapChoosing.visible = false
        window.menuPannel.visible = true
    }

    onPlayStart: {

        player.robot.reset()
        window.menuPannel.visible = false
        window.playZone.visible = true
        console.log("Starting the game !")
        gameTimer.running = true
        player.visible = true
        player.robot.setCasualBackdriveAssistEnabled(true)
    }

    onEndReached: {

        console.log("reached !")
        player.isReachingCheckPoint = true
        player.showEndReached()
        player.endReachedAmount++
        window.mapChoosing.selected.resetCoins()
        window.mapChoosing.selected.resetBoosts()

        if(player.endReachedAmount == 3)
            end()

        else {

            var spawn = window.mapChoosing.selected.firstSpawn
            console.log(spawn.x+" / "+spawn.y)
            player.robot.setGoalPose(spawn.x,spawn.y, 1,60,10)
        }
    }

    function end() {
        window.playZone.visible = false
        player.robot.reset()
        player.visible = false
        window.end.visible = true
        gameTimer.running = false
    }

    Timer {

        property int seconds: 0
        property int minutes: 0
        id: gameTimer
        running: false
        repeat: true
        interval: 1000

        onTriggered: {

            if(seconds == 1 && minutes == 0) {
                player.init()
            }

            if(seconds % 12 == 0 && seconds != 0) {

                rotationSignal();
            }

            if(seconds == 60) {
                seconds = 0
                minutes++
            }

            seconds ++
        }
    }

    function rotationSignal() {

        if(player.isReachingCheckPoint)
            return

        player.resetColor()

        switch(Math.floor(Math.random()*6)) {

        case 0:
            window.playZone.orientation = 25
            player.warn(2)
            warnNumber = 2
            break;
        case 1:
            window.playZone.orientation = 85
            player.warn(3)
            warnNumber = 3
            break;
        case 2:
            window.playZone.orientation = 145
            player.warn(4)
            warnNumber = 4
            break;
        case 3:
            window.playZone.orientation = 205
            player.warn(5)
            warnNumber = 5
            break;
        case 4:
            window.playZone.orientation = 265
            player.warn(0)
            warnNumber = 0
            break;
        case 5:
            window.playZone.orientation = 325
            player.warn(1)
            warnNumber = 1
            break;
        }
        warnTimer.running = true
    }

    Timer {

        property int current : 0
        property int currentWhenFound : 1000
        property bool found : false
        property int up : 0
        property bool bonusStop : false

        id: warnTimer
        interval: 1000
        repeat: true

        onTriggered: {

            current++

            // If robot is already reaching a check point, cancel
            if(player.isReachingCheckPoint) {
                console.log("Robot tries to reach a checkpoint, timer stopped")
                running = false
                return
            }

            // Warns the robot by setting the lights in orange one by one
            if(current <= 5) {

                var toLight = warnNumber + current
                if(toLight <= 5) {
                    console.log(toLight)
                    player.warnRed(toLight)
                }
                else {
                    player.warnRed(up)
                    up++
                }
            }

            // go out of the timer if angle found
            if(isRotationSimilar() && !found && !player.failedRotation) {

                player.rightAngleColour();
                currentWhenFound = current
                found = true
            }

            // If current equals 5 and the right angle hasn't been reached : too late !
            if(current == 5 && !found) {

                console.log("Bad orientation ! :\n Robot orientation : "+player.robot.theta + "\nRequired : " + window.playZone.orientation)
                player.failedRotation = true
                player.wrong()
                player.robot.clearTracking()
                player.robot.simpleVibrate(3,3,3,3000,3000)

            }

            if(current - 1 === currentWhenFound)
                running = false

            // end malus
            if(current == 8)
                running = false
        }

        onRunningChanged: {

            if(!running) {

                if(player.failedRotation || found || bonusStop) {

                    player.resetColor()
                    player.robot.clearTracking()
                    player.failedRotation = false
                }

                bonusStop = false
                found = false
                current = 0
                up = 0
                currentWhenFound = 1000
            }
        }
    }

    function isRotationSimilar() {

        console.log(player.robot.theta+" / "+window.playZone.orientation)
        var rotation = window.playZone.orientation

        if(player.robot.theta < rotation + 20 && player.robot.theta > rotation - 20)
            return true

        if(rotation <= 25 && player.robot.theta < 390 && player.robot.theta > 340)
            return true

        return false
    }

    Timer {

        id: coinTimer
        repeat: false
        interval: 2000

        onTriggered: {

            if(!player.isReachingCheckPoint && !rotationTimer.running)
                player.resetColor()
        }
    }

}
