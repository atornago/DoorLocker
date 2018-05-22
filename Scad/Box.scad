// ================================================================
// PARAMETRIC BOX
// ================================================================

Tolerance = 0.1;
Width = 50;
Height = 30;
Depth = 10;
Thick = 4;
LeafHole =2;

//pbox(false,Width,Height,Depth,Thick,LeafHole);
//translate([0,0,Depth+10])
pcover(Width,Height,Thick);

module pbox(showCover=true, boxWidth, boxHeight, boxDepth, boxThick,boxLeafHole) {

    // the box itself =============================================
    difference() {
        linear_extrude(height=boxDepth) 
        difference() {
            minkowski() {
                polygon([ [-boxWidth/2+boxThick,-boxHeight/2+boxThick],
                          [-boxWidth/2+boxThick,boxHeight/2-boxThick],
                          [boxWidth/2-boxThick,boxHeight/2-boxThick],
                          [boxWidth/2-boxThick,-boxHeight/2+boxThick]
                    ]);
                circle(r=boxThick,$fn=100);
            }

            polygon([ [-boxWidth/2+boxThick,-boxHeight/2+boxThick],
                      [-boxWidth/2+boxThick,boxHeight/2-boxThick],
                      [boxWidth/2-boxThick,boxHeight/2-boxThick],
                      [boxWidth/2-boxThick,-boxHeight/2+boxThick]
               ]);
        }
    
        translate([0,0,boxDepth-boxThick/2])
        linear_extrude(height=boxThick/2)    
        polygon([ [-boxWidth/2+boxThick/2,-boxHeight/2+boxThick/2],
                      [-boxWidth/2+boxThick/2,boxHeight/2-boxThick/2],
                      [boxWidth/2-boxThick/2,boxHeight/2-boxThick/2],
                      [boxWidth/2-boxThick/2,-boxHeight/2+boxThick/2]
               ]);
        
    
        // creates the holes in the box to accomodate cover locks
        for(i=[-1,1]) { 
            translate([i*(boxWidth/2-Tolerance-boxThick/2),0,boxDepth-boxThick/2]) 
            rotate([0,0,i==-1?180:0])
            holder(boxHeight,boxThick,Tolerance);
        }   
    }
    // the screws holders part =====================================
    for(i=[-1,1]) {
        for(j=[-1,1]) {
            translate([i*boxWidth/3,j*(boxHeight/2-boxThick*2),0])
            rotate([0,0,j<0? 180 : 0])
            linear_extrude(height=boxThick/2)
            difference() {
                union() { 
                    circle(r=boxThick,$fn=100);
                    translate([-boxThick,0,0]) square([boxThick*2,boxThick]);
                }
                circle(d=boxLeafHole,$fn=100);
            }
        }
    }
    
    // the box cover =============================================
    if(showCover==true) 
        translate([0,0,boxDepth-boxThick/2])
        pcover(boxWidth, boxHeight, boxThick);
}

module pcover(boxWidth, boxHeight, boxThick) {
   linear_extrude(height=boxThick/2)    
   polygon([ [-boxWidth/2+boxThick/2+Tolerance,-boxHeight/2+boxThick/2+Tolerance],
                  [-boxWidth/2+boxThick/2+Tolerance,boxHeight/2-boxThick/2-Tolerance],
                  [boxWidth/2-boxThick/2-Tolerance,boxHeight/2-boxThick/2-Tolerance],
                  [boxWidth/2-boxThick/2-Tolerance,-boxHeight/2+boxThick/2+Tolerance]
           ]);
    
    for(i=[-1,1]) { 
        translate([i*(boxWidth/2-Tolerance-boxThick/2),0,0]) 
        rotate([0,0,i==-1?180:0])
        holder(boxHeight,boxThick);
    }   
}



module holder(boxHeight,boxThick,Tolerance=0) {
    L = (boxThick/4+Tolerance) * sin(25)/cos(25);
    
    translate([0,(boxHeight*.6+2*Tolerance)/2,0])
    rotate([90,0,0])
        linear_extrude(height=boxHeight*.6+2*Tolerance) 
        polygon([ [0,0],
                  [0,boxThick/4+Tolerance],
                  [L+Tolerance,boxThick/4+Tolerance]
            ]);
}
