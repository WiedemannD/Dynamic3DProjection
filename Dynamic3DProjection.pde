/*
  Dynamic3DProjection  
*/
import processing.opengl.*;
import deadpixel.keystone.*;
import SimpleOpenNI.*;
/*import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;*/
import controlP5.*;


// general variables
Config config;
int vWidth = 1024;
int vHeight = 768;
int mainFps = 300;
int worldWidth = 1000;
int worldHeight = worldWidth;
int worldDepth = worldWidth;

int threshold = 10; // needs testing


PFont font = createFont("monaspace", 20);

// flags
Boolean drawStats = true;
Boolean drawControls = true;

// keystone vars
Keystone ks;
CornerPinSurface surface;
PGraphics o; // offset view to draw to

// SimpleOpenNi vars
SimpleOpenNI soni;
float zoomF = 0.3f;
float rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, the data from openni comes upside down
float rotY = radians(0);
float[][] soniPoints;

// mesh creation vars
/*HEC_ConvexHull meshCreator;
HE_Mesh mesh;
WB_Render meshRender;*/

// controlP5 vars
ControlP5 cp5;

void setup() {
  size(vWidth, vHeight, OPENGL);
  frameRate(mainFps);
   
  setupKeystone();
  //setupMeshCreation();
  
  config = new Config(this);
  setupSoni();
  setupControls();
}

void draw() {
  PVector surfaceMouse = surface.getTransformedMouse();
  
  o.beginDraw();
  o.background(0);
  
  updateDrawWorld(false);
  updateSoni();
  //updateDrawMeshes();
  
  o.endDraw();
  background(0);
  surface.render(o);
  
  if(config.debug && drawStats)
  {
    drawStats();
  }
  
  if(config.debug && drawControls)
  {
    drawControls();
  }
  
}
