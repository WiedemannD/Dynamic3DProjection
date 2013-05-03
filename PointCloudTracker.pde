class PointCloudTracker
{
  int mapSteps = 10; 
  int maxPointClouds = 500; // might be good to keep low for performance
  
  
  int[] depthMap;
  PVector[] realWorldMap;
  int mapWidth, mapHeight, pointToPointMaxDistance;
  int pointCloudCount = 0;
  
  PointCloudPoint[] pointCloudPoints;
  ArrayList[] pointClouds;
  //float[][][] pointCloudsFloatArray;
  
  PointCloudTracker(int[] map, PVector[] realWorld, int mapW, int mapH, int maxDistance)
  {
    depthMap = map;
    realWorldMap = realWorld;
    mapWidth = mapW;
    mapHeight = mapH;
    pointCloudPoints = new PointCloudPoint[realWorldMap.length];
    pointToPointMaxDistance = maxDistance;
    
    separatePointClouds();
    
    // debug draw
    if(drawPointClouds)
    {
      //drawPointCloudPoints();
      drawPointClouds();
    }
  }
  
  void separatePointClouds()
  {
    int currentIndex;
    
    for(int y = 0; y < mapHeight; y += mapSteps)
    {
      for(int x = 0; x < mapWidth; x += mapSteps)
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
    pointClouds = new ArrayList[pointCloudCount];
    //pointCloudsFloatArray = Array[pointCloudCount][][3];
    
    for(int i = 0; i < pointCloudPoints.length; i++)
    {
      PointCloudPoint pcp = pointCloudPoints[i];
      
      if(pcp != null)
      {
        if(pointClouds[pcp.pointCloudId] == null)
        {
          pointClouds[pcp.pointCloudId] = new ArrayList();
          //println("added pointcloud");
        }
        
        ArrayList pointCloud = pointClouds[pcp.pointCloudId];
        pointCloud.add(pcp);
        //println("--added point");
      }
    }
  }
  
  void drawPointClouds()
  {
    for(int i = 0; i < pointClouds.length; i++)
    {
      ArrayList pointCloud = pointClouds[i];
      
      //println("length "+ pointClouds.length);
      //println("size "+i+"  "+pointCloud.size());
      
      if(pointCloud != null)
      {
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
  
  void checkForNeighbors(int x, int y)
  {
    int currentIndex = x + y * soni.depthWidth();
    int neighborIndexTop = x + (y - mapSteps) * soni.depthWidth();
    int neighborIndexRight = (x + mapSteps) + y * soni.depthWidth();
    int neighborIndexBottom = x + (y + mapSteps) * soni.depthWidth();
    int neighborIndexLeft = (x - mapSteps) + y * soni.depthWidth();

    PVector neighborRealWorldPointTop, neighborRealWorldPointRight, neighborRealWorldPointBottom, neighborRealWorldPointLeft;
    PVector currentRealWorldPoint = realWorldMap[currentIndex];
    
    Boolean hasTopNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexTop, x, (y - mapSteps));
    Boolean hasRightNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexRight, (x + mapSteps), y);
    Boolean hasBottomNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexBottom, x, (y + mapSteps));
    Boolean hasLeftNeighbor = checkForNeighbor(currentRealWorldPoint, currentIndex, neighborIndexLeft, (x - mapSteps), y);
    
    if((hasTopNeighbor || hasRightNeighbor || hasBottomNeighbor || hasLeftNeighbor) && pointCloudPoints[currentIndex] == null)
    {
      pointCloudPoints[currentIndex] = new PointCloudPoint(currentRealWorldPoint, pointCloudCount);
    }
    
        /*
    // top
    if(neighborIndexTop > 0 && pointCloudPoints[neighborIndexTop] == null)
    {
      neighborRealWorldPointTop = realWorldMap[neighborIndexTop];
      
      if(currentRealWorldPoint.dist(neighborRealWorldPointTop) <= pointToPointMaxDistance)
      {
        pointCloudPoints[neighborIndexTop] = new PointCloudPoint(neighborRealWorldPointTop, pointCloudCount);
        hasTopNeighbor = true;
        
        checkForNeighbors(neighborRealWorldPointTop.x, neighborRealWorldPointTop.y);
      }
    }
    
    // right
    if(neighborIndexRight < pointCloudPoints.length && pointCloudPoints[neighborIndexRight] == null)
    {
      neighborRealWorldPointRight = realWorldMap[neighborIndexRight];
      
      if(currentRealWorldPoint.dist(neighborRealWorldPointRight) <= pointToPointMaxDistance)
      {
        pointCloudPoints[neighborIndexRight] = new PointCloudPoint(neighborRealWorldPointRight, pointCloudCount);
        hasRightNeighbor = true;
        
        checkForNeighbors(neighborRealWorldPointRight.x, neighborRealWorldPointRight.y);
      }
    }*/

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
        pointCloudPoints[neighborIndex] = new PointCloudPoint(neighborRealWorldPoint, pointCloudCount);
        hasNeighbor = true;
        
        checkForNeighbors(neighborX, neighborY);
      }
    }
    
    return hasNeighbor;
  }
  
  
}
