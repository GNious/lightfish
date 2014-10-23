/*
.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0


Page
{
	id: page
	property string bulbAddress

	// To enable PullDownMenu, place our content in a SilicaFlickable
	SilicaFlickable
	{
		anchors.fill: parent

		// PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
		PullDownMenu
		{
			id: pullDownMenu
			MenuItem
			{
				text: qsTr("Dummy Item")
				//onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
			}
		}
		PushUpMenu
		{
			id: pushUpMenu
			MenuItem
			{
				text: qsTr("Dummy Item")
				//onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
			}
		}

		// Tell SilicaFlickable the height of its content.
		contentHeight: column.height

		// Place our content in a Column.  The PageHeader is always placed at the top
		// of the page, followed by our content.
		Column {
			id: column

			width: page.width
			spacing: Theme.paddingLarge
			anchors.fill: parent
			PageHeader {
				title: qsTr("LightFish")
			}
			Item
			{
				id: iconItem
				width: parent.width / 2 //* 0.8//ListView.view.width
				height: Theme.itemSizeSmall


				Image
				{
					id: icon
					anchors.horizontalCenter: parent.horizontalCenter
					source: "../images/logo_lifx_grey_gaussian.png"
					sourceSize: Qt.size(parent.width*0.9, parent.height*0.9)
					smooth: true
					visible: true//false
				}

				Colorize
				{
					id: iconColotize
					//hue/65535, saturation/65535, brightness/65535
					anchors.fill: icon
					source: icon
					//hue: bulb_hue/65535
					//saturation: bulb_saturation/65535
					//lightness: bulb_power ? (bulb_brightness*2/65535) -1 : -1
				}
			}
			Label
			{
				x: Theme.paddingLarge
				text: qsTr("Just some random text being shown here until I figure out what to actually put into this place")
				color: Theme.secondaryHighlightColor
				font.pixelSize: Theme.fontSizeLarge
			}
			TextField
			{
				id: textBulbName
				text: qsTr("Please Wait")
				enabled: false
			}

			Rectangle
			{
				width: 60
				height: width
				color: "red"
				border.color: "black"
				border.width: 1
				radius: width*0.5
				Text
				{
					//anchor.fill : parent
					color: "red"
					text: "Boom"
				}
			}
		}
	}
	Component.onCompleted:
	{
		lifxBulbGetObject( bulbAddress, page );
	}

/*		data['bulb_name'] =  bulb.bulb_label
		data['bulb_addr'] = bulb.addr
		data['bulb_hue'] = bulb.hue
		data['bulb_saturation'] = bulb.saturation
		data['bulb_brightness'] = bulb.brightness
		data['bulb_kelvin'] = bulb.kelvin
		data['bulb_tags'] = bulb.tags
*/	function setBulb(light)
	{
		console.log("BulbDetails::setBulb ("+light.bulb_name+"@"+light.bulb_addr+")")

		textBulbName.enabled = true;
		textBulbName.text = light.bulb_name;
		iconColotize.hue= light.bulb_hue/65535;
	}
}


