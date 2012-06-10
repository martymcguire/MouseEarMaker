import toxi.processing.*;

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;

WETriangleMesh thing;
float thingScale;

boolean drawing = false;
Vec2D newEarCtr;

void setup() {
  size(700, 700);
  loadModel();
}

void draw() {
  background(51);
  // draw thing
  fill(160);
  noStroke();
  // iterate over all faces in thing. draw a poly for each.
  for(Face f : thing.faces) {
    Vec2D pt;
    beginShape();
    pt = modelToScreen(f.a.x, f.a.y); vertex(pt.x, pt.y);
    pt = modelToScreen(f.b.x, f.b.y); vertex(pt.x, pt.y);
    pt = modelToScreen(f.c.x, f.c.y); vertex(pt.x, pt.y);
    endShape(CLOSE);
  }

  // draw new mouse ear, if any is being drawn
  drawNewMouseEar();
}

void drawNewMouseEar() {
  if (drawing) {
    stroke(255, 0, 0);
    point(newEarCtr.x, newEarCtr.y);
    noStroke();
    fill(8, 134, 86, 128);
    float magx = newEarCtr.x - mouseX;
    float magy = newEarCtr.y - mouseY;
    float d = 2 * sqrt(sq(magx) + sq(magy));
    ellipse(newEarCtr.x, newEarCtr.y, d, d);
  }
}

void loadModel() {
  // get a file to work with.
  String loadPath = selectInput();  // Opens file chooser
  if (loadPath == null) {
    // If a file was not selected
    println("No file was selected...");
  } else {
    // If a file was selected, print path to file
    println(loadPath);
  }
  thing = new WETriangleMesh().addMesh(new STLReader().loadBinary(createInput(loadPath), "object", TriangleMesh.class));
  
  // properly orient and scale mesh (?)
  //thing.rotateX(HALF_PI);
  
  PlaneSelector sel = new PlaneSelector(thing, Plane.XY, Plane.Classifier.FRONT);
  sel.selectVertices();
  thing.removeVertices(sel.getSelection());
  AABB bounds = thing.getBoundingBox();
  Vec3D bmin = bounds.getMin();
  Vec3D bmax = bounds.getMax();
  float lenx = bmax.x - bmin.x;
  float leny = bmax.y - bmin.y;
  if(leny > lenx) {
    thingScale = height / leny;
  } else {
    thingScale = width / lenx;
  }
  thingScale *= 0.75; // margins are good
}

Vec2D modelToScreen(float x, float y) {
  Vec2D scoord = new Vec2D();
  scoord.x = (x * thingScale) + (width / 2);
  scoord.y = (y * thingScale) + (height / 2);
  return scoord;
}

void mousePressed() {
  drawing = true;
  newEarCtr = new Vec2D(mouseX, mouseY);
}

void mouseReleased(){
  drawing = false;
}
