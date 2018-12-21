#!/usr/bin/python3
import RPi.GPIO as IO
import time

def setup_pwm_pin(pin_num):
        IO.setwarnings(False)
        IO.setmode(IO.BCM)
        IO.setup(pin_num,IO.OUT)
        pin=IO.PWM(pin_num,2000)
        pin.start(0)
        return pin

class object:
	def __init__(self,pin1,pin2):
		self.pin1=setup_pwm_pin(pin1)
		self.pin2=setup_pwm_pin(pin2)

	def drive(self,speed):
		if speed<0:
			self.pin1.ChangeDutyCycle(0)
			self.pin2.ChangeDutyCycle(-speed)
		else:
			self.pin1.ChangeDutyCycle(speed)
			self.pin2.ChangeDutyCycle(0)
	def stop(self):
		self.drive(0)
