/*
  Dynamic3DProjection  
*/
import processing.opengl.*;
import deadpixel.keystone.*;
import SimpleOpenNI.*;
import controlP5.*;

// general variables
Config config;
int vWidth = 1280;//1024;
int vHeight = 1024;//768;
int mainFps = 300;
int worldWidth = 1000;
int worldHeight = worldWidth;
int worldDepth = worldWidth;



PFont font = createFont("monaspace", 20);

// flags
Boolean drawStats = true;
Boolean drawControls = true;
Boolean drawPointClouds = false;

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

// tracking vars
PointCloudTracker tracker;
int trackerPointToPointMaxDistance = 150;
int trackerCloudSizeThreshold = 50;
int trackerCloudPositionThreshold = 50;

// visualizer vars
VisualizerCentral visualizerCentral;

// controlP5 vars
ControlP5 cp5;
CallbackListener cpListener;

void setup() {
  size(vWidth, vHeight, OPENGL);
  frameRate(mainFps);
   
  setupKeystone();
  //setupMeshCreation();
  
  config = new Config(this);
  setupSoni();
  setupTracker();
  setupVisualizerCentral();
  setupControls();
}

void draw() {
  PVector surfaceMouse = surface.getTransformedMouse();
  
  o.beginDraw();
  o.background(0);
  
  updateDrawWorld(false);
  updateSoni();
  updateTracker();
  updateDrawVisualizerCentral();
  
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
