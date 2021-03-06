void updateDrawWorld(Boolean drawWorldBounds)
{
  o.background(0,0,0);
  
  o.translate(width/2, height/2, 0);
  o.rotateX(rotX);
  o.rotateY(rotY);
  o.scale(zoomF);
  o.translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
  
  o.noStroke();
  
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
  soni.update();
}

void updateTracker()
{
  tracker.update(soni.depthMap(), soni.depthMapRealWorld(), trackerPointToPointMaxDistance, trackerCloudSizeThreshold, trackerCloudPositionThreshold);
}

void updateDrawVisualizerCentral()
{
  visualizerCentral.updatePointClouds(tracker.trackedPointClouds);
  visualizerCentral.draw();
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
