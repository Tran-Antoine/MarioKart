import QtQuick 2.0
import Cellulo 1.0

Item {

    property MarioKartManager globalManager : null
    property CelluloRobot robot : robot
    property double speed : 30
    property double xPos : 0
    property double yPos : 0
    property vector2d lastCheckPoint : window.mapChoosing.selected.spawn
    property bool isReachingCheckPoint : false
    property bool failedRotation : false
    property int pointAmount : 0
    property int bonus : 0

    onIsReachingCheckPointChanged: {

        if(isReachingCheckPoint)
             wrong()

        else
            robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "green",0);
    }

    visible: false

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

            console.log("ZONE VALUE HAS CHANGED")
            robot.setGoalPose(lastCheckPoint.x, lastCheckPoint.y, 1,60,10)
            isReachingCheckPoint = true

        }

        onTrackingGoalReached: {

            setCasualBackdriveAssistEnabled(true);
            clearTracking();
            //console.log("CheckPoint reached ! Cellulo is now able to be moved")
            isReachingCheckPoint = false
        }

        onPoseChanged : {

            testWin()
            updateCheckPoints()
        }

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

            if(Math.sqrt(distanceSquared) < 20) {

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

        if(Math.sqrt(distanceSquared) < 20) {

            console.log(isReachingCheckPoint)

            if(!isReachingCheckPoint) {
                robot.setGoalPose(endPoint.x, endPoint.y, 1,60,10)
                globalManager.endReached()
            }
        }
    }

    function init() {

        var spawn = window.mapChoosing.selected.spawn

        robot.setGoalPose(spawn.x, spawn.y, 25,60,10)
        resetColor()

    }

    function resetColor() {

        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "green", 0);
    }

    function warn(number) {
        console.log("Warned")
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

    function showScored() {
        robot.setVisualEffect(CelluloBluetoothEnums.VisualEffectConstAll, "#CC2EFA", 0)
    }

    function resetBonus() {

        bonus = -1
    }
}