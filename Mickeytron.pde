import toxi.processing.*;

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;

String loadPath;
String savePath;

WETriangleMesh thing;
float thingScale;
ArrayList ears = new ArrayList();

boolean drawing = false;
Vec2D newEarCtr;

boolean saving = false;

boolean[] keys = new boolean[526];

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

  // draw ears
  drawEars();

  // draw new mouse ear, if any is being drawn
  drawNewMouseEar();

  // are we done?
  if(saving && new File(savePath).exists()) {
     println("Saved!");
     exit();
  }
}

void drawEars() {
    fill(8, 134, 86, 192);
    for(Ear e : (ArrayList<Ear>) ears) {
        ellipse(e.x, e.y, e.r*2, e.r*2);
    }
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
  loadPath = selectInput();  // Opens file chooser
  if (loadPath == null) {
    // If a file was not selected
    println("No file was selected...");
  } else {
    // If a file was selected, print path to file
    println(loadPath);
  }
  thing = new WETriangleMesh().addMesh(new STLReader().loadBinary(createInput(loadPath), "object", TriangleMesh.class));
  
  // TODO: copy this WETriangleMesh so we can op on it at the end?
  
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

Vec2D screenToModel(float x, float y) {
  Vec2D mcoord = new Vec2D();
  mcoord.x = (x - (width / 2)) / thingScale;
  mcoord.y = (y - (height / 2)) / thingScale;
  return mcoord;
}

void mousePressed() {
  drawing = true;
  newEarCtr = new Vec2D(mouseX, mouseY);
}

void mouseReleased(){
  drawing = false;
  float magx = newEarCtr.x - mouseX;
  float magy = newEarCtr.y - mouseY;
  float r = sqrt(sq(magx) + sq(magy));
  ears.add(new Ear(newEarCtr.x, newEarCtr.y, r));
}

class Ear {
  float x;
  float y;
  float r;

  public Ear(float _x, float _y, float _r) {
    x = _x;
    y = _y;
    r = _r;
  }
}

boolean checkKey(int k)
{
  if (keys.length >= k) {
    return keys[k];
  }
  return false;
}

void keyPressed()
{
  keys[keyCode] = true;

  // ctrl-z / cmd-z = undo last ear
  if((checkKey(CONTROL) || checkKey(KeyEvent.VK_META)) && checkKey(KeyEvent.VK_Z)) {
    if(ears.size() > 0)
      ears.remove(ears.size() - 1);
  }

  // ctrl-s / cmd-s = save the file!
  if((checkKey(CONTROL) || checkKey(KeyEvent.VK_META)) && checkKey(KeyEvent.VK_S)) {
    saveAndQuit();
  }
}

void keyReleased()
{
  keys[keyCode] = false;
}

void saveAndQuit() {
  // save where?
  savePath = selectOutput("Save a .scad file...");  // Opens file chooser
  if (savePath == null) {
    // If a file was not selected
    println("No output file was selected...");
  } else {
    // If a file was selected, print path to folder
    println(savePath);

    // convert ears to model space
    ArrayList<Ear> final_ears = new ArrayList<Ear>();
    for(Ear e : (ArrayList<Ear>) ears) {
      Vec2D pt = screenToModel(e.x, e.y);
      final_ears.add(new Ear(pt.x, pt.y, (e.r / thingScale)));
    }

    writeOpenSCADFile(savePath + ".scad", loadPath, final_ears);
    generateSTLFromSCAD(savePath, savePath + ".scad");
  }
}

void writeOpenSCADFile(String savePath, String loadPath, ArrayList<Ear> final_ears) {
  PrintWriter outfile = createWriter(savePath);
  outfile.println("union() {");
  outfile.println("  import_stl(\"" + loadPath + "\");");
  outfile.println("  linear_extrude(height = 0.03) {");
  for(Ear ear : final_ears) {
     outfile.println("    translate([" + ear.x + ", " + ear.y + ",0]) circle(r = " + ear.r + ");");
  }
  outfile.println("  }");
  outfile.println("}");
  outfile.flush();
  outfile.close();
}

void generateSTLFromSCAD(String stlPath, String scadPath) {
    File scad_file = new File(scadPath);
    File stl_file = new File(stlPath);
    String[] exec = {"/usr/bin/open","/Applications/OpenSCAD.app","--args",
                     "-s",
                     stl_file.getAbsolutePath(),
                     scad_file.getAbsolutePath()
                     };

    if(stl_file.exists()){
      stl_file.delete();
    }
    saving = true;
    println("Rendering w/ OpenSCAD...");
    println(exec);
    exec(exec);
}
