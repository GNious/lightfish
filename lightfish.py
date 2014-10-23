#!/usr/bin/env python
# -*- coding: utf-8 -*-

import lifx3
import lifx3.lifx3

# Example how to fill a list model with data from Python.
def get_data():
	lights = lifx3.lifx3.get_lights()
	data = []
	for bulb in lights:
		data.append({'name': bulb.get_addr(), 'addr': bulb.get_addr()})
	return data
	return [
		{'name': 'Alpha', 'team': 'red'},
		{'name': 'Beta', 'team': 'blue'},
		{'name': 'Gamma', 'team': 'green'},
		{'name': 'Delta', 'team': 'yellow'},
		{'name': 'Epsilon', 'team': 'orange'},
	]

