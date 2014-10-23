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
import "pages"
import io.thp.pyotherside 1.0
//import pyotherside 1.2
import "storage.js" as Storage

ApplicationWindow
{
	property int bulbsAreOn: 0
	id: p


	Python
	{
		id: py
		Component.onCompleted:
		{
			// Add the directory of this .qml file to the search path
			addImportPath(Qt.resolvedUrl('.'));

			// Import the main module and load the data
			importModule('lightfish', function ()
			{
				console.log('lightfish imported');
				py.call('lightfish.get_bulbs', [], function(result)
				{
					console.log('lightfish chewing');
					// Load the received data into the list model
					for (var i=0; i<result.length; i++) {
						console.log('lightfish @'+result[i]['bulb_name']);
						//listModel.append(result[i]);
					}
					console.log('lightfish done');
				});
				console.log('lightfish processed');
			});
		}
		//Component.onDestruction:
	}

//	initialPage: Component { FirstPage { py: py } }
	initialPage: Component { FirstPage {  } }
	cover: Qt.resolvedUrl("cover/CoverPage.qml")


	function lifxGetBulbs( page )
	{
		console.log("lifxGetBulbs")
		py.call('lightfish.get_bulbs', [], function(result)
		{
			console.log("lifxGetBulbs: "+result.length+" lights");
			page.setLights(result);
		});
	}
	function lifxBulbGetObject(addr,page)
	{
		console.log("lifxBulbGetObject")
		py.call('lightfish.get_bulb', [addr], function(result)
		{
			console.log("lifxBulbGetObject: got object");
			page.setBulb(result);
		});
	}
	function lifxBulbGetObject_sync(addr)
	{
		console.log("lifxBulbGetObject_sync ("+addr+")")
		var result = py.call_sync('lightfish.get_bulb', [addr])
		console.log("lifxBulbGetObject_sync - got bulb: "+result.bulb_name+"@"+result.bulb_addr)

		return result;
	}

	function coverLeftClicked()
	{
		console.log("coverLeftClicked")
	}
	function coverRightClicked()
	{
		console.log("coverRightClicked")
		if( bulbsAreOn == 0)
		{
			lifxBulbsSelectedOn();
			bulbsAreOn = 1;
		}
		else
		{
			lifxBulbsSelectedOff()
			bulbsAreOn = 0;
		}

	}
	function lifxBulbsSelectedOff()
	{
		console.log("lifxBulbsSelectedOff")
		py.call('lightfish.turn_off_all', [], function(result)
		{
			console.log('lightfish unlight!');
		});
	}
	function lifxBulbsSelectedCount()
	{
		console.log("lifxBulbsSelectedCount")
/*		py.call('lightfish.get_selected_count', [], function(result)
		{
			console.log('lightfish light!');
		});*/
		var n = py.call_sync('lightfish.get_selected_count', []);
		console.log("lifxBulbsSelectedCount: "+n+"pcs")
		return n;
	}
	function lifxBulbsSelectedOn()
	{
		console.log("lifxBulbsSelectedOn")
		py.call('lightfish.turn_on_all', [], function(result)
		{
			console.log('lightfish light!');
		});
	}
	function lifxBulbSelect(addr)
	{
		console.log("lifxBulbSelect")
		py.call('lightfish.set_active', [addr], function(result)
		{
			console.log('lightfish added: '+ name);
		});
	}
	function lifxBulbDeSelect(addr)
	{
		console.log("lifxBulbDeSelect")
		py.call('lightfish.set_inactive', [addr], function(result)
		{
			console.log('lightfish removed: '+ name);
		});
	}

	function lifxBulbsSelectedBrightness(value)
	{
		console.log("lifxBulbsSelectedBrightness")
		py.call('lightfish.set_brightness', [value], function(result)
		{
			console.log('lightfish brightly: '+ value);
		});
	}
	function lifxBulbsSelectedSaturation(value)
	{
		console.log("lifxBulbsSelectedSaturation")
		py.call('lightfish.set_saturation', [value], function(result)
		{
			console.log('lightfish whitely: '+ value);
		});
	}
	function lifxBulbsSelectedKelvin(value)
	{
		console.log("lifxBulbsSelectedKelvin")
		py.call('lightfish.set_kelvin', [value], function(result)
		{
			console.log('lightfish temperature: '+ value);
		});
	}
	function pythonShutdown()
	{
		console.log("pythonShutdown")
		py.call('lightfish.pythonShutdown', [value], function(result)
		{
			console.log('lightfish temperature: '+ value);
		});
	}
}


