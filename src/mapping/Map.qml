import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import Cellulo 1.0

Item {

    property var coins : []
    property var availableCoins : []

    property var boosts : []
    property var availableBoosts : []

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
    }

    function loadZonesQML() {

        var zones = CelluloZoneJsonHandler.loadZonesQML(mapPath);

        zones[0].borderThickness = 160
        zoneEngine.addNewZones(zones);

        /* You can add the following if you want to render the zones :

            zones[0].createPaintedItem(yourRectangle, "#80FF0000", 1189, 841);
        */
    }

    Image {

        source: icon

        width: 390
        height: 200

        x:  posX
        y:  window.height / 2 - height / 1.1

        Button {

            width: parent.width
            height: parent.height
            opacity: 0

            onClicked: {

                console.log("Map has been chosen !\nMap source : "+mapPath)
                window.mapChoosing.selected = parent.parent
                loadZonesQML()
                resetCoins()
                resetBoosts()
                globalManager.mapChosen()
            }
        }

    }

    function resetCoins() {

        // We can't just do "availableCoins = coins" because of this stupid feature in the QML language that would "link" the two variables
        availableCoins = []

        for(var a = 0; a<coins.length; a++)
            availableCoins.push(coins[a])

        console.log(availableCoins.length+" "+coins.length)
    }

    function resetBoosts() {

        availableBoosts = []

        for(var a = 0; a<boosts.length; a++)
            availableBoosts.push(boosts[a])
    }

}
