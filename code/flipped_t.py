#!/usr/bin/python3
import smbus2

class object:
	def __init__(self):
		self.addr=0x68
		self.reg=0x3f
		self.pwr_mgmt=0x6b
		self.bus=smbus2.SMBus(1)
		self.bus.write_byte_data(self.addr,self.pwr_mgmt,0)
	def update(self):
		z=(self.bus.read_byte_data(self.addr,self.reg)<<8)+self.bus.read_byte_data(self.addr,self.reg+1)
		if z>=0x8000:
			z=-((65535-z)+1)
		return z/16384.0
