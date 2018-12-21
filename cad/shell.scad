floor_h=2;
inner_size=[69,69];
inner_h=12.75;
walls=1.2;
lip_h=0.5;
$fn=100;
screw_d=2;
screw_head_d=4;
motor_d=10.01;
motor_small_d=8.04;

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

module motors_3d()
{
    spacing=inner_size.y/2;
    translate([0,0,(floor_h*2+inner_h)/2])
    {
        translate([0,spacing/2,0])
            motor_3d(inner_size.x+walls*2+2);
        translate([0,-spacing/2,0])
            motor_3d(inner_size.x+walls*2+2);
    }
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

module shell_3d(size,wall_thickness,holes=false,floor_h,middle_h,lip_h,outer_lip=false,lip_wiggle=0.08)
{
    //Bottom shell
    if(holes)
    {
        floor_with_holes_3d(inner_size,floor_h/2,wall_thickness,1.5,screw_head_d);
        translate([0,0,floor_h/2])
            floor_with_holes_3d(inner_size,floor_h/2,wall_thickness,1.5,screw_d);
    }
    else
    {
        floor_3d(inner_size,floor_h,wall_thickness,1.5);
    }

    difference()
    {
        translate([0,0,floor_h])
        {
            //Middle shell
            wall_3d(inner_size,(inner_h-lip_h)/2,wall_thickness);
            
            //Screw posts
            if(!holes)
                linear_extrude(height=inner_h)
                    difference()
                    {
                        holes_2d(screw_head_d);
                        holes_2d(screw_d);
                    }

            //Rim shell
            translate([0,0,(inner_h-lip_h)/2])
                if(outer_lip)
                    wall_3d(inner_size+[wall_thickness+lip_wiggle,wall_thickness+lip_wiggle,0],lip_h,(wall_thickness-lip_wiggle)/2);
                else
                    wall_3d(inner_size,lip_h,(wall_thickness-lip_wiggle)/2);
        }
        motors_3d();
    }
}

//Side A
shell_3d(inner_size,walls,true,floor_h,inner_h,lip_h,true);

//Side B
translate([inner_size.x+walls*2+1,0,0])
////translate([0,0,floor_h*2+inner_h])
////    rotate([180,0,0])
        shell_3d(inner_size,walls,false,floor_h,inner_h,lip_h,false);