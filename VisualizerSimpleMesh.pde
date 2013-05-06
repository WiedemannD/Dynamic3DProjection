class VisualizerSimpleMesh extends Visualizer
{
  VisualizerSimpleMesh(PointCloud cloud, int vCount)
  {
    super(cloud, vCount);
  }
  
  void draw()
  {
    drawQuadStrips();
    //drawQuads();
  }
  
  void drawQuads()
  {
    ArrayList lines = pointCloud.separateLines(false);
    
    o.pushStyle();
      color colHigh = color(7, 232, 200);
      color colLow = color(15, 62, 55);

      o.fill(colHigh);
      o.stroke(colLow);
      o.noStroke();
      
      o.beginShape(QUADS);
      
      for(int h = 0; h < lines.size() - 1; h++)
      {
        PointCloud currentLine = (PointCloud) lines.get(h);
        PointCloud nextLine = (PointCloud) lines.get(h + 1);
        
        for(int i = 0; i < currentLine.size() - 1; i++) 
        {
          PointCloudPoint currentPcp = currentLine.get(i);
          PointCloudPoint blPcp = nextLine.getWithMapXY(currentPcp.mapX, currentPcp.mapY + config.mapSteps);
          PointCloudPoint brPcp = nextLine.getWithMapXY(currentPcp.mapX + config.mapSteps, currentPcp.mapY + config.mapSteps);
          PointCloudPoint trPcp = currentLine.get(i + 1);
          
          o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
          
          if(blPcp != null)
          {
            o.vertex(blPcp.x, blPcp.y, blPcp.z);
          }
          else
          {
            o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
          }
          
          if(brPcp != null)
          {
            o.vertex(brPcp.x, brPcp.y, brPcp.z);
          }
          else
          {
            o.vertex(trPcp.x, trPcp.y, trPcp.z);
          }
          
          o.vertex(trPcp.x, trPcp.y, trPcp.z);
        }
      }

      o.endShape(); // CLOSE?

    o.popStyle();
  }
  
  void drawQuadStrips()
  {
    ArrayList lines = pointCloud.separateLines(false);
    
    o.pushStyle();
      color colHigh = color(7, 232, 200);
      color colLow = color(15, 62, 55);

      o.fill(colHigh);
      o.stroke(colLow);
      o.noStroke();
      
      for(int h = 0; h < lines.size() - 1; h++)
      {
        PointCloud currentLine = (PointCloud) lines.get(h);
        PointCloud nextLine = (PointCloud) lines.get(h + 1);
        
        o.beginShape(QUAD_STRIP);
        
        for(int i = 0; i < currentLine.size(); i++) 
        {
          PointCloudPoint currentPcp = currentLine.get(i);
          PointCloudPoint bottomPcp = nextLine.getWithMapXY(currentPcp.mapX, currentPcp.mapY + config.mapSteps);
          
          o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
          
          if(bottomPcp != null)
          {
            o.vertex(bottomPcp.x, bottomPcp.y, bottomPcp.z);
          }
          else
          {
            o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
          }
        }
        
        o.endShape(); // CLOSE?
      }

    o.popStyle();
  }
}
























