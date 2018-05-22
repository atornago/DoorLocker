
//> fare i buchi dello shaft un poco più larghi
//> fare spazio per le viti 
//> abbassare di un poco la parte che sostiene il bastone a X



// ===================================================================================================
// New door locker project
// ===================================================================================================
fudge = 0.2;
$fn = 160;

use <Gear.scad>
use <Spiral.scad>


// general parameters ================================================================================
ColorBase      = "DarkKhaki";
ColorGears     = "OliveDrab";
ColorServo     = "SteelBlue";
Tolerance      =  0.20; // general tolerance


// door plate parameters =============================================================================
// this is the plate fixed to the door with 4 screws
dp_IntDiam      = 57.2; // internal diameter, equal to the phisical object diameter
dp_ringsize     = 20;   // delta between internal and external diameter
dp_zsize        = 3;    // elevation of the plate to fix to the door
dp_LeafDiam     = 15;   // diameter of the 4 leafs used to screw the plate to the door
dp_holdiameter  = 3;    // diameter of thehole in the leafs
dp_ExtDiam      = dp_IntDiam+dp_ringsize;  // calculated


// door plate cover parameters =======================================================================
// this is the cover on top of the plate fixed to the door
pc_zsize       = 6.2-dp_zsize;      // Z-Elevation of the cover starting from the base of the plate
pc_zthick      = 3;                 // thickness of the arc which connects the keyring to the base
pc_keyringsize = 4;                 // thickness of key ring 


// phisical Key parameterrs =========================================================================
KeyDiam         = 8.54;     // diameter of the Key, of the real object
keyHThick       = 1.9;      // thickness of phisical key head
keyHWidth       = 25.50;    // width of phisical key head
keyHHeight      = 23.53;    // height of phisical key head 
keyZThickt      = 6.5;      // Z-elevation of the ring who connect to the gear
keyDegClose     = 55;       // rotation degrees for close position
keyDegOpen      = 165;      // rotation degrees for open position
keyZOut         = 12;       // part of the key tube that exits from the hole
keyZOutOverlap  = 2;        // intersection between key body and key tube

// gear parameterrs =================================================================================
gerZsize       = 5.5;               // Z-elevation of the gear
gerDiam        = 40*1.06;           // gear diameter, calculated magic number *** not change ***
gerMidZP       = dp_zsize+pc_zthick+keyZThickt+gerZsize; // Z-elevation of middle point of the gear


// spiral parameters ================================================================================
sprBaseHeight  = 3.5;                  // support base of the spiral height
sprHoleDiam    = 4.73;               // spiral hole diameter
sprRay         = 9.93/2;             // radius of the LEGO spiral
sprBaseWidth   = sprRay*1.5+0.7;           // support base of the spiral width
sprBaseZElev   = sprRay*2+4;       // z-elevation of base of spiral
sprLenght      = 15.68;              // lenght of the spiral worm
sprExtraSpace  = 0.4;                 // y axix extra space to allow grip between gear and spiral
 
    
// servo official dimensions & parameters ===========================================================
srvWidth       = 23.20; // width of servo
srvHeight      = 11.80; // height of servo
srvZelev       = 23.31; // zextrusion of servo excluding gears cylinder
srvFullWidth   = 32.69; // with of servo including leafs
srvLeafZ       =  2.22; // zextrusion of leafs
srvLeafPosZ    = 16.30; // position from ground of leaf used to fix servo to a support
srvRotrZ       =  3.90; // zextrusion of cylinder carrying gears on top of servo
srvGearDiam    =  4.80; // diameter of servo gear
srvGearZ       =  2.60; // zextrusion of servo gear


// servo shaft parameters ===========================================================================
shfZBase       = 2;     // z-elevation, thickness of the base of the shaft
shfZHole       = 3;     // z-elevation of the shaft hole
shfDiam        = sprHoleDiam+5;   // diameter of the shaft
shfLeafDiam    = 17;    // diameter of the shaft leafs 
shfleafWidth   = 5.5;     // width of the shaft leafs
shfHoleDiam    = 2;   // diameter of the hole on shaft leafs
shfHoleDist    = 12.00;  // distance between opposite holes, on the shaft mount


// internal box parameters ==========================================================================

isDoorOpen = false;

main(
        adjust          = 0,
        prtPlate        = 0,
        prtCover        = 0,
        prtServoBase    = 0,
        prtServo        = 0,
        prtSpiralBase   = 0,
        prtSpiral       = 0, prtSpiralMounted = 0,
        prtGear         = 0, prtKeyHole = 0,
        prtKey          = 0,
        prtServoShaft   = 1,
        prtSensor       = 0, clickStatus=false,
        prtInternalBox  = 0,
        prtArduino      = 0
    );


//==================================================================================================
//==================================================================================================
//==================================================================================================
//==================================================================================================


module main(adjust=0,prtPlate=0,prtCover=0,prtServoBase=0,prtServo=0,prtSpiralBase=0,prtSpiral=0,prtSpiralMounted=0, prtGear=0,prtKeyHole=0,prtKey=0,prtServoShaft=0,prtSensor=0,clickStatus=false, prtInternalBox=0,prtArduino=0) {

    color(ColorBase,1) {
        
        if(prtPlate)         
        doorplate(  ExtDiam=dp_ExtDiam,             // external diameter of the plate
                    IntDiam=dp_IntDiam,             // internal diameter of the plate
                    ZSize=dp_zsize,                 // Z-Elevation of the plate
                    LeafDiam=dp_LeafDiam,           // Diameter of the 4 leaf with srewholes
                    LeafHoDiam=dp_holdiameter       // Diameter of the holes in the leafs
                    );     

        if(prtCover)
        translate([0,0,adjust ? dp_zsize : 0])       
        platecover( ZSize=pc_zsize,                 // Z-Elevationof the cover,starting from ground
                    ZThick=pc_zthick,               // Z-Thickness of the cover
                    WThick =pc_keyringsize,         // Key ring width size
                    ExtDiam=dp_ExtDiam,             // external diameter of the containing plate
                    IntDiam=dp_IntDiam,             // internal diameter of the containing plate
                    KeyDiam=KeyDiam+0.6      // diameter of the key + some  so sure key turns
                    );            
    }
 
        color(ColorGears,1) {
            difference() {
                if(prtGear) {
                    rotate([0,0,90+(isDoorOpen? keyDegOpen : keyDegClose)])
                    translate([0,0,adjust ? dp_zsize+pc_zsize+pc_zthick : 0])
                    rotate([0,0,adjust ? 7 : 0])
                    keygear(ZGearThick=gerZsize,     // Z-Elevation of the gear
                            ZKeyThick=keyZThickt,    // Z-Elevation of the key ring holder 
                            WThick =pc_keyringsize,  // Key ring width size
                            KeyDiam=KeyDiam+0.2      // diameter of the key + some  to make sure key hold tight
                            );
                }

                if(prtKeyHole) {
                    translate([0,0,-1.5]) // increased for tolerance issue
                    adjustedkey(adjust,keyhole=1);
                }        
            }
        }   

        if(prtSpiralBase || prtSpiral)
            translate([0,adjust ? gerDiam/2+sprRay/2+sprExtraSpace : 0,adjust ? -sprRay+gerMidZP : 0])
            keyspiral(prtSpiral,prtSpiralBase,prtSpiralMounted);

    // extra space added X dimension to accomodate connector
    if(prtServoBase || prtServo || prtServoShaft)
    translate([adjust ? -srvZelev-srvRotrZ-srvGearZ-sprLenght/2-sprBaseHeight-shfZHole-shfZBase-1.9 : 0,adjust ? gerDiam/2+sprRay/2+sprExtraSpace+5.75 : 0, adjust ? gerMidZP : 0]) 
    rotate([adjust ? 90 : 0, 0, adjust ? 90 : 0])
    servo(prtServo,prtServoBase,prtServoShaft);
    
    if(prtKey) 
        adjustedkey(adjust);
    
    
    if(prtSensor)
        color("PaleTurquoise",1)
        rotate([0,0,adjust ? -90 : 0])
        translate([0,adjust? -25: 0,adjust ? dp_zsize+pc_zsize+pc_zthick: 0])
        sensor(clickStatus);
    
    if(prtInternalBox) {
        color("Lavender",.8)
        internalbox();
    } 
   
}          


module adjustedkey(adjust=1,keyhole=0) {
    rotate([0,0,adjust? 45+(isDoorOpen? keyDegOpen : keyDegClose) : 0])
    translate([0,0,adjust? dp_zsize+pc_zsize:0])
    key(keyhole);
}

module arduino() {
    translate([0,0,1.3/2]) {
        color("Teal",1) cube([69,53,1.3],center=true);
        translate([-34,8,5]) color("Silver",1) cube([16,11,10],center=true);
        translate([-32,-19,5]) color("Black",1) cube([14,8,10],center=true);
    }
}


module internalbox() {
    inbExtraH = 30;
    inbWidth  = dp_ExtDiam+dp_LeafDiam/2;
    inbHeight = dp_ExtDiam+dp_LeafDiam/2+inbExtraH;
    inbzElev  = 45;
    inbThick  = 3;
    
    echo(inbHeight);
    
    tmpDiam = 10;
    rotate([0,0,45])
    translate([0,inbExtraH/2,inbzElev/2])
    difference() { 
        minkowski() {
            cube([inbWidth-tmpDiam,inbHeight-tmpDiam,inbzElev],center=true);
            cylinder(h=1,d=tmpDiam,center=true);
        }
    
        translate([0,0,-inbThick])
        minkowski() {
            cube([inbWidth-tmpDiam-inbThick*2,inbHeight-tmpDiam-inbThick*2,inbzElev-inbThick],center=true);
            cylinder(h=1,d=tmpDiam,center=true);
        }
    }
}


module sensor(clickStatus=false) {
    snsWidth   = 20;
    snsHeight  = 10;
    snsZElev   =  6;
    snsBarLen  = 31;
    sbsBarWid  = 3.7;
    
    translate([0,0,snsZElev/2]) {
        cube([snsWidth,snsHeight,snsZElev],center=true);
        translate([-snsWidth/2,0,0])
        rotate([0,0,clickStatus?7:15])
        translate([snsBarLen/2,snsHeight/2,0])
        rotate([90,0,0]) cube([snsBarLen,sbsBarWid,0.2],center=true);
    }
}



module servo(prtServo=1,prtServoBase=1,prtServoShaft=1) { 
   difference() {
        union() {
            if(prtServo)
            color(ColorServo,1) { // Servo FS90R image
               translate([0,0,srvZelev/2]) cube([srvZelev,srvHeight,srvZelev], center=true);
               translate([0,0,srvLeafPosZ+srvLeafZ/2]) cube([srvFullWidth,srvHeight,srvLeafZ], center=true);
               translate([-srvWidth/2+srvHeight/2,0,srvZelev+srvRotrZ/2]) {
                    cylinder(h=srvRotrZ,d=srvHeight,center=true);
                    translate([srvHeight/2+1,0,0]) cylinder(h=srvRotrZ,d=4,center=true);
                    translate([0,0,srvRotrZ/2+srvGearZ/2]) cylinder(h=srvGearZ,d=srvGearDiam,center=true);
                }
            }
    
            if(prtServoBase) 
            color(ColorBase,1) { 
                // base of the servo holder
                tmpbasethick = pc_zthick+4;
                translate([0,-tmpbasethick-srvHeight/2,0])
                rotate([90,0,180])
                linear_extrude(height=tmpbasethick)
                polygon([[-srvFullWidth/2,0],
                         [-srvFullWidth/2,srvZelev],
                         [0,srvZelev+srvRotrZ],
                         [srvWidth/2,srvZelev+srvRotrZ-1.3], // added -1.3 to manually adjust size
                         [srvFullWidth/2+6,(srvZelev+srvRotrZ)/2],
                         [srvFullWidth/2,0]]);
                
                //flanks of the servo holder
                flanksubtr = 7;
                flankzelev = srvLeafPosZ - flanksubtr;
                translate([(srvFullWidth+srvWidth)/4+Tolerance/2,0,flanksubtr+flankzelev/2]) 
                    cube([(srvFullWidth-srvWidth)/2-Tolerance,srvHeight,flankzelev],center=true);
                translate([-(srvFullWidth+srvWidth)/4-Tolerance/2,0,flanksubtr+flankzelev/2]) 
                    cube([(srvFullWidth-srvWidth)/2-Tolerance,srvHeight,flankzelev],center=true);
            }
        }
    
        if(prtServo|| prtServoBase) {
            // subtract holes and corner of the base
            translate([((srvFullWidth-srvWidth)/4+srvWidth/2),0,srvLeafPosZ]) 
                cylinder(h=srvLeafZ+6,d=2,center=true);
            translate([-((srvFullWidth-srvWidth)/4+srvWidth/2),0,srvLeafPosZ]) 
                cylinder(h=srvLeafZ+6,d=2,center=true);  
        }
    }    
   
    // shaft of the servo 
    if(prtServoShaft==1) {
        translate([prtServo?-srvHeight/2:0,0,prtServo?(shfZBase+shfZHole)/2+srvZelev+srvRotrZ+1.7+2.3:0]) {
          % translate([0,0,-shfZBase-1.3]) cylinder(h=1.56,d=10,center=true);
            
            difference() {
               union() { 
                   translate([0,0,-shfZHole/2])
                   difference() {
                        union() {
                            cube([shfleafWidth,shfLeafDiam-shfleafWidth,shfZBase],center=true);
                            translate([0,-shfleafWidth,0]) cylinder(h=shfZBase,d=shfleafWidth,center=true);
                            translate([0,shfleafWidth,0]) cylinder(h=shfZBase,d=shfleafWidth,center=true);
                            cube([shfLeafDiam-shfleafWidth,shfleafWidth,shfZBase],center=true);
                            translate([-shfleafWidth,0,0]) cylinder(h=shfZBase,d=shfleafWidth,center=true);
                            translate([shfleafWidth,0,0]) cylinder(h=shfZBase,d=shfleafWidth,center=true);

                        }
                        for(i=[1,-1]) {
                            translate([i*shfHoleDist/2,0,0]) cylinder(h=shfZBase+fudge,d=shfHoleDiam,center=true);
                            translate([0,i*shfHoleDist/2,0]) cylinder(h=shfZBase+fudge,d=shfHoleDiam,center=true);
                        }
                    }
                    cylinder(h=shfZBase+shfZHole-0.5,d=shfDiam,center=true);
                }
                
                // subtract the cross section
                for(i=[0:1]) rotate([0,0,90*i]) cube([4.71+Tolerance,1.87+Tolerance,30],center=true);
                    
                // subtract a little cylinder in order to accomodate the screw used to mount this to the servo
                translate([0,0,-0.4-shfZBase]) cylinder(h=2,d=5.5,center=true);

                translate([shfHoleDist/2+0.6,0,shfZBase]) cylinder(h=5,d=shfHoleDiam+3,center=true);
                translate([-shfHoleDist/2-0.6,0,shfZBase]) cylinder(h=5,d=shfHoleDiam+3,center=true);
                translate([0,shfHoleDist/2+0.6,shfZBase]) cylinder(h=5,d=shfHoleDiam+3,center=true);
                translate([0,-shfHoleDist/2-0.6,shfZBase]) cylinder(h=5,d=shfHoleDiam+3,center=true);
            }
        }
    }
}


module key(keyhole=0) { // Key representation, the real object
    translate([0,0,keyZOut/2]) {
        color("LightSlateGray",0.8) {
            w = keyHWidth + Tolerance;
            h = keyHHeight + Tolerance;
            z = keyHThick + Tolerance;
            
           cylinder(h=keyZOut,d=KeyDiam+Tolerance,center=true);
           translate([0,0,h/2+keyZOut/2-keyZOutOverlap])
           cube([w,z,h],center=true);
        }
        // key cylinder inside the hole
        translate([0,0,-16]) color("LightGrey",0.8) cylinder(h=20+(keyhole?50:0),d=KeyDiam+Tolerance,center=true);
    }
}

            
module keyspiral(prtSpiral=1,prtSpiralBase=1,mounted=1) {
    
    if(prtSpiral) {
         
      // test cylinder to make sure the sprRay parameter is correct
      // translate([0,0,sprRay]) rotate([0,90,0]) cylinder(h=sprLenght,d=sprRay*2,center=true);
        
        translate([mounted==1?-sprLenght/2:0,0,mounted==1?sprRay:0])
        rotate([0,mounted==1?90:0,0])
        color(ColorGears,1)
        difference() {
            translate([mounted==1?0:-1,0,0]) {
                spiral(modul=1, gangzahl=2, laenge=sprLenght, bohrung=0, pangle=15, lead_angle=14,mounted);
                r = 1*2/(2*sin(10));	
                //cylinder(h=70,d=sprHoleDiam,$fn=6,center=true); // test cylinder to check alignment
            }
            if(mounted==0) {
                for(i=[-1,1]) {
                    translate([0,i*(2+sprRay),0])
                    rotate([90,0,90])
                    cylinder(h=70,d=sprHoleDiam+Tolerance,$fn=6,center=true);
                }
            }
        }
    }
    
    // draw base of the spiral
    color(ColorBase)
    if(prtSpiralBase) {
        difference() {
            union() {
                for(i=[-1,1])
                translate([i*(sprBaseHeight/2+sprLenght/2+Tolerance),0,0])
                translate([-sprBaseHeight/2,-sprBaseWidth/2,-(sprBaseZElev-sprRay*2)]) 
                rotate([90,0,90]) 
                linear_extrude(height=sprBaseHeight) 
                polygon([
                    [0,0],
                    [0,sprBaseZElev],
                    [sprBaseWidth,sprBaseZElev],
                    [sprBaseWidth*1.4,0],
                    [0,0]
                ]);
            }
            translate([0,0,sprRay]) rotate([0,90,0]) cylinder(h=30,d=sprHoleDiam+Tolerance,center=true);
        }
    }
}


module keygear(ZGearThick, ZKeyThick, WThick,KeyDiam) {
    // draw th key gear with a ring and holes to hold the key
    // gear(modul, zahnzahl, breite, bohrung, pressangle, helixangle, optimiert);
    translate([0,0,ZKeyThick]) gear(1, 40, ZGearThick, 0, 20, -5, 0);
 
    // draw the ring above the gear
    translate([0,0,ZKeyThick/2]) 
    difference() {
        cylinder(h=ZKeyThick,d=KeyDiam+WThick*2,center=true);
        cylinder(h=ZKeyThick+fudge,d=KeyDiam,center=true);
    }
    
    // draw the block to activate the rotation sensor
    actZElev = 5;
    actWidth = 12;
    rotate([0,0,60])
    translate([0,-actWidth/2-KeyDiam/2-2,-actZElev/2+ZKeyThick])
    cube([2,actWidth,actZElev],center=true);
    
    
}



module platecover(ZSize, ZThick, KThick, ExtDiam, IntDiam, KeyDiam) {
    // This is the cover that is printed on top of the plate screwed to the door
    //
    // draw the small arc on top of the plate, 
    rotR = 134;
    arcR = 150;
    
    rotate([0,0,rotR]) linear_extrude(ZSize+ZThick) arc(IntDiam/2,(ExtDiam-IntDiam)/2,arcR);
    
    translate([0,0,ZSize]) {
        // draw key holder connected to the arc above 
        rotate([0,0,rotR]) linear_extrude(ZThick) arc(KeyDiam/2,(ExtDiam-KeyDiam)/2,arcR);

        // draw the ring
        translate([0,0,ZThick/2]) difference() {
           cylinder(h=ZThick,d=KeyDiam+WThick*2,center=true);
           cylinder(h=ZThick+fudge,d=KeyDiam,center=true);
        }
    }   
}



module doorplate(ExtDiam, IntDiam, ZSize, LeafDiam, LeafHoDiam) {
    // this is the plate cover screwed to the door
    //
    // create the ring
    translate([0,0,ZSize/2]) {
        difference () {
            cylinder(ZSize,d=ExtDiam,center=true);
            cylinder(ZSize+fudge,d=IntDiam,center=true);
        }
        
        // create the 4 leafs with the holes to screw the plate to the door
        tmp = ExtDiam/2+1.3;
       
        for(i=[0:3]) {
            translate([((i==0?1:0)+(i==1?-1:0))*tmp,((i==2?1:0) + (i==3?-1:0))*tmp,0]) 
               rotate([0,0,(i==1?180:0) + (i==2?90:0) + (i==3?270:0)]) 
                    difference() {
                        union(){
                            translate([LeafDiam/4,0,0]) cylinder(ZSize,d=LeafDiam,center=true);
                            translate([-LeafDiam/4,0,0]) cube([LeafDiam,LeafDiam,ZSize],center=true);
                        }
                        translate([LeafDiam/4,0,0]) cylinder(ZSize+fudge,d=LeafHoDiam,center=true);
                    }
        }   
    }
}








module support(Thick=3,XWidth=12,YWidth=12,ZElev=40,Base=true,Top=true,XExtend=1,YExtend=1) {
    cube([Thick,YWidth,ZElev],center=true);
    cube([XWidth,Thick,ZElev],center=true);
    if(Top) translate([0,0,ZElev/2-Thick/2]) cube([XWidth*XExtend,YWidth*YExtend,Thick],center=true);
    if(Base) translate([0,0,-ZElev/2+Thick/2]) cube([XWidth*XExtend,YWidth*YExtend,Thick],center=true);
}

module gearing() {
    translate([0,0,20]) {
        translate([-9,25,2.5]) rotate([0,90,0]) spiral(1, 2, 16, 4, 20, 10, 1);
        difference() {
            rotate([0,0,0]) gear(1, 40, gerZsize, 0, 20, -15, 0);
            translate([0,0,gerZsize/2]) cube([key_width,key_lenght,gerZsize+fudge],center=true);
            translate([0,0,gerZsize/2]) cylinder(h=gerZsize+fudge,d=key_diamt,center=true);
        }   
    }
}


        




module arc(radius, thick, angle){
	intersection(){
		union(){
			rights = floor(angle/90);
			remain = angle-rights*90;
			if(angle > 90){
				for(i = [0:rights-1]){
					rotate(i*90-(rights-1)*90/2){
						polygon([[0, 0], [radius+thick, (radius+thick)*tan(90/2)], [radius+thick, -(radius+thick)*tan(90/2)]]);
					}
				}
				rotate(-(rights)*90/2)
					polygon([[0, 0], [radius+thick, 0], [radius+thick, -(radius+thick)*tan(remain/2)]]);
				rotate((rights)*90/2)
					polygon([[0, 0], [radius+thick, (radius+thick)*tan(remain/2)], [radius+thick, 0]]);
			}else{
				polygon([[0, 0], [radius+thick, (radius+thick)*tan(angle/2)], [radius+thick, -(radius+thick)*tan(angle/2)]]);
			}
		}
		difference(){
			circle(radius+thick);
			circle(radius);
		}
	}
}
