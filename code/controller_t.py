#!/usr/bin/env python3
#	Dependencies: pip install evdev
import evdev
import select
import time

class object:
	def __init__(self,name):
		self.device=None
		self.states={'counter':0,'axes':{'REL_Y':128,'REL_RY':128},'keys':{'BTN_SELECT':False,'BTN_START':False}}
		self.dead_zone=10
		for device in evdev.list_devices():
			device=evdev.InputDevice(device)
			if device.name==name:
				self.device=device
			else:
				device.close()

	def loop(self):
		while self.device and self.available_m():
			for event in self.device.read():
				if event.type==evdev.ecodes.EV_KEY:
					event=evdev.categorize(event)
					if type(event.keycode)!=str:
						keys=['BTN_EAST','BTN_NORTH','BTN_WEST','BTN_SOUTH']
						new_keycode='UNKNOWN'
						for key in keys:
							if key in event.keycode:
								new_keycode=key
								break
						event.keycode=new_keycode
					self.states['keys'][event.keycode]=event.keystate!=0
				elif event.type==evdev.ecodes.EV_ABS:
					if abs(abs(event.value)-128)<self.dead_zone:
						event.value=128
					self.states['axes'][evdev.ecodes.REL[event.code]]=event.value
			time.sleep(0.01)

	def close(self):
		if self.device:
			self.device.close()
			self.device=None

	def available_m(self):
		try:
			readable,writeable,errored=select.select([self.device],[],[],0)
			return self.device in readable
		except Exception:
			return False
