#!/usr/bin/env python3
#	Dependencies: pip3 install evdev smbus2
import controller_t
import flipped_t
import motor_t
import os
import time

if __name__=='__main__':
	controller=None
	flipped=None
	motor_l=None
	motor_r=None

	while True:
		try:
			print('Looking for controller...')
			controller_name='Sony Computer Entertainment Wireless Controller'
			controller=controller_t.object(controller_name)
			if not controller.device:
				raise Exception('Could not find controller named "'+controller_name+'".')
			print('Found controller')

			if not flipped:
				print('Setting up flip detector.')
				flipped=flipped_t.object()

			if not motor_l:
				print('Setting up left motor.')
				motor_l=motor_t.object(18,12)
			if not motor_r:
				print('Setting up right motor.')
				motor_r=motor_t.object(19,13)

			while True:
				controller.loop()
				power_l=-(controller.states['axes']['REL_Y']-128)/128.0*100
				power_r=-(controller.states['axes']['REL_RY']-128)/128.0*100
				if flipped.update()<0:
					motor_l.drive(-power_r)
					motor_r.drive(-power_l)
				else:
					motor_l.drive(power_l)
					motor_r.drive(power_r)
				#print(str(power_l)+'\t'+str(power_r))
				if controller.states['keys']['BTN_SELECT'] and controller.states['keys']['BTN_START']:
					print('Powering off')
					controller.close()
					motor_l.stop()
					motor_r.stop()
					os.system("poweroff")
				time.sleep(0.01)

		except KeyboardInterrupt:
			exit(1)

		except Exception as error:
			print(error)

		finally:
			if controller:
				controller.close()
			if motor_l:
				motor_l.stop()
			if motor_r:
				motor_r.stop()

		time.sleep(1)
