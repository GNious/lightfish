
import QtQuick 2.0
import Sailfish.Silica 1.0
//import io.thp.pyotherside 1.0
//import "../analytics.js" as Analytics


Page
{
    id: page
    property string bulbAddress

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable
    {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        Image
        {
            id: backdrop
            //source: "image://LIFX_Bulb_bg.jpg"
            source: "../images/LIFX_Bulb_bg.png"
            sourceSize { width: parent.width; height: parent.height }
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
        Label
        {
            id: labelScanning
            //x: Theme.paddingLarge
            //y: 780 / (Math.min( backdrop.paintedWidth/backdrop.width, backdrop.paintedHeight/backdrop.height))
            y: 780 / (Math.min( 780 / backdrop.width, 1920 / backdrop.height )) - 60
            text: qsTr("Scanning...")
            color: "black" // Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
        }
        Button
        {
            id: buttonBuy
            //x: Theme.paddingLarge
            //y: 780 / (Math.min( backdrop.paintedWidth/backdrop.width, backdrop.paintedHeight/backdrop.height))
            //anchors.top: labelScanning.bottom
            y: page.height - buttonBuy.height
            text: qsTr("Get LIFX bulbs!")
            color: "black" // Theme.secondaryHighlightColor
            //font.pixelSize: Theme.fontSizeLarge
            //anchors.left: parent.left
            //anchors.right: parent.right
            //width: parent.width * 0.8
            width: 500
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Qt.openUrlExternally('http://lifx.co/')

        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            anchors.fill: parent
            PageHeader {
                title: qsTr("LightFish")
            }
        }
    }
    Component.onCompleted:
    {
        callScreenView("BulbListPage");
    }
    onStatusChanged:
    {
        if (status == PageStatus.Active )
        {
            //callScreenView("BulbListPage");
            discoveryClient.discover();
            discoveryClient.startDiscoveryTimer(5000);
        }
    }

}


