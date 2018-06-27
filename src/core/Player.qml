import QtQuick 2.0
import Cellulo 1.0

Item {

    property MarioKartManager globalManager : null
    property CelluloRobot robot : robot
    property double xPos : 0
    property double yPos : 0
    property vector2d lastCheckPoint : window.mapChoosing.selected.spawn
    property bool isReachingCheckPoint : false
    property bool failedRotation : false
    property int endReachedAmount : 0
    property int score : 0
    property int bonus : 0
    property int maxSpeed : 140
    property int boostSpeed : 0
    visible: false

    onIsReachingCheckPointChanged: {

        if(isReachingCheckPoint)
            wrong()

        else
            robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "green",0);
    }

    CelluloRobot {

        // connectionStatus is a variable from CelluloRobot file -> enum { Disconnected, TryingToConnect, Connected
        id: robot
        property int currentZoneValue : 1

        onConnectionStatusChanged: {

            if(connectionStatus === CelluloBluetoothEnums.ConnectionStatusConnected) {
                robot.reset()
                console.log("Connected !")
                globalManager.robotConnected()
                window.mapChoosing.selected.zoneEngine.addNewClient(robot);
            }
        }

        onZoneValueChanged : {

            console.log("ZONE VALUE CHANGED : "+value)
            currentZoneValue = value

            if(value != 1)
                frameWaitChecker.running = true
        }

        Timer {

            id: frameWaitChecker
            interval: 50//boostSpeed == 0 ? 50 : 30
            repeat: false

            onTriggered: {

                if(robot.currentZoneValue == 0) {

                    if(!isReachingCheckPoint) {

                        robot.setGoalPose(lastCheckPoint.x, lastCheckPoint.y, 1,100,100)
                        isReachingCheckPoint = true
                    }
                }
                else console.log("Bug happened, zone value : "+robot.currentZoneValue)
            }
        }

        onTrackingGoalReached: {

            clearTracking();
            isReachingCheckPoint = false
        }

        onPoseChanged : {

            globalManager.testWin()
            updateCheckPoints()
            window.bonusManager.testBonusReached()
        }
    }

    function isRotationSimilar() {

        var rotation = window.playZone.orientation

        if(player.robot.theta < rotation + 20 && player.robot.theta > rotation - 20)
            return true

        if(rotation <= 25 && player.robot.theta < 390 && player.robot.theta > 340)
            return true

        return false
    }

    function updateCheckPoints() {

        if(globalManager.gameTimer.running == false)
            return

        var currentMap = window.mapChoosing.selected

        for(var i = 0; i < currentMap.checkPoints.length; i++) {

            var vec2 = currentMap.checkPoints[i]

            var distanceX = (vec2.x) - (robot.x)
            var distanceY = (vec2.y) - (robot.y)

            var distanceSquared = distanceX * distanceX + distanceY * distanceY

            if(Math.sqrt(distanceSquared) < 60) {

                currentMap.spawn = vec2;
            }
        }
    }

    function init() {

        var spawn = window.mapChoosing.selected.spawn

        robot.setGoalPose(spawn.x, spawn.y, 25,100,10)
        resetColor()
    }

    function resetColor() {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "green", 0);
    }

    function blueWarn(number) {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "blue", number)
    }

    function redLedsTimer(number) {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "red", number)
    }

    function angleFound() {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "blue", 0)
    }

    function wrong() {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "red", 0)
    }

    function showEndReached() {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "#CC2EFA", 0)
    }

    function bonusFound() {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "yellow", 0)
    }

    function removeBonus() {
        bonus = -1
    }
}
