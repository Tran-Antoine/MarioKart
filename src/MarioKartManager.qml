import QtQuick 2.0
import Cellulo 1.0

Item {

    signal playStart
    signal robotConnected
    signal mapChosen
    signal endReached

    property Timer gameTimer : gameTimer
    property bool failed : false


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

        window.menuPannel.visible = false
        window.playZone.visible = true
        console.log("Starting the game !")
        gameTimer.running = true
        player.visible = true
        player.robot.setGoalPose(player.lastCheckPoint.x, player.lastCheckPoint.y, 1,60,10)
    }

    onEndReached: {

        console.log("reached !")
        player.isReachingCheckPoint = true
        player.pointAmount++

        if(player.pointAmount == 4)
            end()

        else {

            var spawn = window.mapChoosing.selected.spawn

            player.robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "blue", player.pointAmount+3);
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
                player.isReachingCheckPoint = false
                player.init()
            }

            if(seconds % 20 == 0 && seconds != 0) {

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

        switch(Math.floor(Math.random()*6)) {

        case 0:
            window.playZone.orientation = 25
            player.warn(1)
            break;
        case 1:
            window.playZone.orientation = 85
            player.warn(2)
            break;
        case 2:
            window.playZone.orientation = 145
            player.warn(3)
            break;
        case 3:
            window.playZone.orientation = 205
            player.warn(4)
            break;
        case 4:
            window.playZone.orientation = 265
            player.warn(5)
            break;
        case 5:
            window.playZone.orientation = 325
            player.warn(6)
            break;
        }

        delay.running = true
    }

    Timer {

        property int current : 0
        id: delay
        interval: 1000
        repeat: true

        onTriggered: {

            // init
            if(current == 0 || current == 1) {

                console.log("Initting angle timer...")
                player.warn()
            }

            // end
            if(current == 5) {

                if(player.isReachingCheckPoint)
                    running = false

                else {
                    console.log("Bad orientation ! : "+player.robot.theta + " / " + window.playZone.orientation)
                    failed = true
                    player.robot.simpleVibrate(3,3,3,3000,3000)
                    player.resetColor()
                }
            }

            // go out of the timer if angle found
            if(isRotationSimilar()) {

                player.resetColor()
                current = 0
                running = false
            }

            // end malus
            if(current == 8) {

                current = 0;
                failed = false
                player.isReachingCheckPoint = false
                player.robot.clearTracking()
                running = false

            }

            current++
        }
    }

    function isRotationSimilar() {

        var rotation = window.playZone.orientation
        if(player.robot.theta < rotation + 30 && player.robot.theta > rotation - 30)
            return true

        if(rotation == 0 && player.robot.theta < 390 && player.robot.theta > 330)
            return true

        return false
    }

}
