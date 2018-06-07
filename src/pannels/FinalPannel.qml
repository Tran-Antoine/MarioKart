import QtQuick 2.0
import ".."
Rectangle {

    property MarioKartManager globalManager : null
    visible: false

    width: window.width
    height: window.height
    color: "#3ADF00"

    Text {

        x: window.width / 2 - width / 2
        y: 200
        width: 600
        height: 600
        text: qsTr("YOU WON ! Your time is\n"+globalManager.gameTimer.minutes+" : "+globalManager.gameTimer.seconds)
        font.bold: true
        font.pointSize: 60
        color: "red"
    }

}
