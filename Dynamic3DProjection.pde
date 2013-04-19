/*
  Dynamic3DProjection  
*/
import processing.opengl.*;
import deadpixel.keystone.*;
import SimpleOpenNI.*;

// general variables
Config config;
int vWidth = 1280;//1024;
int vHeight = 1024;//768;
int mainFps = 300;

PFont font = createFont("monaspace", 20);

// flags
Boolean drawStats = true;

// keystone vars
Keystone ks;
CornerPinSurface surface;
PGraphics o; // offset view to draw to

// SimpleOpenNi vars
SimpleOpenNI soni;
float zoomF = 0.3f;
float rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, the data from openni comes upside down
float rotY = radians(0);

void setup() {
  size(vWidth, vHeight, OPENGL);
  frameRate(mainFps);
  
   
  setupKeystone();
  
  config = new Config(this);
  
  setupSoni();
}

void draw() {
  PVector surfaceMouse = surface.getTransformedMouse();
  
  o.beginDraw();
  o.background(0);
  
  updateSoni();
  
  o.endDraw();
  background(0);
  surface.render(o);
  
  if(config.debug && drawStats)
  {
    drawStats();
  }
  
}
