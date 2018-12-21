$fn=100;

rzw_hole_d=2.5;
rzw_w_spacing=23;
rzw_h_spacing=58;

rzw_board_w_space=2.16;
rzw_board_h_space=2.12;
rzw_board_z=4.78;
rzw_board_w=rzw_board_w_space*2+rzw_w_spacing;
rzw_board_h=rzw_board_h_space*2+rzw_h_spacing;

charge_board_w=27.65;
charge_board_h=17.23;
charge_board_z=3.57;

battery_w=25;
battery_h=37;
battery_z=6;

mpu6050_w=15.66;
mpu6050_h=20.55;
mpu6050_z=3.27;

motor_d=10.01;
motor_small_d=8.04;
motor_h=12.5;

gearbox_d1=10.13;
gearbox_h1=7;

gearbox_d2=3.1;
gearbox_d2_2=4.5;
gearbox_h2=3.1;
gearbox_tooth_w=0.95;

gearbox_d3=1.45;
gearbox_h3=0.75;

switch_size=[8,8,14];

module rzw_holes_2d()
{
	circle(d=rzw_hole_d);
	translate([rzw_w_spacing,0])
		circle(d=rzw_hole_d);
	translate([rzw_w_spacing,rzw_h_spacing])
		circle(d=rzw_hole_d);
	translate([0,rzw_h_spacing])
		circle(d=rzw_hole_d);
}

module rzw_3d()
{
    translate([-rzw_board_w/2+rzw_board_w_space,-rzw_board_h/2+rzw_board_h_space,0])
        color([0,1,0])
            linear_extrude(height=rzw_board_z)
                difference()
                {
                    translate([-rzw_board_w_space,-rzw_board_h_space])
                        square(size=[rzw_board_w,rzw_board_h]);
                    rzw_holes_2d();
                }
}

module charge_board_3d()
{
	color([0,0,1])
		linear_extrude(height=charge_board_z)
			square(size=[charge_board_w,charge_board_h]);
}

module mpu6050_board_3d()
{
	color([0,0,1])
		linear_extrude(height=mpu6050_z)
			square(size=[mpu6050_w,mpu6050_h]);
}

module battery_3d()
{
	color([0.5,0.5,0.5])
		linear_extrude(height=battery_z)
			square(size=[battery_w,battery_h]);
}

module gearbox_2d(wiggle=0)
{
	circle(d=gearbox_d2+wiggle);
	square(size=[gearbox_d2_2+wiggle,gearbox_tooth_w+wiggle],center=true);
	rotate(360/3)
		square(size=[gearbox_d2_2+wiggle,gearbox_tooth_w+wiggle],center=true);
	rotate(360/3*2)
		square(size=[gearbox_d2_2+wiggle,gearbox_tooth_w+wiggle],center=true);
	
}

module motor_3d()
{
    translate([0,0,-motor_h])
    {
        color([0.7,0.7,0.7])
            linear_extrude(height=motor_h)
                intersection()
                {
                    circle(d=motor_d);
                    square(size=[motor_d,motor_small_d],center=true);
                }

        color([1,1,1])
            translate([0,0,motor_h])
                linear_extrude(height=gearbox_h1)
                    circle(d=gearbox_d1);

        color([1,1,1])
            translate([0,0,motor_h+gearbox_h1])
                linear_extrude(height=gearbox_h2)
                    gearbox_2d();

        color([1,1,1])
            translate([0,0,motor_h+gearbox_h1+gearbox_h2])
                linear_extrude(height=gearbox_h3)
                    circle(d=gearbox_d3);
    }
}





inner_sq_size=69;
    square(size=[inner_sq_size,inner_sq_size],center=true);

axel_vspacing=30;
axel_hspacing=inner_sq_size;

//Left Wheels
translate([-axel_hspacing/2,axel_vspacing/2,0])
    rotate([90,90,-90])
        motor_3d();
translate([-axel_hspacing/2,-axel_vspacing/2,0])
    rotate([90,90,-90])
        motor_3d();
//Right Wheels
translate([axel_hspacing/2,axel_vspacing/2,0])
    rotate([90,90,90])
        motor_3d();
translate([axel_hspacing/2,-axel_vspacing/2,0])
    rotate([90,90,90])
        motor_3d();
//RPI
rzw_3d();
translate([29,0,0])
    battery_3d();
//Charger
translate([])
    charge_board_3d();
//mpu6050_board_3d();