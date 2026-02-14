// V 1.2 Correction / hint from molotok3D, some minor fixes
// V 1.1- added opening helper and an optional separating wall
$fn=300;
wi=100;	// inner width, length & heigth
li=35;
h=22;
th=2;	// wall thickness
r=3;	// radius of rounded corners
opening_help=true;	// make a gap to ease opening of the cover, f.ex.
		// with a coin - girls are afraid of their finger nails ;-)
separator=0;	// generate a separating wall inside - set to 0 for none

e=0.01;
ri=(r>th)?r-th:e;	// needed for the cover - needs to be larger than 0 for proper results
l=li-2*r;
w=wi-2*r;


// usb
wall = th;
base = th;
usb_width = 9;
usb_height = 3.3;

esp32_length = 21;
esp32_width = 17.5;
esp32_height = 3.5;
esp32_standoff = 5;   
clearance = 0.2;
esp32_x = wall + clearance + esp32_length/2;

module box(){
	difference(){
		translate([0,0,-th])hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
				translate(i)cylinder(r=r+th,h=h+th,$fn=8*r);
			}
		}
		hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2,],[w/2,-l/2],[w/2,l/2]]){
				translate(i)cylinder(r=r,h=h,$fn=8*r);
			}
		}
		translate([-w/2,l/2+r,h-2])rotate([0,90,0])cylinder(d=1.2,h=w,$fn=12);
		translate([-w/2,-l/2-r,h-2])rotate([0,90,0])cylinder(d=1.2,h=w,$fn=12);
		translate([w/2+r,l/2,h-2])rotate([90,0,0])cylinder(d=1.2,h=l,$fn=12);
		translate([-w/2-r,l/2,h-2])rotate([90,0,0])cylinder(d=1.2,h=l,$fn=12);

		// if you need some adjustment for the opening helper size or position,
		// this is the right place
		if (opening_help)translate([w/2-10,l/2+13.5,h-1.8])cylinder(d=20,h=10,$fn=32);
	}
	if (separator>0){
		translate([separator-wi/2,-li/2-e,-e])difference(){
			cube([th,li+2*e,h]);
			translate([-e,-e,h-3])cube([th+2*e,2*th+2+2*e,5]);
			translate([-e,e+li-2*th-2,h-3])cube([th+2+2*e,2*th+2+2*e,5]);
		}
	}
}

module cover(){
	translate([0,0,-th])hull(){
		for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
			translate(i)cylinder(r=r+th,h=th,$fn=8*r);
		}
	}
	difference(){
		translate([0,0,-th])hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
				translate(i)cylinder(r=r,h=th+3,$fn=8*r);
			}
		}
		hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
				if (r>th){
					translate(i)cylinder(r=r-th,h=3,$fn=8*r);
				}else{
					translate(i)cylinder(r=e,h=3,$fn=8*r);
				}
			}
		}
	}
	translate([-w/2+1,l/2+r-0.2,2])rotate([0,90,0])cylinder(d=0.6,h=w-2,$fn=12);
	translate([-w/2+1,-l/2-r+0.2,2])rotate([0,90,0])cylinder(d=0.6,h=w-2,$fn=12);
	translate([w/2+r-0.2,l/2-1,2])rotate([90,0,0])cylinder(d=0.6,h=l-2,$fn=12);
	translate([-w/2-r+0.2,l/2-1,2])rotate([90,0,0])cylinder(d=0.6,h=l-2,$fn=12);

}

module usb_cutout() {
    // Snug oval USB-C cutout
    // TODO: fix measurements
    translate([0 , esp32_width/2 + wall/2, esp32_standoff + base]) rotate([0, 0, 90]) translate([usb_height/2 , 0, usb_height/2])hull() {
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
       translate([-1, wall/2 - clearance, -1 ])
       #cube([esp32_length+2, esp32_width + 2*clearance, 12]);
     }
     
     
     for (posx = [1:2]) {
       for (posy = [1:2]){
        echo("posx = ", posx, "posy = ", posy);
         translate([wall/2 + (posx % 2) * (esp32_length - 4), wall + (posy % 2) * (esp32_width - wall) , 0])
             cylinder(r=post_r, h=esp32_standoff+1);
      }
     }
    }
    translate([esp32_length, 0, base])
    difference(){
      cube([2, esp32_width+wall, 10]);
      translate([0, 4, 0 ])
      cube([2, esp32_width -4, 10]);
    }
}




 difference(){
  translate([wi/2 + th, li/2 + th, 0])  box();
    translate([0, 5, base])
    usb_cutout();
 }
 translate([wall, 11, 0])
 esp32_box();

    
    