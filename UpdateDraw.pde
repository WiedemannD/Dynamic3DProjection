void updateDrawWorld(Boolean drawWorldBounds)
{
  o.background(0,0,0);
  
  o.translate(width/2, height/2, 0);
  o.rotateX(rotX);
  o.rotateY(rotY);
  o.scale(zoomF);
  o.translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
  
  if(drawWorldBounds)
  {
    int worldBoundsTransparecy = 70; 
    
    o.pushStyle();
      o.textSize(60);
      o.stroke(255, worldBoundsTransparecy);
      
      o.fill(0, 0, 255, worldBoundsTransparecy);
      o.pushMatrix();
        o.translate(0, 0, worldDepth);
        o.rect(0, 0, worldWidth, worldHeight); // back

        o.rotateX(radians(180));        
        o.fill(255, worldBoundsTransparecy * 3);
        o.text("back", 0, 0);
      o.popMatrix();
      
      o.fill(0, 255, 0, worldBoundsTransparecy);
      o.pushMatrix();
        o.rotateX(radians(90));
        o.rect(0, 0, worldWidth, worldDepth); // bottom
        
        o.rotateX(radians(180));        
        o.fill(255, worldBoundsTransparecy * 3);
        o.text("bottom", 0, 0);
        
        o.fill(0, 255, 0, worldBoundsTransparecy);
        o.rotateX(radians(-180));  
        o.translate(0, 0, -worldHeight);
        o.rect(0, 0, worldWidth, worldDepth); // top
        
        o.rotateX(radians(180));
        o.fill(255, worldBoundsTransparecy * 3);
        o.text("top", 0, 0);
        
      o.popMatrix();
      
      o.fill(255, 0, 0, worldBoundsTransparecy);
      o.pushMatrix();
        o.rotateY(radians(90));
        o.translate(-worldDepth, 0, 0);
        o.rect(0, 0, worldDepth, worldHeight); // left

        o.rotateZ(radians(180));        
        o.fill(255, worldBoundsTransparecy * 3);
        o.text("left", -worldDepth, 0);
          
        o.rotateZ(radians(-180));
        o.translate(0, 0, worldWidth);
        o.fill(255, 0, 0, worldBoundsTransparecy);
        o.rect(0, 0, worldDepth, worldHeight); // right
        
        o.rotateZ(radians(180));        
        o.fill(255, worldBoundsTransparecy * 3);
        o.text("right", -worldDepth, 0);
      o.popMatrix();
      
    o.popStyle();
  }
  
}

void updateSoni()
{
  // update the cam
  soni.update();


  int[]   depthMap = soni.depthMap();
  int     steps   = 10;  // to speed up the drawing, draw every third point
  int     index;
  int     indexLeft;
  int     indexRight;
  int     indexTop;
  int     indexBottom;
  PVector realWorldPoint;
  PVector realWorldPointLeft;
  PVector realWorldPointRight;
  PVector realWorldPointTop;
  PVector realWorldPointBottom;
  
  ArrayList firstObject; 
  
  boolean noAddLeft = false;
  boolean noAddRight = false;
  boolean noAddTop = false;
  boolean noAddBottom = false;
    
  float threshold = 20; // needs testing
 
  o.stroke(255);
  
  firstObject = new ArrayList(); 
  
  //soniPoints = new float[307200][3]; // HUGE HIT ON PERFORMANCE, THINK OF SOMETHING ELSE!!!!!!!!!!!
  int count = 0;
  
  PVector[] realWorldMap = soni.depthMapRealWorld(); 
  for(int y=0;y < soni.depthHeight();y+=steps)
  {
    for(int x=0;x < soni.depthWidth();x+=steps)
    {
      index = x + y * soni.depthWidth();
      if(depthMap[index] > 0)
      { 
        //if(realWorldPoint.x < worldWidth)
        //{
         // draw the projected point
         // realWorldPoint = context.depthMapRealWorld()[index];
         realWorldPoint = realWorldMap[index];
         
         // find neighbours
         indexLeft = (x - steps) + y * soni.depthWidth();
         indexRight = (x + steps) + y * soni.depthWidth();
         indexTop = x + (y - steps) * soni.depthWidth();
         indexBottom = x + (y + steps) * soni.depthWidth();
         
         // FIX FOR OUT OF BOUNDARIES!!
         
          realWorldPointLeft = realWorldMap[indexLeft];
          realWorldPointRight = realWorldMap[indexRight];
          realWorldPointTop = realWorldMap[indexTop];
          realWorldPointBottom = realWorldMap[indexBottom];
          
          // calculating distances between point and neighbours
          float leftDistance = PVector.dist(realWorldPointLeft, realWorldPoint);
          float rightDistance = PVector.dist(realWorldPointRight, realWorldPoint);
          float topDistance = PVector.dist(realWorldPointTop, realWorldPoint);
          float bottomDistance = PVector.dist(realWorldPointBottom, realWorldPoint);
          
          if (leftDistance < threshold)
          {
            noAddLeft = false;
            
            for (int i = firstObject.size()-1; i >= 0; i++)
            {
              PVector elementToTest = (PVector) firstObject.get(i);
              if (elementToTest == realWorldPointLeft) 
              {
                noAddLeft = true;
              }
            }
          }
          
          if (rightDistance < threshold)
          {
            noAddRight = false;
            
            for (int i = firstObject.size()-1; i >= 0; i++)
            {
              PVector elementToTest = (PVector) firstObject.get(i);
              if (elementToTest == realWorldPointRight) 
              {
                noAddRight = true;
              }
            }
          }
          
          if (topDistance < threshold)
          {
            noAddTop = false;
            
            for (int i = firstObject.size()-1; i >= 0; i++)
            {
              PVector elementToTest = (PVector) firstObject.get(i);
              if (elementToTest == realWorldPointTop) 
              {
                noAddTop = true;
              }
            }
          }
          
          if (bottomDistance < threshold)
          {
            noAddBottom = false;
            
            for (int i = firstObject.size()-1; i >= 0; i++)
            {
              PVector elementToTest = (PVector) firstObject.get(i);
              if (elementToTest == realWorldPointBottom) 
              {
                noAddBottom = true;
              }
            }
          }
          
          if (noAddLeft == false) 
          {
            firstObject.add(realWorldPointLeft);
          } 

          if (noAddRight == false) 
          {
            firstObject.add(realWorldPointRight);
          } 

          if (noAddTop == false) 
          {
            firstObject.add(realWorldPointTop);
          } 

          if (noAddBottom == false) 
          {
            firstObject.add(realWorldPointBottom);
          } 

          
          //o.point(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
         
          //println("xyz "+realWorldPoint.x+" "+ realWorldPoint.y+" "+ realWorldPoint.z);
         
          o.pushMatrix(); 
           
            o.translate(0, 0, realWorldPoint.z);
            o.ellipse(realWorldPoint.x, realWorldPoint.y, 10, 10);
           
            /*soniPoints[count][0] = realWorldPoint.x;
            soniPoints[count][1] = realWorldPoint.y;
            soniPoints[count][2] = realWorldPoint.z;
           
            count++;
            */
          o.popMatrix(); 
        //} 
      }
    }
  } 

  // draw the kinect cam
  //soni.drawCamFrustum();
}

/*void updateDrawMeshes()
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
}*/

void drawControls()
{
  
}
