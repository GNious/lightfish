#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import threading
from threading import Thread
import time
usleep = lambda x: time.sleep(x/1000000.0)
import colorsys
import random


import lifx3
import lifx3.lifx


BulbList = dict()
BulbListSelected = dict()

# Example how to fill a list model with data from Python.
def get_data():
	lights = lifx3.lifx.get_lights()
	data = []
	for bulb in lights:
		data.append({'bulb_name': bulb.get_addr(), 'bulb_addr': bulb.get_addr()})
	return data
	return [
			{'name': 'Alpha', 'team': 'red'},
			{'name': 'Beta', 'team': 'blue'},
			{'name': 'Gamma', 'team': 'green'},
			{'name': 'Delta', 'team': 'yellow'},
			{'name': 'Epsilon', 'team': 'orange'},
	]

def get_bulbs(discovery = False):
	if( (len(BulbList) < 1) or (discovery) ):
		print("Getting bulbs from network")
		lights = lifx3.lifx.get_lights()
	else:
		print("Getting bulbs from memory")
		lights = BulbList.values()
	data = []
	for bulb in lights:
		#bulb.get_label()
		data.append({'bulb_name': bulb.bulb_label, 'bulb_addr': bulb.get_addr()})
		#data.append({'name': bulb.bulb_label, 'addr': bulb.addr})
		BulbList[bulb.get_addr()] = bulb
	return data

#    def recv_lightstatus(self, lightstatus):
#        self.addr = lightstatus.target
#        self.hue = lightstatus.payload.data['hue']
#        self.saturation = lightstatus.payload.data['saturation']
#        self.brightness = lightstatus.payload.data['brightness']
#        self.kelvin = lightstatus.payload.data['kelvin']
#        self.dim = lightstatus.payload.data['dim']
#        if lightstatus.payload.data['power'] > 0:
#            self.power = True
#        else:
#            self.power = False
#        self.bulb_label = str(lightstatus.payload.data['bulb_label'],
#                              encoding='utf-8').strip('\00')
#        self.tags = lightstatus.payload.data['tags']

def get_bulb(addr):
	if( len(BulbList) < 1):
	    get_bulbs()
	bulb = BulbList[addr]
	data = {}
	data['bulb_name'] =  bulb.bulb_label
	data['bulb_addr'] = addr #bulb.addr
	data['bulb_power'] = bulb.power
	data['bulb_hue'] = bulb.hue
	data['bulb_saturation'] = bulb.saturation
	data['bulb_brightness'] = bulb.brightness
	data['bulb_kelvin'] = bulb.kelvin
	data['bulb_tags'] = bulb.tags
	data['bulb_selected'] = addr in BulbListSelected
	return data

def set_active(addr):
	if( addr in BulbList):
		if( addr not in BulbListSelected):
			BulbListSelected[addr] = BulbList[addr]

def set_inactive(addr):
	if( addr in BulbListSelected):
		del BulbListSelected[addr]

def get_selected_count():
	return len(BulbListSelected)

def turn_on_all():
	for addr in BulbListSelected:
		#BulbListSelected[addr].set_power(1)
		lifx3.lifx.set_power(addr, 1)
	lifx3.lifx.pause(0.2)

def turn_off_all():
	for addr in BulbListSelected:
		#BulbListSelected[addr].set_power(0)
		lifx3.lifx.set_power(addr, 0)
	lifx3.lifx.pause(0.2)

def set_power(addr, power):
	lifx3.lifx.set_power(addr, power)
	lifx3.lifx.pause(0.2)
	return 1

def set_color_rgbhex(colorstring):
	rh = colorstring[1:3]
	gh = colorstring[3:5]
	bh = colorstring[5:7]
	print( rh + " - " + gh + " - " + bh)
	r = int(rh, 16)
	g = int(gh, 16)
	b = int(bh, 16)
	print( str(r) + " - " + str(g) + " - " + str(b))
	hls = colorsys.rgb_to_hls( r , g, b )
	hsv = colorsys.rgb_to_hsv( r , g, b )
	for addr in BulbListSelected:
		#set_color(self, hue, saturation, brightness, kelvin, fade_time):
		BulbListSelected[addr].hue = int(hsv[0]*65535)
		BulbListSelected[addr].saturation = int(hsv[1]*65535)
		#BulbListSelected[addr].brightness = int(hsv[2]*65535/255)
		#BulbListSelected[addr].set_color( int(hsv[0]*65535), int(hsv[1]*65535), int(hsv[2]*65535/255), 3500, 1000)
	set_color()

def set_brightness(brightness):
	for addr in BulbListSelected:
		#set_color(self, hue, saturation, brightness, kelvin, fade_time):
		#BulbListSelected[addr].get_state()
		BulbListSelected[addr].brightness = int(brightness*65535/100)
		#BulbListSelected[addr].set_color( BulbListSelected[addr].hue, BulbListSelected[addr].saturation, int(brightness*65535/100), BulbListSelected[addr].kelvin, 100)
	set_color()

def set_saturation(saturation):
	for addr in BulbListSelected:
		BulbListSelected[addr].saturation = int(saturation*65535/100)
		#BulbListSelected[addr].set_color( BulbListSelected[addr].hue, int(saturation*65535/100), BulbListSelected[addr].brightness, BulbListSelected[addr].kelvin, 100)
	set_color()

def set_kelvin(kelvin):
	for addr in BulbListSelected:
		BulbListSelected[addr].kelvin = int((kelvin* (8000-2700))/100)+2700
		BulbListSelected[addr].saturation = 0
		#BulbListSelected[addr].set_color( BulbListSelected[addr].hue, int(saturation*65535/100), BulbListSelected[addr].brightness, BulbListSelected[addr].kelvin, 100)
	set_color()

def set_color():
	for addr in BulbListSelected:
		#BulbListSelected[addr].set_color( BulbListSelected[addr].hue, BulbListSelected[addr].saturation, BulbListSelected[addr].brightness, BulbListSelected[addr].kelvin, 300)
		lifx3.lifx.set_color(addr, BulbListSelected[addr].hue, BulbListSelected[addr].saturation, BulbListSelected[addr].brightness, BulbListSelected[addr].kelvin, 500)
	lifx3.lifx.pause(0.01)  #0.2

#def set_color_rgb(red, green, blue):
#	hue = 0
#	saturation = 0
#	brightness = 0
#
#	min = min( red, green, blue )
#	max = max( red, green, blue )
#	brightness = max				# v
#
#	delta = max - min
#
#	if( max == 0 ):
#		saturation = 0
#		hue = 0  //-1;
#		return;
#	else:
#		saturation = delta / max		# s
#
#	if( red == max ):
#	    hue = ( green - blue ) / delta		# between yellow & magenta
#	elif( green == max ):
#		hue = 2 + ( blue - red ) / delta	# between cyan & yellow
#	else:
#		hue = 4 + ( red - green ) / delta	# between magenta & cyan
#
#	hue *= 60				# degrees
#	if( hue < 0 ):
#		hue += 360

killThreads = False	    #Master-switch, in case need to kill all threads
#threadPartyRun = False	    #Indicate whether to let Party-Thread run

def pythonShutdown():
	party_stop()
	killThreads = False	    #Kill all threads
	#threadPartyRun = False	    #Indicate whether to let Party-Thread run

#def thread_party_func():
#	sys.stderr.write('party thread launched')
#	print( "threadPartyRun: "+str(threadPartyRun))
#	print( "killThreads: "+str(killThreads))
#	while( (not killThreads) and (threadPartyRun) ):   #Loop
#		for addr in BulbListSelected:	    #Loop through all bulbs
#			#set_color(self, hue, saturation, brightness, kelvin, fade_time):
#			#BulbListSelected[addr].set_color(  random.randint(1, 65534), 65535, BulbListSelected[addr].brightness, 3500, 400)
#			BulbListSelected[addr].set_color(  random.randint(1, 65534), 65535, random.randint(1, 65534), 3500, 400)    #Randomize hue and brightness
#			usleep(100) #sleep during 100ms
#	sys.stderr.write('party thread stopping')
#
#def party_start():
#	partythread = threading.Thread(target=thread_party_func)
#	threadPartyRun = True		#This is by no means proper - use semaphores
#	print( "threadPartyRun: "+str(threadPartyRun))
#	print( "killThreads: "+str(killThreads))
#	partythread.start()	#Start the party
#
#def party_stop():
#	threadPartyRun = False		#This is by no means proper - use semaphores
#	partythread.join()	#Wait and merge

class PartyThread(Thread):
	def __init__(self):
		Thread.__init__(self)

	#killThreads = False	    #Master-switch, in case need to kill all threads
	threadPartyRun = False	    #Indicate whether to let Party-Thread run

	def run(self):
		sys.stderr.write('party thread launched')
		#print( "C:self.threadPartyRun: "+str(self.threadPartyRun))
		#print( "C:killThreads: "+str(killThreads))
		while( (not killThreads) and (self.threadPartyRun) ):   #Loop
			#print( "C:loooop ")
			for addr in BulbListSelected:			        #Loop through all bulbs
				hue = random.randint(1, 65534)			#Randomize hue
				brightness = (random.randint(0, 1)) * 65534	#Randomize brightness
				#set_color(self, hue, saturation, brightness, kelvin, fade_time):
				#BulbListSelected[addr].set_color(  hue, 65535, brightness, 3500, 400)
				lifx3.lifx.set_color(addr, hue, 65535, brightness, 3500, 400)
				usleep(100) #sleep during 100ms
			lifx3.lifx.pause(0.01)
		#sys.stderr.write('party thread stopping')

partythread = PartyThread()

def party_start():
	partythread.threadPartyRun = True		#This is by no means proper - use semaphores
	#print( "G:partythread.threadPartyRun: "+str(partythread.threadPartyRun))
	#print( "G:killThreads: "+str(killThreads))
	partythread.start()	#Start the party

def party_stop():
	partythread.threadPartyRun = False		#This is by no means proper - use semaphores
	partythread.join()	#Wait and merge
	#partythread = PartyThread()
