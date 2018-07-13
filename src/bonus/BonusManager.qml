import QtQuick 2.0
import QtQuick.Controls 2.0
Item {

    // The file is made for creating many bonus, only one has been done yet though

    property list<QtObject> bonusArray

    Rectangle {

        visible: window.playZone.visible && player.bonus != -1
        width: 150
        height: 150

        x: window.width / 2 - width / 2
        y: window.height / 2 - height / 2


            Image {
                id: bonusImage

                source: "qrc:/assets/general/bonus.png"

                Button {

                    opacity: 0
                    width: bonusImage.width
                    height: bonusImage.implicitHeight
                    onClicked: executeBonus()
                }
            }


    }

    ResetAngleBonus {

        id: resetBonus

        Component.onCompleted: bonusArray.push(resetBonus)
    }

    function testBonusReached() {

        if(player.isReachingCheckPoint || globalManager.rotationTimer.running)
            return

        var listCoins = window.mapChoosing.selected.availableCoins

        if(isRobotOnBonus(listCoins)) {
            globalManager.coinTimer.running = true
        }

        var listBoosts = window.mapChoosing.selected.availableBoosts

        if(isRobotOnBonus(listBoosts)) {

            player.boostSpeed = 80
            speedBoostTimer.running = true
        }

    }

    function isRobotOnBonus(listPoint) {

        for(var a = 0; a<listPoint.length;a++) {

            var vector = listPoint[a]
            var distanceX = (vector.x) - (player.robot.x)
            var distanceY = (vector.y) - (player.robot.y)
            var distanceSquared = distanceX * distanceX + distanceY * distanceY

            if(Math.sqrt(distanceSquared) < 27) {

                player.score += 1
                listPoint.splice(listPoint.indexOf(vector),1)

                if(!player.isReachingCheckPoint && !globalManager.rotationTimer.running)
                    player.bonusFound()

                return true
            }
        }

        return false
    }

    Timer {

        id: speedBoostTimer
        interval: 5000
        repeat: false

        onTriggered: {

            if(!player.isReachingCheckPoint && !globalManager.rotationTimer.running)
                player.resetColor()

            player.boostSpeed = 0
        }
    }

    function executeBonus() {

        if(player.bonus != -1) {
            bonusArray[player.bonus].execute()
        }
    }

    function getSize() {
        return 1
    }
}
