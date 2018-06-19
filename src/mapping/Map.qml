import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import Cellulo 1.0

Item {

    property var crystals : []
    property var checkPoints : [firstSpawn]
    property vector2d spawn : firstSpawn
    property vector2d firstSpawn : null
    property vector2d endLocation : null
    property string mapPath : null
    property string mapSVG : null
    property string icon : null
    property int posX : 0

    property CelluloZoneEngine zoneEngine : zoneEngine

    visible : mapChoosing.visible

    CelluloZoneEngine {

        id: zoneEngine
        active: true

        Component.onCompleted: console.log("ZONE LOADED")
        
    }

    function loadZonesQML() {

        var zones = CelluloZoneJsonHandler.loadZonesQML(mapPath);
        zones[0].borderThickness = 140
        console.log("Our zone : "+zones[0])
        zoneEngine.addNewZones(zones);
        console.log(zones[0].borderThickness)
        zones[0].createPaintedItem(window.renderer.mapRendered, "#80FF0000", 1189, 841);
        zoneEngine.addNewClient(player.robot)

    }

    Image {

        source: icon

        width: 200
        height: 200

        x:  posX
        y:  window.height / 2 - height / 1.1

        Component.onCompleted: {

            console.log("Loaded map !")
        }

        MultiPointTouchArea {

            width: parent.width
            height: parent.height

            touchPoints: [

                TouchPoint {

                }
            ]

            onUpdated: {

                console.log("Map has been chosen !\nMap source : "+mapPath)
                window.mapChoosing.selected = parent.parent
                loadZonesQML()
                globalManager.mapChosen()
            }
        }

    }

}
