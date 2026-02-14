// dia: 100;
// inner_height: 60;
// attachemnt_dia: 24;

$fn=200;

use <smooth-prim/smooth_prim.scad>



box();
translate([0,-h-2*wall-8,0])
lid();



usb_width = 9;
usb_height = 3.3;

esp32_length = 21;
esp32_width = 17.5;
esp32_height = 3.5;
esp32_standoff = 5;   // Height above floor for wire clearance



// tolerance
tol=0.1;

// Box
// wall thickness
wall=3.5;
// base thickness
base=3;
// top thickness
top=2;
// inner box width
w=210;
w_outer=w+2*wall;
w_center=w_outer/2;
// inner box length
h=105;
h_outer=h+2*wall;
h_center=h_outer/2;
// inner box depth 
d=20;
// outer corner radius
outer_r=6;
// inner corner radius
inner_r=4;
// top lip depth
lip=5;
// top lip thickness
lip_thickness=1.5;
// lid tolerance
lid_tol=0.15;

lid_height=20;

clearance = 0.2;
esp32_x = wall + clearance + esp32_length/2;

// Bolt posts
bolt_hole_r=1.6;
post_r=4.5;
post_inset=post_r-tol;
post_h=(h-2*post_inset)/2;
post_w=(w-2*post_inset)/2;
post_setback=lip;
// Counter sinks
nut_width=5.6;
nut_height=2.4;
bolt_head_r=3.15;
bolt_head_height=2.3;
bolt_length=d+base+top-bolt_head_height;
echo("Bolt length: ", bolt_length);

module box() {
    difference() {
        union() {
            difference() {
                union() {
                    SmoothXYCube([w+2*wall,h+2*wall,d+base], outer_r);
                    translate([wall-lip_thickness, wall-lip_thickness, d+base])
                    SmoothXYCube([w+2*lip_thickness, h+2*lip_thickness, lip], inner_r);
                }
                translate([wall, wall, base])
                SmoothXYCube([w,h,d+lip+tol], inner_r);
            }
            translate([w_center, h_center, 0])
            bolt_posts(post_r, d+base+lip);
        }
        translate([w_center, h_center, 0]) {
            //counter_sunk_holes(bolt_hole_r, d+base+lip,
             //                  "hex", nut_width, nut_height);
            box_post_setbacks();
        }
    usb_cutout();
    }
    translate([0, 120, 0])
    esp32_box();
}

module lid() {
    difference() {
        union() {
            difference() {
                SmoothXYCube([w+2*wall,h+2*wall,lip+lid_height], outer_r);
                translate([wall-lip_thickness-lid_tol, wall-lip_thickness-lid_tol,  lid_height])
                SmoothXYCube([w+2*lip_thickness+2*lid_tol,h+2+lip_thickness+2*lid_tol,lip+tol], inner_r);
                translate([wall, wall, base])
                 SmoothXYCube([w,h,lid_height], inner_r);
            }
            translate([w_center, h_center, 0])
            bolt_posts(post_r, lid_height);  //top+lip
        }
        translate([w_center, h_center, 0]) {
        counter_sunk_holes(bolt_hole_r, lid_height,
                           "circle", bolt_head_r, bolt_head_height);
        }
    }
}

module bolt_posts(radius, height)
{
    for(c = [[-1,1], [-1,-1], [1,1], [1,-1]]) {
        translate([c[0]*post_w, c[1]*post_h, 0])
        cylinder(r=radius,h=height);
    }
}

module counter_sunk_holes(radius, height, type, width, depth){
    for(c = [[-1,1], [-1,-1], [1,1], [1,-1]]) {
        translate([c[0]*post_w, c[1]*post_h, -tol])  
        union() {
            cylinder(r=radius,h=height+tol*2);
            if (type=="hex") {
                cylinder(r=width/2/0.866,h=depth, $fn=6);
            } else if (type=="circle") {
                cylinder(r=width,h=depth+tol);
            }
        }
    }
}

module box_post_setbacks() {
    for(c = [[-1,1], [-1,-1], [1,1], [1,-1]]) {
        translate([c[0]*post_w, c[1]*post_h, d+base])
        cylinder(r=post_r+2*tol,h=post_setback+tol);
    }
}


module usb_cutout() {
    // Snug oval USB-C cutout
    // TODO: fix measurements
    translate([0 , (h - usb_width)/2 - wall, esp32_standoff + base]) rotate([0, 0, 90]) translate([usb_height/2 , 0, usb_height/2])hull() {
        translate([0, 0, 0]) 
            rotate([90, 0, 0]) 
            cylinder(r=usb_height/2, h=wall + 2, center=false);
        translate([usb_width, 0, 0]) 
            rotate([90, 0, 0]) 
            cylinder(r=usb_height/2, h=wall + 2, center=false);
    }
}


module esp32_box(){
    post_r = 1.5;
    

    translate([0,0,base]){
     difference(){
       //cube([]);
       
       cube([esp32_length, esp32_width+wall, 10]);
       translate([-1, wall/2, -1])
       cube([esp32_length+2, esp32_width, 12]);
     }
     
     
     for (posx = [1:2]) {
       for (posy = [1:2]){
        echo("posx = ", posx, "posy = ", posy);
         translate([wall/2 + (posx % 2) * (esp32_length - 4), wall + (posy % 2) * (esp32_width - wall) , 0])
             cylinder(r=post_r, h=esp32_standoff);
      }
     }
    }
}
