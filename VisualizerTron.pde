class VisualizerTron extends Visualizer
{
  VisualizerTron(PointCloud cloud, int vCount)
  {
    super(cloud, vCount);
  }
  
  void draw()
  {
    drawScanline();
    drawOutline(1);
  }
  
  void drawScanline()
  {
    ArrayList lines = pointCloud.separateLines(false);
    
    int currentIndex = frameCount % lines.size();
    
    PointCloud currentLine = (PointCloud) lines.get(currentIndex); 
    
    o.pushStyle();
      o.noFill();
      o.stroke(7, 232, 200); // o.stroke(203, 53, 184);
      o.strokeWeight(4);
      o.beginShape();

      for(PointCloudPoint currentPcp: currentLine)
      {
        o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
      }
      
      o.endShape();
    o.popStyle();
  }
  
  void drawOutline(int mode)
  {
    PointCloud outline = pointCloud.separateOutline(false);
    
    o.pushStyle();
      o.noFill();
      o.stroke(0, 255, 0);
      o.strokeWeight(8);
    
      color colHigh = color(7, 232, 200);
      color colLow = color(15, 62, 55);
      
      int currentIndex = frameCount % outline.size();
      
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
        
        switch(mode)
        {
          case 0:
            if(i % 8 > 4)
            {
              o.stroke(col1);
            }
            else
            {
              o.stroke(col2);
            }
            break;
            
          case 1:
            if(i <= currentIndex + (outline.size()/4) && i >= currentIndex - (outline.size()/4))
            {
              o.stroke(colHigh);
            }
            else
            {
              o.stroke(colLow);
            }
            break;
        }
        
        o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
      }
      
      PointCloudPoint firstPcp = outline.get(0);
      o.vertex(firstPcp.x, firstPcp.y, firstPcp.z);
      o.endShape();
    
    o.popStyle();
  }
}
























