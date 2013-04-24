void updateSoni()
{
  // update the cam
  soni.update();

  background(0,0,0);

  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  int[]   depthMap = soni.depthMap();
  int     steps   = 20;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;
 
  translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera

  stroke(255);
  
  soniPoints = new float[307200][3];
  int count = 0;
  
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
        //o.point(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
       pushMatrix(); 
       
         translate(0, 0, realWorldPoint.z);
         ellipse(realWorldPoint.x, realWorldPoint.y, 50, 50);
         
         soniPoints[count][0] = realWorldPoint.x;
         soniPoints[count][1] = realWorldPoint.y;
         soniPoints[count][2] = realWorldPoint.z;
         
         count++;
       
       popMatrix();  
      }
      //println("x: " + x + " y: " + y);
    }
  } 

  // draw the kinect cam
  soni.drawCamFrustum();
}

void updateDrawMeshes()
{
  
  meshCreator.setPoints(soniPoints);
  //alternatively points can be WB_Point[], HE_Vertex[], any Collection<WB_Point>, any Collection<HE_Vertex>,
  //double[][] or int[][]
  meshCreator.setN(307200/20); // set number of points, can be lower than the number of passed points, only the first N points will be used
  meshCreator.setUseQuickHull(true);// (default and recommended)use external John Lloyd’s QuickHull3D package. Included with hemesh. Don't forget to attribute John if you use this.
  
  mesh = new HE_Mesh(meshCreator); 
  HET_Diagnosis.validate(mesh);
  
  stroke(255);
  meshRender.drawEdges(mesh);
  noStroke();
  //meshRender.drawFaces(mesh);
}
