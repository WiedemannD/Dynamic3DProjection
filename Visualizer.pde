class Visualizer
{
  int id;
  int updateVisualizerCount;
  PointCloud pointCloud;
  
  Visualizer(PointCloud cloud, int vCount)
  {
    updatePointCloud(cloud, vCount);
    id = pointCloud.id;
    
    init();
  }
  
  
  // default initialization method
  // overwrite in extended Visualizer classes
  void init()
  {
  
  }

  // default drawing method
  // overwrite in extended Visualizer classes
  void draw()
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
      PointCloudPoint pcp = (PointCloudPoint) pointCloud.get(j);
      
      o.pushMatrix();
        o.translate(0, 0, pcp.z);
        o.ellipse(pcp.x, pcp.y, 30, 30);
      o.popMatrix();
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
  
  
  void updatePointCloud(PointCloud cloud, int vCount)
  {
    updateVisualizerCount = vCount;
    pointCloud = cloud;
  }
}
