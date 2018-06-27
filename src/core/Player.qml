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

        onConnectionStatusChanged: {

            if(connectionStatus === CelluloBluetoothEnums.ConnectionStatusConnected) {
                robot.reset()
                console.log("Connected !")
                globalManager.robotConnected()
                window.mapChoosing.selected.zoneEngine.addNewClient(robot);
            }
        }

        onZoneValueChanged : {

            console.log("Edge crossed...")
            if(!isReachingCheckPoint) {
                robot.setGoalPose(lastCheckPoint.x, lastCheckPoint.y, 1,100,100)
                isReachingCheckPoint = true
            }

        }

        onTrackingGoalReached: {

            clearTracking();
            isReachingCheckPoint = false
        }

        onPoseChanged : {

            testWin()
            updateCheckPoints()
            testBonusReached()
        }
    }

    function testBonusReached() {

        if(isReachingCheckPoint || globalManager.rotationTimer.running)
            return

        var listCoins = window.mapChoosing.selected.availableCoins

        if(isRobotOnBonus(listCoins))
            globalManager.coinTimer.running = true

        var listBoosts = window.mapChoosing.selected.availableBoosts

        if(isRobotOnBonus(listBoosts)) {

            boostSpeed = 80
            speedBoostTimer.running = true
        }

    }

    Timer {

        id: speedBoostTimer
        interval: 5000
        repeat: false

        onTriggered: {

            console.log("Reset of the boost")
            if(!isReachingCheckPoint && !globalManager.rotationTimer.running)
                resetColor()

            boostSpeed = 0
        }
    }

    function isRobotOnBonus(listPoint) {

        for(var a = 0; a<listPoint.length;a++) {

            var vector = listPoint[a]
            var distanceX = (vector.x) - (robot.x)
            var distanceY = (vector.y) - (robot.y)
            var distanceSquared = distanceX * distanceX + distanceY * distanceY

            if(Math.sqrt(distanceSquared) < 27) {

                score += 1
                listPoint.splice(listPoint.indexOf(vector),1)

                if(!isReachingCheckPoint && !globalManager.rotationTimer.running)
                    bonusFound()

                return true
            }
        }

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

    function testWin() {

        if(globalManager.gameTimer.running == false)
            return

        var currentMap = window.mapChoosing.selected
        var endPoint = currentMap.endLocation

        var distanceX = (endPoint.x) - (robot.x)
        var distanceY = (endPoint.y) - (robot.y)
        var distanceSquared = distanceX * distanceX + distanceY * distanceY

        if(Math.sqrt(distanceSquared) < 30) {

            if(!isReachingCheckPoint) {
                globalManager.endReached()
            }
        }
    }

    function init() {

        var spawn = window.mapChoosing.selected.spawn

        robot.setGoalPose(spawn.x, spawn.y, 25,100,10)
        resetColor()
    }

    function resetColor() {
        console.log("Reset called")
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "green", 0);
    }

    function warn(number) {
        console.log("Blue visual effect")
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "blue", number)
    }

    function warnRed(number) {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstSingle, "red", number)
    }

    function rightAngleColour() {
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

    function removeRotationBonus() {
        bonus = -1
    }
}
