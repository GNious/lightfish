import QtQuick 2.0
//import io.thp.pyotherside 1.0
//import "../analytics.js" as Analytics
import Sailfish.Silica 1.0


Page
{
    id: page

    SilicaListView
    {
        id: listView
        anchors.fill: parent
        //model: ListModel {id: listModel;}
        model: lightsModel
        header: PageHeader
        {
            title: qsTr("Choose Lightbulbs")
        }
//        delegate: BackgroundItem
        delegate: ListItem
        {
            id: delegate
            property Item contextMenu

            property bool menuOpen: contextMenu != null && contextMenu.parent === delegate
            width: ListView.view.width
            height: menuOpen ? contextMenu.height + contentItem.height : contentItem.height

            //Label
            TextSwitch
            {
                x: Theme.paddingLarge
                text: label

                anchors.verticalCenter: parent.verticalCenter
                description: ""
                checked: selected
                onCheckedChanged:
                {
                    selected = checked
                }
                onPressAndHold:
                {
                    if (!contextMenu)
                        contextMenu = bulbContextMenuComponent.createObject(listView)
                    contextMenu.show(delegate)
                }
            }
            Component
            {
                id: bulbContextMenuComponent
                ContextMenu
                {
                    MenuItem
                    {
                        text: "Rename"
                    //	onClicked: pageStack.push(Qt.resolvedUrl("BulbDetails.qml"), { bulbAddress: bulb_addr})
                    }
                    MenuItem
                    {
                        text: "Power-toggle"
                        onClicked: { power = !power; }
                    }
                }
            }
        }
    }


    onStatusChanged:
    {
        if (status == PageStatus.Active )
        {

            callScreenView("BulbListPage");
        }
    }

}
