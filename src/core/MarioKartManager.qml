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
    property int rounds : 3

    onRobotConnected: {

        window.connectionPannel.visible = false
        window.mapChoosing.visible = true
        console.log("Robot is now connected")
    }

    onMapChosen: {

        var mapChoosing = window.mapChoosing
        mapChoosing.visible = false
        window.menuPannel.visible = true
        player.robot.setGoalPose(mapChoosing.selected.firstSpawn.x,mapChoosing.selected.firstSpawn.y,player.robot.theta, 180, 180)
    }

    onPlayStart: {

        player.robot.reset()
        window.menuPannel.visible = false
        window.playZone.visible = true
        gameTimer.running = true
        player.visible = true
        player.robot.setCasualBackdriveAssistEnabled(true)
    }

    onEndReached: {

        player.isReachingCheckPoint = true
        player.showEndReached()
        player.endReachedAmount++
        window.mapChoosing.selected.resetCoins()
        window.mapChoosing.selected.resetBoosts()

        if(player.endReachedAmount == rounds)
            end()

        else {

            var spawn = window.mapChoosing.selected.firstSpawn
            player.robot.setGoalPose(spawn.x,spawn.y, 1,180,100)
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
            player.blueWarn(2)
            warnNumber = 2
            break;
        case 1:
            window.playZone.orientation = 85
            player.blueWarn(3)
            warnNumber = 3
            break;
        case 2:
            window.playZone.orientation = 145
            player.blueWarn(4)
            warnNumber = 4
            break;
        case 3:
            window.playZone.orientation = 205
            player.blueWarn(5)
            warnNumber = 5
            break;
        case 4:
            window.playZone.orientation = 265
            player.blueWarn(0)
            warnNumber = 0
            break;
        case 5:
            window.playZone.orientation = 325
            player.blueWarn(1)
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
                running = false
                return
            }

            // Warns the robot by setting the lights in orange one by one
            if(current <= 5) {

                var toLight = warnNumber + current
                if(toLight <= 5) {
                    player.redLedsTimer(toLight)
                }
                else {
                    player.redLedsTimer(up)
                    up++
                }
            }

            // go out of the timer if angle found
            if(player.isRotationSimilar() && !found && !player.failedRotation) {

                player.angleFound();
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

    Timer {

        id: coinTimer
        repeat: false
        interval: 2000

        onTriggered: {

            if(!player.isReachingCheckPoint && !rotationTimer.running)
                player.resetColor()
        }
    }

    function testWin() {

        if(gameTimer.running == false)
            return

        var currentMap = window.mapChoosing.selected
        var endPoint = currentMap.endLocation

        var distanceX = (endPoint.x) - (player.robot.x)
        var distanceY = (endPoint.y) - (player.robot.y)
        var distanceSquared = distanceX * distanceX + distanceY * distanceY

        if(Math.sqrt(distanceSquared) < 30) {

            if(!player.isReachingCheckPoint) {
                globalManager.endReached()
            }
        }
    }

}
