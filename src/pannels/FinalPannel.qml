import QtQuick 2.0
import "../core"
Image {

    property MarioKartManager globalManager : null
    visible: false
    source: "qrc:/assets/general/finish.png"
    width: window.width
    height: window.height

    Text {

        property double score: 70 - (globalManager.gameTimer.minutes * 15) - (globalManager.gameTimer.seconds / 4) + player.score
        x: window.width / 2 - width / 1.4
        y: window.height / 1.3
        width: 300
        height: 100
        text: qsTr("Your score is "+Math.floor(score <= 0 ? 0 : score))
        font.bold: true
        font.pointSize: 60
        color: "#FFBF00"
    }

}
