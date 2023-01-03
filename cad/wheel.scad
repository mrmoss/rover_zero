$fn=200;
wheel_floor=2;
wheel_d=30;
wheel_h=10;
wheel_wall=2;
wheel_hub_d=8;
wheel_hub_depth=2;
wheel_spoke_w=1;
num_spokes=11;
sigma=0.05;

module gearbox_2d(wiggle=0.1)
{
    gearbox_d1=3.1;
    gearbox_d2=4.8;
    gearbox_h2=3.1;
    gearbox_tooth_w=0.95;
	circle(d=gearbox_d1+wiggle);
	square(size=[gearbox_d2+wiggle,gearbox_tooth_w+wiggle],center=true);
	rotate(360/3)
		square(size=[gearbox_d2+wiggle,gearbox_tooth_w+wiggle],center=true);
	rotate(360/3*2)
		square(size=[gearbox_d2+wiggle,gearbox_tooth_w+wiggle],center=true);
	
}

module wheel_3d()
{
	//Bottom floor
	linear_extrude(height=wheel_floor)
	{
		difference()
		{
			circle(d=wheel_d-wheel_wall*2);
			union()
			{
				circle(d=wheel_hub_d);
				for (i=[0:num_spokes])
					rotate(i*360/num_spokes)
						translate([-wheel_spoke_w/2,wheel_hub_d/2-sigma])
							square(size=[wheel_spoke_w,(wheel_d-wheel_hub_d-wheel_wall*2)]);
			}
		}
	}
	
	//Wall
	union()
	{
		linear_extrude(height=wheel_h)
			difference()
			{
				circle(d=wheel_d);
				circle(d=wheel_d-wheel_wall*2);
			}

		//Coupler
		linear_extrude(height=wheel_floor+wheel_hub_depth)
			difference()
			{
				circle(d=wheel_hub_d);
				gearbox_2d();
			}
	}
}

wheel_3d();