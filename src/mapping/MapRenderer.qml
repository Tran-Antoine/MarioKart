import QtQuick 2.9

Item {

    property double scaling : 0.07
    property int realWidth : 841
    property int realHigh : 594
    property Rectangle mapRendered : mapRendered

    // Change to true if you want to see the map
    visible: false

    Rectangle {

        id: mapRendered
        x: 0//-1895
        y: 0//-1350
        width: sourceImage.width * scaling
        height: sourceImage.height * scaling
        Image {
            id: sourceImage
            source: window.mapChoosing.selected.mapSVG
            scale: scaling
            Component.onCompleted: {

                console.log("Datas : "+width+" /" +height)
            }
        }
    }
    Image {
        id: car
        source: "/assets/general/icon.jpg"

        // Real value mesured by hand
        width: sourceImage.height / 11.2 * scaling
        height: sourceImage.height / 11.2 * scaling
        x: player.robot.x / 3.75
        y: player.robot.y / 4.15

    }
}
