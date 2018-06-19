import QtQuick 2.0
import QtQuick.Controls 1.2
import QMLCache 1.0
import Cellulo 1.0
import QMLBluetoothExtras 1.0
import "../core"

Item {

    property MarioKartManager globalManager : null
    visible: true

    GroupBox {

        scale: 0.8
        title: "Robot Address"
        width: 1200
        height: 400

        x: window.width / 2 - width / 2
        y: window.height / 2 - height / 2


        Column{

            spacing: 5

            MacAddrSelector{
                id: macAddrSelector
                addresses: QMLCache.read("addresses").split(",")
                onConnectRequested: {
                    player.robot.localAdapterMacAddr = selectedLocalAdapterAddress;
                    player.robot.macAddr = selectedAddress;
                }
                onDisconnectRequested: player.robot.disconnectFromServer()
                connectionStatus: player.robot.connectionStatus
            }

            Row{
                spacing: 5

                BusyIndicator{
                    running: scanner.scanning
                    height: scanButton.height
                }

                Button{
                    id: scanButton
                    text: "Scan"
                    onClicked: scanner.start()
                }

                Button{
                    text: "Clear List"
                    onClicked: {
                        macAddrSelector.addresses = [];
                        QMLCache.write("addresses","");
                    }

                }
            }
        }
    }

    CelluloBluetoothScanner{

        id: scanner
        rotation: 270
        onRobotDiscovered: {

            var newAddresses = macAddrSelector.addresses;
            if(newAddresses.indexOf(macAddr) < 0){
                newAddresses.push(macAddr);
                newAddresses.sort();
            }
            macAddrSelector.addresses = newAddresses;
            QMLCache.write("addresses", macAddrSelector.addresses.join(','));
        }
    }



}
