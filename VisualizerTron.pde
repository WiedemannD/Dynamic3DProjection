class VisualizerTron extends Visualizer
{
  VisualizerTron(PointCloud cloud, int vCount)
  {
    super(cloud, vCount);
  }
  
  void draw()
  {
    PointCloud outline = pointCloud.separateOutline(false);
    
    o.pushStyle();
      o.noFill();
      o.stroke(0, 255, 0);
      o.strokeWeight(8);
    
      color colHigh = color(7, 232, 200);
      color colLow = color(15, 62, 55);
      color col1, col2;
      
      if(frameCount % 20 > 10)
      {
        col1 = colHigh;
        col2 = colLow;
      }
      else
      {
        col1 = colLow;
        col2 = colHigh;
      }
      
      o.beginShape();
    
      for(int i = 0; i < outline.size(); i++) 
      {
        PointCloudPoint currentPcp = outline.get(i);
        
        if(i % 8 > 4)
        {
          o.stroke(col1);
        }
        else
        {
          o.stroke(col2);
        }
        
        o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
      }
      
      PointCloudPoint firstPcp = outline.get(0);
      o.vertex(firstPcp.x, firstPcp.y, firstPcp.z);
      o.endShape();
    
    o.popStyle();
  }
}
























