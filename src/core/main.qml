import QtQuick 2.9
import QtQuick.Window 2.2
import "../pannels"
import "../mapping"
import "../bonus"
Window {

    property MenuPannel menuPannel : menuPannel
    property ConnectionPannel connectionPannel : connectionPannel
    property MapChoosing mapChoosing : mapChoosing
    property PlayPannel playZone : playZone
    property FinalPannel end : end
    property BonusManager bonusManager : bonusManager

    id: window
    visible: true

    MarioKartManager {

        id: globalManager
    }


    ConnectionPannel {

        id: connectionPannel
        globalManager : globalManager
    }

    Map {

        id: map1
        posX: 100
        mapPath: ":/assets/aMaxmap7.json"
        mapSVG: "qrc:/assets/aMaxmap7.svg"
        icon: "/assets/aMaxmap7.svg"
        firstSpawn: Qt.vector2d(110, 57)
        checkPoints: [
            map1.firstSpawn,
            Qt.vector2d(545, 433),
            Qt.vector2d(504, 916),
            Qt.vector2d(1459, 741),
            Qt.vector2d(1500,340),
        ]

        coins: [
            Qt.vector2d(243, 517),
            Qt.vector2d(191, 847),
            Qt.vector2d(748, 595),
            Qt.vector2d(1133, 709),
            Qt.vector2d(1786, 304),
            Qt.vector2d(997, 122)
        ]

        boosts: [
            Qt.vector2d(673, 36),
            Qt.vector2d(1208, 205),
            Qt.vector2d(198, 969),
            Qt.vector2d(1594, 692)
        ]

        endLocation: Qt.vector2d(1625,42)
    }

    MapChoosing {

        id: mapChoosing
        globalManager : globalManager

        maps: [
            map1
        ]
    }

    MenuPannel {

        id: menuPannel
        globalManager: globalManager
    }

    PlayPannel {

        id: playZone
        globalManager : globalManager
    }

    FinalPannel {

        id: end
        globalManager : globalManager
    }

    Player {

        id: player
        globalManager : globalManager
    }

    BonusManager {

        id: bonusManager
    }


}
