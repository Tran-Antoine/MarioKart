import QtQuick 2.0
import QtQuick.Controls 2.0
Item {

    property ListModel bonus : bonus
    property list<QtObject> bonusArray

    Rectangle {

        visible: window.playZone.visible && player.bonus != -1
        width: 150
        height: 150

        x: window.width / 2 - width / 2
        y: window.height / 2 - height / 2

        Button {

            Text {
                text: qsTr("Bonus")
                color: "yellow"
                font.bold: true
                font.pointSize: 40
            }

            onClicked: executeBonus()
        }
    }

    ResetAngleBonus {

        id: resetBonus

        Component.onCompleted: bonusArray.push(resetBonus)
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
