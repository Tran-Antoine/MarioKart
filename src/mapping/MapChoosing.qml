
import QtQuick 2.0
import ".."
Rectangle {

    property MarioKartManager globalManager : null
    property list<Map> maps
    property Map selected : maps[0]

    visible: false

    Rectangle {

        Text {

            text: qsTr("Choisissez votre map")
            font.bold: true
            font.pointSize: 40

            x: window.width / 2 - width / 2
            y: 100
        }
    }
}
