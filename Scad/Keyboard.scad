// ==========================================================================
// 3x3 Keyboard module
// ==========================================================================
//
// pushbutton Height = 12; 
// 

layout3x3   = "123456789";
layout1x2   = "AC";

debug       = false;

kbDepth     =  4.0;             // vertical depth of the keyboard holder
kbStepp     =  4.0;             // value subtracted to width and height to define the base

pltHoleDist  = 2.55;             // distance between two holes in the circuit plate
pltHoleDiam  = 2.0;             // diameter of the hole used to attach the circuit plate

btWidth     =  7.9;             // width of button
btHeight    =  7.9;             // height of button
btDepth     =  8.0;             // vertical depth of button
btBase      =  0.6;             // value added to width and height to form the base
btBaseDepth =  1.5;             // vertical depth of the base
btHole      =  3.6;             // hole in the button to fit the pushbutton command
btTolerance =  0.6;             // extra space used to make the button holes

// this is the 4 legs vertical depth [12 is the depth of REAL push button]
btSupDepth  =  12.00-(btDepth-2*btBaseDepth);     
btSupThick  =  4.0;            // 4 legs thickness

ledHoleDiam =  5.2;            // diameter of led hole


// VARIABLES USED TO SET DIMENSION OF THE PLATE
pinCols = 14; // number of horizontal holes - 1 in the breadboard = 14 for 3x3 keyboard 
pinRows = 10; // number of vertical holtes - 1 in the breadboard  = 17 for 3x3 keyboard, 10 for 1x2

pltHolHDist  = pltHoleDist*pinCols;  // horizontal size of the circuit plate, using hole distance
pltHolVDist  = pltHoleDist*pinRows;  // vertical size of the circuit plate, using hole distance


XT =  pltHoleDist*0;
YT = -pltHoleDist*pinRows/2+pltHoleDist*7; // use 11 for 3x3 keyboard, 9 for 1x2 keyboard
ZT = -btBaseDepth*1.5;

keyboard(pinCols,pinRows,2,1,layout1x2,false);
//buttons(1,2,layout1x2);



module keyboard(pinCols,pinRows,buttCols,buttRows,keysLayout, drawButtons) {
    keyboarddesign(pltHoleDist*(pinCols+5),pltHoleDist*(pinRows+5),buttCols,buttRows,keysLayout);
    translate([XT,YT,ZT-2]) 
    if(drawButtons) buttons(buttRows,buttCols,keysLayout);
   
    if(debug) {
    translate([0,-21.5,0]) cube([35,1,1],center=true);
    translate([-18,0,0]) cube([1,pltHolVDist,1],center=true);
    }
}



module keyboarddesign(kbWidth,kbHeight,buttCols,buttRows,keysLayout) {
    difference() {
        union() {
            linear_extrude(height=kbDepth/2)
            square([kbWidth,kbHeight],center=true);
        
            translate([0,0,-kbDepth/2])
            linear_extrude(height=kbDepth/2)
            square([kbWidth-kbStepp,kbHeight-kbStepp],center=true);
        }    
                
        // holes for the buttons
        translate([XT,YT,ZT]) 
        buttons(buttRows,buttCols,keysLayout, false);
        
        //holes for the two leds
        for(i=[1,-1]) 
            translate([i*pltHoleDist*2,-pltHoleDist*2,0]) // use 6 for 3x3 keyboard, 2 for 1x2 keyboard
            cylinder(h=10,d=ledHoleDiam,center=true,$fn=100);
    }    
   
    // for testing purpose check alignment using a visual guide 
    if(debug) translate([XT,YT,ZT]) 
    buttons(buttRows,buttCols,keysLayout, false,true);
    
    // cylindric support for fixing screws 
    for(i=[-1,1]) {
        for(j=[-1,1]) {
            translate([i*pltHolHDist/2,j*pltHolVDist/2,-kbDepth/2-btSupDepth/2])
            difference() { 
                cylinder(h=btSupDepth,d=btSupThick+pltHoleDiam,center=true,$fn=100);
                cylinder(h=btSupDepth+1,d=pltHoleDiam,center=true,$fn=100);
            }
        }
    }
    
    // guides for the holes FOR TEST PURPOSE
    if(debug) 
    for(i=[0:14],j=[0:17]) 
        translate([pltHolHDist/2-i*pltHoleDist,pltHolVDist/2-j*pltHoleDist,0])
        cylinder(h=7,d=0.5,center=true,$fn=100);    
}




module buttons(rows, cols, symbols, drawBase=true,drawCenter=false) {
    btSpace = 4;
    // centers the buttons in the x,y axes
    translate([-pltHoleDist*btSpace*(cols-1)/2,pltHoleDist*btSpace*(rows-1)/2,0])
    for(i=[0:cols-1],j=[0:rows-1]) 
        // align button center with hole distance in the circuit plate
        translate([pltHoleDist*btSpace*i,-pltHoleDist*btSpace*j,0])
        button(symbols[((i+1)+j*3)-1],drawBase,drawCenter);
}


module button(Label,drawBase=true,drawCenter=false) {
    if(!drawCenter) {
        difference() {
            union() {
                if(drawBase) {
                // base of the button
                    linear_extrude(height=btBaseDepth)
                    square([btWidth+2*btBase,btHeight+2*btBase],center=true);
                }
                
                // body of the button
                // base+body elevation = btDepth
                linear_extrude(height=btDepth)
                square([btWidth+(drawBase?0:btTolerance),
                btHeight+(drawBase?0:btTolerance)],center=true);
            }
            
            if(drawBase) {
                // create the hole to hold the pushbutton
                // the hole elevation is btDepth - btBaseDepth
                translate([0,0,btDepth/2-btBaseDepth])
                cylinder(h=btDepth,d=btHole, center=true,$fn=100);
         
                // create the text on top of the button
                translate([0,-3.0,btDepth-1])
                linear_extrude(height=1.2)
                text(Label,size=6,bold=true,valign="cener",halign="center",font="Arial:style=bold");
            }    
        }
    }
    
    else {
        // for testing purpose create a cylinder on the middle
        translate([0,0,4]) cylinder(h=15,d=1,center=true,$fn=60);
    }
}

