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
    minSides = 3,
    maxSides = 12,
    sides= floor(random(minSides, maxSides)),
    bg = #0090ff,
    st = 0x50ffffff,
    jitter = 2;

LinkedList <Polygon> pols;
Subdivider _;
PGraphics graphics;
FastBlurrer blurrer;

color[] palette;

void setup ()
{
    size(w, h);
    background(bg);
    smooth();
    _ = new Subdivider(); 
    reset();
}

void reset()
{
    //Create an empty queue (backed in a singly linked list) of polygons
    pols = new LinkedList<Polygon>();
    //Add an initial seed
    pols.push(new Polygon(0, sides, cx, cy, r, HALF_PI));
    
    graphics = createGraphics(width, height);
    blurrer = new FastBlurrer(width, height, 5);
    
    palette = loadPalette("data/planetary.png");
    
    background(bg);
    redraw();
}

void step() {
    Subdivider.Divider d = _.dividers[floor(random(_.dividers.length))];
    d.division(pols);
    redraw();
}

void draw() 
{
  background(0);
  image(graphics, 0, 0);
}

void redraw() {
    graphics.loadPixels();
    blurrer.blur(graphics.pixels);
    graphics.updatePixels();
  
    //Display all polygons in the queue as shapes
    graphics.beginDraw();
    for (Polygon pol : pols) {
        graphics.noFill();
        color c = palette[pol.generation() % palette.length];
        graphics.stroke(c);
        graphics.strokeWeight(constrain(map(pol.generation(), 5, 0, 0.1, 3), 0, 12));
        graphics.beginShape();
          PVector[] vertices = pol.vertices();
          for (int i = 0; i < vertices.length; i++) {
            graphics.vertex(vertices[i].x + random(jitter) - jitter/2, vertices[i].y + random(jitter) - jitter/2);
          }
        graphics.endShape(CLOSE);
    }
    graphics.endDraw();
}

void keyPressed()
{
    //Keys 1-5 apply different subdivision methods to all the elements of the queue
    switch (key) {
        case ('1'): 
            _.SPARSE_BARYCENTRIC.division(pols);
            redraw();
            break;
        case ('2'): 
            _.MIRRORED.division(pols);
            redraw();
            break;
        case ('3'): 
            _.DENSE_BARYCENTRIC.division(pols);
            redraw();
            break;
        case ('4'): 
            _.STARRED.division(pols);
            redraw();
            break;
        case ('5'): 
            _.SUTCLIFFE.division(pols);
            redraw();
            break;
        case ('r'):
            saveFrame();
            break;
    }    
          
    //Left and arrow keys reset the queue changing the number of sides of the seed    
    if (keyCode==LEFT && sides>minSides) {
        sides--;
        reset();
    } else if (keyCode==RIGHT  && sides<maxSides) {
        sides++;
        reset(); 
    } else if (key == ' ') {
      sides = floor(random(minSides, maxSides));
      reset();
      while (pols.size() < 500 && random(1) < 0.95) {
        step();
      }
    }
}

color[] loadPalette(String paletteFilename) {
  PImage paletteImg = loadImage(paletteFilename);
  color[] palette = new color[paletteImg.width];
  paletteImg.loadPixels();
  for (int i = 0; i < paletteImg.width; i++) {
    palette[i] = paletteImg.pixels[i];
  }
  return palette;
}




