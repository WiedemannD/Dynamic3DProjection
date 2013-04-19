void updateSoni()
{
  // update the cam
  soni.update();

  o.background(0,0,0);

  o.translate(width/2, height/2, 0);
  o.rotateX(rotX);
  o.rotateY(rotY);
  o.scale(zoomF);

  int[]   depthMap = soni.depthMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;
 
  o.translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera

  o.stroke(255);

  PVector[] realWorldMap = soni.depthMapRealWorld();
  for(int y=0;y < soni.depthHeight();y+=steps)
  {
    for(int x=0;x < soni.depthWidth();x+=steps)
    {
      index = x + y * soni.depthWidth();
      if(depthMap[index] > 0)
      { 
        // draw the projected point
//        realWorldPoint = context.depthMapRealWorld()[index];
        realWorldPoint = realWorldMap[index];
        o.point(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
      }
      //println("x: " + x + " y: " + y);
    }
  } 

  // draw the kinect cam
  soni.drawCamFrustum();
}
