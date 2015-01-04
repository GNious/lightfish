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
//import io.thp.pyotherside 1.0
import IoTQuick 1.0
import IoTQuick.LIFXLightsModel 1.0


import "storage.js" as Storage
import "analytics.js" as Analytics


ApplicationWindow
{
    property int bulbsAreOn: 0
    id: p
    property string analyticsID : ""
    property string appName : "LightFish"
    property string appVersion: "0.2a"

    property string appUUID : quuid;

    /*Python
    {
        id: py
        Component.onCompleted:
        {
            Storage.initialize();
            var oldUUID = Storage.getSetting("analytics","UUID");
            if(oldUUID != "Unknown")
                appUUID = oldUUID;
            else
                Storage.setSetting("analytics", "UUID", appUUID);
            //function register( trackingID_in, clientID_in, appName_in, appVersion_in, appID_in )
            Analytics.register(analyticsID, appUUID /*"Jolla"* /, appName, appVersion, "dk.thang.lightfish");
            Analytics.registerAdditionSettings("screenres",""+p.width+"x"+p.height);

            // Add the directory of this .qml file to the search path
            addImportPath(Qt.resolvedUrl('.'));

            // Import the main module and load the data
            console.log('lightfish importing');
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
                    pageStack.replace(Qt.resolvedUrl("pages/FirstPage.qml"), { /*py: py* /})
                });
                console.log('lightfish processed');
                callScreenView();

            });
            setHandler('bulbs.found', function (count)
            {
                pageStack.replace(Qt.resolvedUrl("FirstPage.qml"), { /*py: py* /})
            });

        }
        //Component.onDestruction:
    }*/

//	initialPage: Component { FirstPage { py: py } }
    initialPage: Qt.resolvedUrl("pages/IntroPage.qml")
//	initialPage: Component { FirstPage {  } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    //bulbslistPage: Qt.resolvedUrl("pages/BulbListPage.qml")

    /*ListModel{id: lightsModel}*/
    LIFXLightsModel
    {
        id: lightsModel
    }


    LIFXDiscoveryClient
    {
        id: discoveryClient
        onNewGatewayClient:{discoveryClient.startDiscoveryTimer(60000);}
        onNewIoTItem:
        { //item.power = !item.power; textlabel.text = item.label; console.log("New IoTItem!");
            lightsModel.appendLight(item)
            if(lightsModel.rowCount() == 1)
                pageStack.replace(Qt.resolvedUrl("pages/FirstPage.qml"), { /*py: py*/})
        }
    }
    Timer //Timer used for Party-Mode
    {
        id: partyTimer
        interval: 300
        running: false
        repeat: true
        onTriggered:
        {
            var n = 0;
            var lightsCount = lightsModel.rowCount()
            for( ; n<lightsCount; n++)
            {
                if( lightsModel.isSelectedLight(n))
                {
                    var light = lightsModel.getLight(n);
                    //setColourAll(int red, int green, int blue, float brightnesspercent, int saturation, int kelvin);
                    light.setColourAll(Math.random()*255, Math.random()*255, Math.random()*255, Math.random()*100, 255, 8000 );
                }
            }

        }

    }


    function lifxGetBulbs( page )
    {
        console.log("lifxGetBulbs")
    }
    function lifxBulbGetObject(addr,page)
    {
        console.log("lifxBulbGetObject")
    }
    function lifxBulbGetObject_sync(addr)
    {
        console.log("lifxBulbGetObject_sync ("+addr+")")
        var result = undefined;

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
        var n = 0;
        var lightsCount = lightsModel.rowCount()
        for( ; n<lightsCount; n++)
        {
            if( lightsModel.isSelectedLight(n))
            {
                var light = lightsModel.getLight(n);
                light.power = false;
            }
        }
    }
    function lifxBulbsSelectedCount()
    {
        console.log("lifxBulbsSelectedCount")
        var n = lightsModel.countSelectedLights();

        //console.log("lifxBulbsSelectedCount: "+n+"pcs")
        return n;
    }
    function lifxBulbsSelectedOn()
    {
        console.log("lifxBulbsSelectedOn")
        var n = 0;
        var lightsCount = lightsModel.rowCount()
        for( ; n<lightsCount; n++)
        {
            if( lightsModel.isSelectedLight(n))
            {
                var light = lightsModel.getLight(n);
                light.power = true;
            }
        }
    }
    function lifxBulbSelect(addr)
    {
        console.log("lifxBulbSelect")
    }
    function lifxBulbDeSelect(addr)
    {
        console.log("lifxBulbDeSelect")
    }

    function lifxBulbsSelectedBrightness(value)
    {
        if (value < 1)
            value = 1;
        if (value > 100)
            value = 100;
        //log(n)/log(100)
        //var logval = Math.log(value) * 100 / Math.log(100);
        //n^3/10000
        var logval = value^3/10000;
        console.log("lifxBulbsSelectedBrightness("+value+")=>"+logval);
        var n = 0;
        var lightsCount = lightsModel.rowCount();
        for( ; n<lightsCount; n++)
        {
            if( lightsModel.isSelectedLight(n))
            {
                var light = lightsModel.getLight(n);
                light.brightness = logval; //value;
            }
        }
    }
    function lifxBulbsSelectedSaturation(value)
    {
        var saturation = value * 2.55
        console.log("lifxBulbsSelectedSaturation("+value+")->"+saturation)
        var n = 0;
        var lightsCount = lightsModel.rowCount()
        for( ; n<lightsCount; n++)
        {
            if( lightsModel.isSelectedLight(n))
            {
                var light = lightsModel.getLight(n);
                light.saturation = saturation;
            }
        }
    }
    function lifxBulbsSelectedKelvin(value)
    {
        var kelvin =  (8000-2700)/100*value + 2700 //int((kelvin* (8000-2700))/100)+2700
        console.log("lifxBulbsSelectedKelvin("+value+")->"+kelvin)
        var n = 0;
        var lightsCount = lightsModel.rowCount()
        for( ; n<lightsCount; n++)
        {
            if( lightsModel.isSelectedLight(n))
            {
                var light = lightsModel.getLight(n);
                light.temperature = kelvin;
            }
        }
    }
    function lifxBulbsSelectedColor(value)
    {
        console.log("lifxBulbsSelectedColor")
        var n = 0;
        var lightsCount = lightsModel.rowCount()
        for( ; n<lightsCount; n++)
        {
            if( lightsModel.isSelectedLight(n))
            {
                var light = lightsModel.getLight(n);
                light.colour = value;
            }
        }
    }



    function callScreenView(screen)
    {
        if(!Analytics.isInitialized())
        {
            Storage.initialize();
            var oldUUID = Storage.getSetting("analytics","UUID");
            if(oldUUID != "Unknown")
                p.appUUID = oldUUID;
            else
                Storage.setSetting("analytics", "UUID", p.appUUID);

            //function register( trackingID_in, clientID_in, appName_in, appVersion_in, appID_in )
            Analytics.register(p.analyticsID, p.appUUID , p.appName, p.appVersion, "dk.thang.lightfish");
            Analytics.registerAdditionSettings("screenres",""+p.width+"x"+p.height);

            Analytics.appstart();
        }

        console.log("pythonShutdown")
        Analytics.screenview(screen);
    }
}


