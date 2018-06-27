import QtQuick 2.0

Item {

    Component.onCompleted: console.log("ResetAngleBonus loaded !")

    function execute() {

        console.log("Bonus executed")

        if(globalManager.rotationTimer.running) {

            globalManager.rotationTimer.bonusStop = true
            globalManager.rotationTimer.running = false
            player.removeBonus()
        }
    }
}
