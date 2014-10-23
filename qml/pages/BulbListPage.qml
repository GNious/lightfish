import QtQuick 2.0
import io.thp.pyotherside 1.0
import Sailfish.Silica 1.0


Page
{
    id: page
	//property Python py
	//property variant lights
    SilicaListView
    {
        id: listView
        anchors.fill: parent
        model: ListModel
        {
            id: listModel
        }
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
			//menu: bulbContextMenuComponent

            //Label
			TextSwitch
            {
				x: Theme.paddingLarge
				text: bulb_name + " (@" +bulb_addr+ ")"

				//text: "Item " + index
				anchors.verticalCenter: parent.verticalCenter
				//color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
				//text: "Active"
				description: ""
				onCheckedChanged:
				{
					if(checked)
					{
						lifxBulbSelect(bulb_addr)
					}
					else
					{
						lifxBulbDeSelect(bulb_addr)
					}
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
						onClicked: pageStack.push(Qt.resolvedUrl("BulbDetails.qml"), { bulbAddress: bulb_addr})
					}
					MenuItem
					{
						text: "Power-toggle"
						onClicked: {}
					}
				}
			}
		}
	}


    Component.onCompleted:
    {
		lifxGetBulbs( page );
/*		py.call('lightfish.get_bulbs', [], function(result)
		{
			console.log('lightfish rechewing');
			// Load the received data into the list model
			for (var i=0; i<result.length; i++) {
				console.log('lightfish# @ '+result[i]['name']);
				listModel.append(result[i]);
				//listView.append(result[i]);
			}
			console.log('lightfish redone');
		});*/
    }
	function setLights(lights)
	{
		for (var i=0; i<lights.length; i++) {
			console.log('lightfish# @ '+lights[i]['bulb_name']);
			listModel.append(lights[i]);
			//listView.append(result[i]);
		}
	}
}





