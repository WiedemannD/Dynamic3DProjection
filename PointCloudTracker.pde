class PointCloudTracker
{
  //int mapSteps = 10; 
  
  int[] depthMap;
  PVector[] realWorldMap;
  int mapWidth, mapHeight, pointToPointMaxDistance, cloudSizeThreshold, cloudPositionThreshold;
  int pointCloudCount = 0;
  int trackCount = 0;
  
  PointCloudPoint[] pointCloudPoints;
  PointCloud[] pointClouds;
  ArrayList trackedPointClouds = new ArrayList();
  //float[][][] pointCloudsFloatArray;
  
  PointCloudTracker(int mapW, int mapH)
  {
    mapWidth = mapW;
    mapHeight = mapH;
  }
  
  void update(int[] map, PVector[] realWorld, int maxDistance, int sizeThreshold, int positionThreshold)
  {
    pointCloudCount = 0;
    depthMap = map;
    realWorldMap = realWorld;
    pointToPointMaxDistance = maxDistance;
    cloudSizeThreshold = sizeThreshold;
    cloudPositionThreshold = positionThreshold; 
    
    pointCloudPoints = new PointCloudPoint[realWorldMap.length];
    
    separatePointClouds();
    trackPointClouds();
    
    // debug draw
    if(drawPointClouds)
    {
      //drawPointCloudPoints();
      //drawPointClouds();
      drawTrackedPointClouds();
    }
  }
  
  void separatePointClouds()
  {
    int currentIndex;
    
    for(int y = 0; y < mapHeight; y += config.mapSteps)
    {
      for(int x = 0; x < mapWidth; x += config.mapSteps)
      {
        currentIndex = x + y * soni.depthWidth();
        
        if(pointCloudPoints[currentIndex] == null && depthMap[currentIndex] > 0) // only use points with depth information and which are not already in pointCloudPoints
        { 
          checkForNeighbors(x, y);
          pointCloudCount++;
        }
      }
    }
    
    sortPointClouds();
  }
  
  void sortPointClouds()
  {
    pointClouds = new PointCloud[pointCloudCount];
    //pointCloudsFloatArray = Array[pointCloudCount][][3];
    
    for(int i = 0; i < pointCloudPoints.length; i++)
    {
      PointCloudPoint pcp = pointCloudPoints[i];
      
      if(pcp != null)
      {
        if(pointClouds[pcp.pointCloudId] == null)
        {
          pointClouds[pcp.pointCloudId] = new PointCloud();
          //println("added pointcloud");
        }
        
        PointCloud pointCloud = pointClouds[pcp.pointCloudId];
        pointCloud.add(pcp);
        //println("--added point");
      }
    }
  }
  
  void checkForNeighbors(int x, int y)
  {
    try
    {
      int currentIndex = x + y * soni.depthWidth();
      int neighborIndexTop = x + (y - config.mapSteps) * soni.depthWidth();
      int neighborIndexRight = (x + config.mapSteps) + y * soni.depthWidth();
      int neighborIndexBottom = x + (y + config.mapSteps) * soni.depthWidth();
      int neighborIndexLeft = (x - config.mapSteps) + y * soni.depthWidth();
  
      PVector neighborRealWorldPointTop, neighborRealWorldPointRight, neighborRealWorldPointBottom, neighborRealWorldPointLeft;
      PVector currentRealWorldPoint = realWorldMap[currentIndex];
      
      Boolean hasTopNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexTop, x, (y - config.mapSteps));
      Boolean hasRightNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexRight, (x + config.mapSteps), y);
      Boolean hasBottomNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexBottom, x, (y + config.mapSteps));
      Boolean hasLeftNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexLeft, (x - config.mapSteps), y);
      
      if((hasTopNeighbor || hasRightNeighbor || hasBottomNeighbor || hasLeftNeighbor) && pointCloudPoints[currentIndex] == null)
      {
        pointCloudPoints[currentIndex] = new PointCloudPoint(currentRealWorldPoint, pointCloudCount, x, y);
      }
    }
    catch(StackOverflowError e)
    {
      //print("\nStackOverflowError: too much recursion. ");
    }
  }
  
  Boolean checkForNeighbor(PVector currentRealWorldPoint, int currentIndex, int neighborIndex, int neighborX, int neighborY)
  {
    PVector neighborRealWorldPoint;
    Boolean hasNeighbor = false;
    
    if(neighborIndex > 0 && neighborIndex < pointCloudPoints.length && pointCloudPoints[neighborIndex] == null)
    {
      neighborRealWorldPoint = realWorldMap[neighborIndex];
      
      if(currentRealWorldPoint.dist(neighborRealWorldPoint) <= pointToPointMaxDistance)
      {
        pointCloudPoints[neighborIndex] = new PointCloudPoint(neighborRealWorldPoint, pointCloudCount, neighborX, neighborY);
        hasNeighbor = true;
        
        checkForNeighbors(neighborX, neighborY);
      }
    }
    
    return hasNeighbor;
  }
  
  void trackPointClouds()
  {
    if(trackedPointClouds.size() != 0)
    {
      for(int i = 0; i < pointClouds.length; i++)
      {
        PointCloud pointCloud = pointClouds[i];
        Boolean pointCloudIsNew = true;
        
        for(int j = 0; j < trackedPointClouds.size(); j++)
        {
          PointCloud trackedPointCloud = (PointCloud) trackedPointClouds.get(j);
          
          // old point cloud is tracked
          if(pointCloud != null && isInThreshold(pointCloud.x, trackedPointCloud.x, cloudPositionThreshold) && isInThreshold(pointCloud.y, trackedPointCloud.y, cloudPositionThreshold) && isInThreshold(pointCloud.z, trackedPointCloud.z, cloudPositionThreshold) && isInThreshold(pointCloud.w, trackedPointCloud.w, cloudSizeThreshold) && isInThreshold(pointCloud.h, trackedPointCloud.h, cloudSizeThreshold) && isInThreshold(pointCloud.d, trackedPointCloud.d, cloudSizeThreshold))
          {
            pointCloud.trackCount = trackCount;
            pointCloud.id = trackedPointCloud.id;
            trackedPointClouds.set(j, pointCloud);
            pointCloudIsNew = false;
            
            break;
          }
        }
        
        // new point cloud is added
        if(pointCloud != null && pointCloudIsNew)
        {
          pointCloud.trackCount = trackCount;
          PointCloud lastPointCloud = (PointCloud) trackedPointClouds.get(trackedPointClouds.size() - 1);
          pointCloud.id = lastPointCloud.id + 1;
          trackedPointClouds.add(pointCloud);
        }
      }
    }
    else
    {
      for(int k = 0; k < pointClouds.length; k++)
      {
        PointCloud pointCloud = pointClouds[k];
        
        if(pointCloud != null)
        {
          pointCloud.id = k;
          pointCloud.trackCount = trackCount;
          
          trackedPointClouds.add(pointCloud);
        }
      }
    }
    
    removeUntrackedPointClouds();
    
    trackCount++;
  }
  
  Boolean isInThreshold(float value, float trackedValue, int threshold)
  {
    if(value >= trackedValue - threshold && value <= trackedValue + threshold)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  void removeUntrackedPointClouds()
  {
    for(int i = 0; i < trackedPointClouds.size(); i++)
    {
      PointCloud trackedPointCloud = (PointCloud) trackedPointClouds.get(i);
      
      if(trackedPointCloud.trackCount != trackCount)
      {
        trackedPointClouds.remove(trackedPointCloud);
        i--;
      }
    }
  }
  
  void drawTrackedPointClouds()
  {
    for(int i = 0; i < trackedPointClouds.size(); i++)
    {
      PointCloud pointCloud = (PointCloud) trackedPointClouds.get(i);
      
      if(pointCloud != null)
      {
        o.pushStyle();
          if(pointCloud.id % 2 > 0)
          {
            o.fill(255, 0, 0);  
          }
          else
          {
            o.fill(0, 255, 0);
          }
        
        for(int j = 0; j < pointCloud.size(); j++)
        {
          PointCloudPoint pcp = pointCloud.get(j);
          
          if(pcp != null)
          {
            o.pushMatrix();
              o.translate(0, 0, pcp.z);
              o.ellipse(pcp.x, pcp.y, 30, 30);
            o.popMatrix();
          }
        }
        
        
        // draw id
        o.pushMatrix();
          o.fill(255);
          o.translate(pointCloud.x, pointCloud.y, pointCloud.z);
          o.rotateX(radians(180));
          o.textSize(100);
          o.text("id: " + pointCloud.id, 0, 0);
        o.popMatrix();
        
        o.popStyle();
      }
    }
    
    println("pointclouds (drawTrackedPointClouds): "+trackedPointClouds.size());
  }
  
  void drawPointClouds()
  {
    for(int i = 0; i < pointClouds.length; i++)
    {
      PointCloud pointCloud = pointClouds[i];
      
      if(pointCloud != null)
      {
        //println("pc: x"+pointCloud.x+" y"+pointCloud.y+" w"+pointCloud.w+" h"+pointCloud.h);
        
        for(int j = 0; j < pointCloud.size(); j++)
        {
          PointCloudPoint pcp = (PointCloudPoint) pointCloud.get(j);
          
          if(pcp != null)
          {
            o.pushMatrix();
            o.pushStyle(); 
              
              o.colorMode(HSB, 255);
              o.fill((255/pointCloudCount) * pcp.pointCloudId, 255, 255);
              
              o.translate(0, 0, pcp.z);
              o.ellipse(pcp.x, pcp.y, 30, 30);
            
            o.popStyle();     
            o.popMatrix();
          }
        }
      }
    }
    
    println("pointclouds (drawPointClouds): "+pointCloudCount);
  }
  
  void drawPointCloudPoints()
  {
    for(int i = 0; i < pointCloudPoints.length; i++)
    {
      PointCloudPoint pcp = pointCloudPoints[i];
      
      if(pcp != null)
      {
        o.pushMatrix();
        o.pushStyle(); 
          
          /*if(pcp.pointCloudId % 2 > 0)
          {
            o.fill(255, 0, 0);  
          }
          else
          {
            o.fill(0, 255, 0);
          }*/
          
          o.colorMode(HSB, 255);
          o.fill((255/pointCloudCount) * pcp.pointCloudId, 255, 255);
          
          o.translate(0, 0, pcp.z);
          o.ellipse(pcp.x, pcp.y, 30, 30);
        
        o.popStyle();     
        o.popMatrix();
      }
    }
    
    println("pointclouds (drawPointCloudPoints): "+pointCloudCount);
  }
}
