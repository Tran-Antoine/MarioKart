import QtQuick 2.9

Item {

    property double scaling : 0.1
    Image {

        x: -1895
        y: -1350
        id: sourceImage
        source: window.mapChoosing.selected.mapSVG
        scale: scaling
        Component.onCompleted: {

            console.log("Datas : "+width+" /" +height)
        }
    }

    Image {
        id: car
        source: "/assets/general/icon.jpg"

        // Real value mesured by hand
        width: sourceImage.height / 11.2 * scaling
        height: sourceImage.height / 11.2 * scaling
        x: player.robot.x * 0.2822887
        y: player.robot.y * 0.2823095

    }
}
