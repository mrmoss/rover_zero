floor_h=2;
inner_size=[69,69];
inner_h=14.75;
walls=1.2;
lip_h=0.5;
$fn=100;
screw_d=3;
screw_post_d=7.1;
screw_head_d=7;
motor_wiggle=0.4;
motor_d=10.01+motor_wiggle;
motor_small_d=8.04+motor_wiggle;
usb_size=[3.5,8.5];
button_size=[8,16];
button_lip_width=2;
button_lip_height=0.75;

module motor_3d(length)
{
    translate([-length/2,0,0])
        rotate([90,90,90])
            linear_extrude(height=length)
                intersection()
                {
                    circle(d=motor_d);
                    square(size=[motor_d,motor_small_d],center=true);
                }
}

module other_holes_3d()
{
    width=inner_size.x+walls*2+2;
    spacing=inner_size.y/2;
    translate([0,0,(floor_h*2+inner_h)/2])
    {
        translate([0,spacing/2,0])
            motor_3d(width);
        translate([0,-spacing/2,0])
            motor_3d(width);
        translate([0,walls*2,0])
            cube(size=[usb_size.y,width,usb_size.x],center=true);
    }
}

module motor_support_3d()
{
    //7.5
    size=[7.5,motor_d,4];
    spacing=inner_size.y/2;
    xoffset=inner_size.y/2-size.x/2;
    translate([xoffset,spacing/2,size.z/2])
        cube(size=size,center=true);
    translate([-xoffset,spacing/2,size.z/2])
        cube(size=size,center=true);
    translate([-xoffset,-spacing/2,size.z/2])
        cube(size=size,center=true);
    translate([xoffset,-spacing/2,size.z/2])
        cube(size=size,center=true);
}

module holes_2d(hole_d)
{
    corner=[inner_size.x/2-screw_d+walls/4,inner_size.y/2-screw_d+walls/4];
    translate([corner.x,corner.y])
        circle(d=hole_d);
    translate([-corner.x,corner.y])
        circle(d=hole_d);
    translate([-corner.x,-corner.y])
        circle(d=hole_d);
    translate([corner.x,-corner.y])
        circle(d=hole_d);
}

module floor_2d(size=[10,10],wall_thickness=1.5,roundness=1.5)
{
    offset(roundness/2)
        square(size=[size.x-roundness+wall_thickness*2,size.y-roundness+wall_thickness*2],
            center=true);
}

module floor_3d(size=[10,10],height=1,wall_thickness=1.5,roundness=1.5)
{
    linear_extrude(height=height)
        floor_2d(size,wall_thickness,roundness);
}

module floor_with_holes_3d(size=[10,10],height=1,wall_thickness=1.5,roundness=1.5,hole_d)
{
    linear_extrude(height=height)
        difference()
        {
            floor_2d(size,wall_thickness,roundness);
            holes_2d(hole_d);
        }
}

module wall_2d(size=[10,10],wall_thickness=1.5,roundness=1.5)
{
    difference()
    {
        floor_2d(size,wall_thickness,roundness);
        floor_2d(size,0,roundness);
    }
}

module wall_3d(size=[10,10],height=1,wall_thickness=1.5,roundness=1.5)
{
    linear_extrude(height=height)
        wall_2d(size,wall_thickness,roundness);
}

module shell_3d(size,wall_thickness,floor_h,middle_h)
{
    //Bottom shell
    floor_3d(inner_size,floor_h,wall_thickness,1.5);

    difference()
    {
        translate([0,0,floor_h])
        {
            //Middle shell
            wall_3d(inner_size,inner_h+floor_h,wall_thickness);
            
            //Screw posts
            linear_extrude(height=inner_h)
                difference()
                {
                    holes_2d(screw_post_d);
                    holes_2d(screw_d);
                }

            //Motor supports
            motor_support_3d();
        }
        other_holes_3d();
    }
}

module button_3d(yoff,height=1,wiggle=0.35)
{
    translate([-(yoff-(button_size.x+wiggle)/2),0])
    {
        translate([button_lip_width/2,0])
            linear_extrude(height=button_lip_height)
                square(size=button_size+[button_lip_width,button_lip_width*2],center=true);
        translate([0,0,button_lip_height])
            linear_extrude(height=height-wiggle/2)
                square(size=button_size,center=true);
    }
}

module top_holes_2d(yoff,wiggle=0.35)
{
    translate([-(yoff-(button_size.x+wiggle)/2),0])
        square(size=button_size+[wiggle,wiggle],center=true);
}

module top_3d(size=[10,10],height=1,roundness=1.5,wiggle=0.35)
{
    linear_extrude(height=height/2)
        difference()
        {
            floor_2d(size,-wiggle/2,roundness);
            union()
            {
                holes_2d(screw_d+wiggle);
                top_holes_2d(size.y/2,wiggle);
            }
        }
    translate([0,0,floor_h/2])
        linear_extrude(height=(height-wiggle)/2)
            difference()
            {
                floor_2d(size,-wiggle/2,roundness);
                union()
                {
                    holes_2d(screw_head_d);
                    top_holes_2d(size.y/2,wiggle);
                }
            }
}

//Main shell
shell_3d(inner_size,walls,floor_h,inner_h);

translate([0,0,floor_h+inner_h])
{
    wiggle=0.45;
    //Top plate
    top_3d(inner_size,floor_h,1.5,wiggle);
    
    //Button
    translate([0,0,-button_lip_height])
        button_3d(inner_size.y/2,floor_h+0.25,wiggle);
}