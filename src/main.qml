import QtQuick 2.9
import QtQuick.Window 2.2
import "pannels"
import "mapping"

Window {

    property MenuPannel menuPannel : menuPannel
    property ConnectionPannel connectionPannel : connectionPannel
    property MapChoosing mapChoosing : mapChoosing
    property PlayerPannel playZone : playZone
    property FinalPannel end : end
    property MapRenderer renderer : renderer

    id: window
    visible: true

    MarioKartManager {

        id: globalManager
    }


    ConnectionPannel {

        id: connectionPannel
        globalManager : globalManager
    }

//    Map {

//        id: map1
//        posX: 30
//        mapPath: ":/assets/a1map1.json"
//        mapSVG: "qrc:/assets/a1map1.svg"
//        icon: "/assets/a1map1.svg"
//        firstSpawn: Qt.vector2d(159, 333)
//        checkPoints: [map1.firstSpawn,Qt.vector2d(527, 247)]
//        endLocation: Qt.vector2d(30,200)
//    }

//    Map {

//        id: map2
//        posX: map1.posX + 250
//        mapPath: ":/assets/a1map2.json"
//        mapSVG: "qrc:/assets/a1map2.svg"
//        icon: "/assets/a1map2.svg"
//        firstSpawn: Qt.vector2d(159, 333)
//        checkPoints: [map2.firstSpawn,Qt.vector2d(527, 247)]
//        endLocation: Qt.vector2d(30,200)
//    }

//    Map {

//        id: map3
//        posX: map2.posX + 250
//        mapPath: ":/assets/a1map3.json"
//        mapSVG: "qrc:/assets/a1map3.svg"
//        icon: "/assets/a1map3.svg"
//        firstSpawn: Qt.vector2d(50,50)
//        checkPoints: [map3.firstSpawn, Qt.vector2d(300, 200)]
//        endLocation: Qt.vector2d(800,100)
//    }

    Map {

        id: map4
        posX: 30
        mapPath: ":/assets/a1map4.json"
        mapSVG: "qrc:/assets/a1map4.svg"
        icon: "/assets/a1map4.svg"
        firstSpawn: Qt.vector2d(50, 550)
        checkPoints: [map4.firstSpawn]
        endLocation: Qt.vector2d(500,500)
    }

    Map {

        id: map5
        posX: map4.posX + 250
        mapPath: ":/assets/a2map5.json"
        mapSVG: "qrc:/assets/a2map5.svg"
        icon: "/assets/a2map5.svg"
        firstSpawn: Qt.vector2d(50, 350)
        checkPoints: [map5.firstSpawn]
        endLocation: Qt.vector2d(300,300)
    }

    Map {

        id: map6
        posX: map5.posX + 250
        mapPath: ":/assets/a1map6.json"
        mapSVG: "qrc:/assets/a1map6.svg"
        icon: "/assets/a1map6.svg"
        firstSpawn: Qt.vector2d(50, 450)
        checkPoints: [map5.firstSpawn]
        endLocation: Qt.vector2d(674,80)
    }

    MapChoosing {

        id: mapChoosing
        globalManager : globalManager

        maps: [
            map4,
            map5,
            map6
        ]
    }

    MenuPannel {

        id: menuPannel
        globalManager: globalManager
    }

    PlayerPannel {

        id: playZone
        globalManager : globalManager
    }

    MapRenderer {

        id: renderer
    }

    FinalPannel {

        id: end
        globalManager : globalManager
    }

    Player {

        id: player
        globalManager : globalManager
    }


}
