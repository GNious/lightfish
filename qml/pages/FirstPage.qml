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
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.0


Page
{
	id: page
	//property Python py
	property bool isColor : true
	property bool isPartyMode : false

	// To enable PullDownMenu, place our content in a SilicaFlickable
	SilicaFlickable
	{
		anchors.fill: parent

		// PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
		PullDownMenu
		{
			id: pushDownFirst
			MenuItem
			{
				text: qsTr("Select groups")
				onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
			}
			MenuItem
			{
				text: qsTr("Select bulbs")
				onClicked: pageStack.push(Qt.resolvedUrl("BulbListPage.qml"), { /*py: py*/})
				//onClicked: pageStack.push(bulbListPage)
				//BulbListPage { id: bulbListPage }
			}
		}
		PushUpMenu
		{
			id: pushUpFirst
			MenuItem
			{
				text: isColor ? qsTr("White Mode") : qsTr("Colour Mode")
				onClicked:
				{
					isColor = !isColor
					console.log('lightfish swapping colour/white');
					colorButton.enabled = isColor
					sliderSaturation.label = isColor ? "Whiteness" : "Temperature (K)"
				}
			}
			MenuItem
			{
				id: pushUpPartyMode
				property bool isPartyMode: false
				text: isPartyMode ? qsTr("Normal Mode") : qsTr("Party Mode")
				onClicked:
				{
					if(pushUpPartyMode.isPartyMode)
					{
						console.log('lightfish removing fancy');
						py.call('lightfish.party_stop', [], function(result)
						{
							console.log('lightfish non-party');
							pushUpPartyMode.isPartyMode = false;
							pushUpPartyMode.text = isPartyMode ? qsTr("Normal Mode") : qsTr("Party Mode");
						});
					}
					else
					{
						remorse.execute("Starting Party mode", function()
						{
							console.log('lightfish getting fancy');
							py.call('lightfish.party_start', [], function(result)
							{
								console.log('lightfish party');
								pushUpPartyMode.isPartyMode = true;
								pushUpPartyMode.text = isPartyMode ? qsTr("Normal Mode") : qsTr("Party Mode");
							});
						});
					}
				}
			}
		}
		RemorsePopup { id: remorse }

        // Tell SilicaFlickable the height of its content.
		contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
			//anchors.verticalCenter: parent.verticalCenter
			//anchors.centerIn: parent
			anchors.fill: parent
			PageHeader {
				title: qsTr("LightFish")
			}
			Label
			{
                x: Theme.paddingLarge
				text: qsTr("Just some random text being shown here until I figure out what to actually put into this place")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
			Slider
			{
				id: sliderBrightness
				property int brightness
				//label: "Brightness"
				//anchors.top: colorButton.bottom
				value: 50
				minimumValue: 000
				maximumValue: 100
				width: parent.width
				anchors.horizontalCenter: parent.horizontalCenter
				valueText : Math.round(value) + "%"
				onSliderValueChanged:
				{
					if(brightness < value-2 || brightness > value+2)
					{
						brightness = Math.round(value)
						lifxBulbsSelectedBrightness(brightness);
					}
					//lifxBulbsSelectedBrightness(Math.round(value));
				}
				label: "Brightness"
			}
			Slider
			{
				id: sliderSaturation
				property int saturation
				//label: "Brightness"
				//anchors.top: colorButton.bottom
				value: 50
				minimumValue: 000
				maximumValue: 100
				width: parent.width
				anchors.horizontalCenter: parent.horizontalCenter
				valueText : isColor ?  Math.round(value) + "%" : Math.round( (value * (8000-2700)) / 100 )+2700 //2700-8000K
				onSliderValueChanged:
				{
					var adjValue = isColor ? 100-value : value
					if(saturation < adjValue-2 || saturation > adjValue+2)
					{
						saturation = Math.round(adjValue)
						if( isColor )
							lifxBulbsSelectedSaturation(saturation);
						else
							lifxBulbsSelectedKelvin(saturation);
					}
				}
				label: isColor ? "Whiteness" : "Temperature (K)"
			}
			Row
			{
				id: lightPowerRow
				anchors.horizontalCenter: parent.horizontalCenter
				Button
				{
					id: onButton
					text: "Turn On"
					onClicked:
					{
						lifxBulbsSelectedOn();
						offButton.enabled = true;
					}
				}
				Button
				{
					id: offButton
					text: "Turn Off"
					onClicked:
					{
						lifxBulbsSelectedOff();
						onButton.enabled = true;
					}
				}
			}
			Button
			{
				id: colorButton
				text: "Choose a color"
				anchors.horizontalCenter: parent.horizontalCenter

				onClicked:
				{
					var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
					dialog.accepted.connect(function()
					{
						//colorIndicator.color = dialog.color
						colorButton.text = "Choose a color (" + dialog.color+")";
						py.call('lightfish.set_color_rgbhex', [""+dialog.color], function(result)
						{
							console.log('lightfish getting colour');
						});
						pushDownFirst.highlightColor = dialog.color;
						pushUpFirst.highlightColor = dialog.color;
						lifxGetBulbs( page );
					})
				}
			}
		}

    }
	onStatusChanged:
	{
		var cntSelectedBulbs = lifxBulbsSelectedCount();
		if (status == PageStatus.Active && cntSelectedBulbs == 0)
		{
			pageStack.push(Qt.resolvedUrl("BulbListPage.qml"), { /*py: py*/})
		}
		if (status == PageStatus.Active && cntSelectedBulbs > 0)
		{
			lifxGetBulbs( page );
		}
	}
	function setLights(lights)
	{
		var cntSelectedBulbs = lights.length;
		var newBrightness = 0;
		var newHue = 0;
		var newSaturation = 0;
		var hasPowerOn = false;
		var hasPowerOff = false
		for (var i=0; i<lights.length; i++)
		{
			var light = lifxBulbGetObject_sync(lights[i]['bulb_addr']);
			newBrightness += light.bulb_brightness;
			newHue += light.bulb_hue;
			newSaturation += light.bulb_saturation;
			hasPowerOn = light.bulb_power > 0 ? true : hasPowerOn;
			hasPowerOff = light.bulb_power == 0 ? false : hasPowerOff;
		}
		newBrightness = newBrightness/cntSelectedBulbs;
		newHue = newHue/cntSelectedBulbs;
		newSaturation = newSaturation/cntSelectedBulbs;
		if(hasPowerOn)
			offButton.enabled = true;
		if(hasPowerOff)
			onButton.enabled = true;
		sliderBrightness.value = 100/65535 * newBrightness;
		if(isColor)
			sliderSaturation.value = 100- (100/65535 * newSaturation);
	}
}


