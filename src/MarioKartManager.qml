import QtQuick 2.0

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

            seconds ++
        }
    }

    function rotationSignal() {

        switch(Math.floor(Math.random()*4)) {

        case 0:
            window.playZone.orientation = 25
            break;
        case 1:
            window.playZone.orientation = 115
            break;
        case 2:
            window.playZone.orientation = 205
            break;
        case 3:
            window.playZone.orientation = 295
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
                window.playZone.indication.visible = true
            }

            // end
            if(current == 5) {

                console.log("Bad orientation ! : "+player.robot.theta + " / " + window.playZone.orientation)
                failed = true
                player.robot.simpleVibrate(3,3,3,3000,3000)
                player.resetColor()
            }

            // go out of the timer if angle found
            if(isRotationSimilar()) {

                player.resetColor()
                current = 0
                window.playZone.indication.visible = false
                running = false
            }

            // end malus
            if(current == 8) {

                current = 0;
                failed = false
                window.playZone.indication.visible = false
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
