import QtQuick 2.0
import "../core"
Image {

    property MarioKartManager globalManager : null
    visible: false
    source: "qrc:/assets/general/finish.png"
    width: window.width
    height: window.height

    Text {

        property double score: 92 - ((globalManager.gameTimer.minutes - 3) * 15) - (globalManager.gameTimer.seconds / 4) + player.score
        x: window.width / 2 - width / 1.4
        y: window.height / 1.3
        width: 300
        height: 100
        text: qsTr("Final Score : "+Math.floor(score <= 0 ? 0 : score))
        font.bold: true
        font.pointSize: 60
        color: "#FFBF00"
    }

    Text {
        property int finalMinutes : globalManager.gameTimer.minutes
        property int finalSeconds : globalManager.gameTimer.seconds

        property string minutes : finalMinutes >= 10 ? finalMinutes : "0"+finalMinutes
        property string seconds : finalSeconds >= 10 ? finalSeconds : "0"+finalSeconds

        text: qsTr("Time : "+minutes+" : "+seconds)
        font.pointSize: 30
        font.italic: true
        x: window.width / 2 - width / 1.8
        y: window.height / 1.15
    }

    Text {

        text: qsTr("Bonus reached : "+player.score)
        font.pointSize: 30
        font.italic: true
        x: window.width / 2 - width / 2
        y: window.height / 1.1
    }

}
