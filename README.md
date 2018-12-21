### Rover Zero
This is a quick writeup on this little 3D printed robot. It runs on a RPi Zero W (built-in Wifi and bluetooth for $5).

![](https://github.com/mrmoss/rover_zero/raw/master/pics/00_controller.jpg)
![](https://github.com/mrmoss/rover_zero/raw/master/pics/01_charge.jpg)
![](https://github.com/mrmoss/rover_zero/raw/master/pics/02_top.jpg)
![](https://github.com/mrmoss/rover_zero/raw/master/pics/03_internals.jpg)

I'm super lazy...and not doing an electrical hookup diagram or anything...I want to say it is fairly self explanatory via the code+parts...but it isn't...I can only do so much...

The MPU6050 is used to detect which side of the robot is "up". So if you flip it upside down, it will still drive normally instead of mirrored.

Only thing I'm not really happy with are the wheels. They have a hot-glue based traction layer on them. The motor connector is kind of garbage...I've debated just gluing them to the motors...

## Parts
- [5v Motors](https://www.amazon.com/dp/B01N4G8DSO/)
- [MPU6050](https://www.amazon.com/dp/B008BOPN40)
- [L293D 2 Full H-Bridge](https://www.amazon.com/dp/B07CNCNQV9)
- [Battery](https://www.amazon.com/dp/B0767D8GVG)
- [Charge Board](https://www.amazon.com/dp/B01LHD9D7E)
- [On/Off Button](https://www.amazon.com/dp/B079D6W1YV)
- RPI Zero W (You can get these for $5/board if you shop around)
- PS3 Bluetooth Controller (You can get these for $10-$20 if you shop around)

## Dependencies
`sudo pip3 install evdev smbus2`

## PS3 Controller Setup

### Installation
```
sudo apt install libusb-dev joystick
cd /tmp/
wget http://www.pabr.org/sixlinux/sixpair.c
gcc -o sixpair sixpair.c -lusb
#And then I read sixpair.c for shells...because I'm paranoid I guess...
sudo mv sixpair /usr/bin
rm -f sixpair.c
```

### Connect
1. Plug in controller via USB.
2. Run `sudo sixpair`
3. Unplug controller.
4. Turn on controller.
5. Trust the controller:
```
sudo bluetoothctl
agent on
discoverable on
#Wait to see controller and grab address
trust XXXXXXXXXXXXXXXXXXXXX
connect XXXXXXXXXXXXXXXXXXXXX
discoverable off
```
