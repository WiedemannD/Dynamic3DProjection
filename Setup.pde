void setupKeystone()
{
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(vWidth, vHeight, 20);
  
  o = createGraphics(vWidth, vHeight, OPENGL);
  o.smooth();
  o.rectMode(CENTER);
  o.textFont(font);
}

void setupSoni()
{
  soni = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_SINGLE_THREADED);
  //soni = new SimpleOpenNI(this);

  // disable mirror
  soni.setMirror(false);

  // enable depthMap generation 
  if(soni.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }

  o.stroke(255,255,255);
  o.smooth();
  o.perspective(radians(45), float(width)/float(height), 10, 150000);
}

void setupTracker()
{
  tracker = new PointCloudTracker(soni.depthWidth(), soni.depthHeight());
}

/*void setupMeshCreation()
{
  meshCreator = new HEC_ConvexHull();
  meshRender = new WB_Render(this);

}*/

void setupControls()
{
  cp5 = new ControlP5(this);
  
  cp5.addSlider("worldWidth").setPosition(150, 10).setWidth(300).setRange(0, 10000).setValue(1000);
  cp5.addSlider("worldHeight").setPosition(150, 30).setWidth(300).setRange(0, 10000).setValue(1000);
  cp5.addSlider("worldDepth").setPosition(150, 50).setWidth(300).setRange(0, 10000).setValue(1000);
  cp5.addSlider("trackerPointToPointMaxDistance").setPosition(150, 70).setWidth(300).setRange(0, 300).setValue(150);
  cp5.addSlider("trackerCloudSizeThreshold").setPosition(150, 90).setWidth(300).setRange(0, 1000).setValue(200);
  cp5.addSlider("trackerCloudPositionThreshold").setPosition(150, 110).setWidth(300).setRange(0, 1000).setValue(200);
}




