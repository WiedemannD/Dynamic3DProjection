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








