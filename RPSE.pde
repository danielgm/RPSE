/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/113734*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/*
Regular polygon subdivision explorer
An explorer of combinations of different subdivision methods applied to a regular polygon as initial seed.
Enjoy!
Ale González, 2013
*/



import java.util.LinkedList;


int w = 750,
    h = 750,
    cx = w/2,
    cy = h/2,
    r = 350,
    sides= 4,
    bg = #0090ff,
    st = 0x50ffffff;

LinkedList <PVector[]> pols;
Subdivider _;

void setup ()
{
    size(w, h);
    background(bg);
    stroke(st); 
    smooth();
    noFill();
    _ = new Subdivider(); 
    reset();
}

void reset()
{
    //Create an empty queue (backed in a singly linked list) of polygons
    pols = new LinkedList<PVector[]>();
    //Add an initial seed
    pols.push(Polygon.createPolygon(sides, cx, cy, r, HALF_PI));
}

void draw () 
{
    background(bg);
    //Display all polygons in the queue as shapes
    for (PVector[] pol : pols) {
        beginShape();
          for (int i = 0; i < pol.length; i++) vertex(pol[i].x, pol[i].y);
        endShape(CLOSE);
    } 
}

void keyPressed()
{
    //Keys 1-5 apply different subdivision methods to all the elements of the queue
    switch (key) {
        case ('1'): 
            _.SPARSE_BARYCENTRIC.division(pols);
            break;
        case ('2'): 
            _.MIRRORED.division(pols);
            break;
        case ('3'): 
            _.DENSE_BARYCENTRIC.division(pols);
            break;
        case ('4'): 
            _.STARRED.division(pols);
            break;
        case ('5'): 
            _.SUTCLIFFE.division(pols);
            break;
    }    
          
    //Left and arrow keys reset the queue changing the number of sides of the seed    
    if (keyCode==LEFT && sides>3) {
        sides--;
        reset();
    } else if (keyCode==RIGHT  && sides<12) {
        sides++;
        reset(); 
    } 
}




