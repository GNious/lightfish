/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
//import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import QtQml 2.0

CoverBackground {
	id: cover
	anchors.fill: parent
	/*Label {
        id: label
        anchors.centerIn: parent
        text: "My Cover"
	}*/

    CoverActionList {
        id: coverAction

		/*CoverAction
		{
            iconSource: "image://theme/icon-cover-next"
			onTriggered:
			{
				coverLeftClicked()
			}
		}*/

		CoverAction
		{
			property bool isLit: false
			iconSource: "image://theme/icon-cover-play"
			onTriggered:
			{
				coverRightClicked();
				isLit = !isLit;
				iconSource : isLit ? "image://theme/icon-cover-stop" : "image://theme/icon-cover-play";
				lifxGetBulbs( cover );

			}
		}
    }
//	SilicaListView
//	SilicaGridView
	GridView
	{
		id: listView
		anchors.fill: parent

		model: ListModel
		{
			id: listModelCover
		}
		delegate: ListItem
		{
			id: delegate
			width: parent.width / 2 //* 0.8//ListView.view.width
			height: Theme.itemSizeSmall

			/*Rectangle
			{
				anchors.horizontalCenter: parent.horizontalCenter
				width: Theme.itemSizeSmall * 0.6 //60
				height: width
				//color: power ? "white" : "black"
				color: power ? Qt.hsla(hue/65535, saturation/65535, brightness/65535) : "black"
				border.color: selected ? "#60F000" : "#800000" //selected ? "green" : "black"
				border.width: 4
				radius: width*0.5
				antialiasing: true
				/*Text
				{
					//anchor.fill : parent
					color: "blue"
					text: name
				}* /
			}*/
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
				//hue/65535, saturation/65535, brightness/65535
				anchors.fill: icon
				source: icon
				hue: bulb_hue/65535
				saturation: bulb_saturation/65535
				lightness: bulb_power ? (bulb_brightness*2/65535) -1 : -1
			}
		}
	}
	onStatusChanged:
	{
		if (status == PageStatus.Active)
		{
			lifxGetBulbs( cover );
		}
	}

	Component.onCompleted:
	{
		console.log('cover.onComplete()');
	}
	function setLights(lights)
	{
		listModelCover.clear();
		for (var i=0; i<lights.length; i++) {
			var light = lifxBulbGetObject_sync(lights[i]['bulb_addr']);
			listModelCover.append(light);
		}
	}

/*	Rectangle
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
	}*/

/*	SilicaGridView
	{
		anchors.fill: parent
		model: ListModel
		{
			ListItem { fruit: "jackfruit" }
			ListItem { fruit: "orange" }
			ListItem { fruit: "lemon" }
			ListItem { fruit: "lychee" }
			ListItem { fruit: "apricots" }
		}
		delegate: Item
		{
			width: GridView.view.width
			height: Theme.itemSizeSmall

			Label { text: fruit }
		}
	}*/
}


