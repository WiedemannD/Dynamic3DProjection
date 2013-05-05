class VisualizerTron extends Visualizer
{
  VisualizerTron(PointCloud cloud, int vCount)
  {
    super(cloud, vCount);
  }
  
  void draw()
  {
    //ArrayList lines = pointCloud.separateLines(true);
    
    PointCloud outline = pointCloud.separateOutline(false);
    
    o.pushStyle();
      //o.fill(0, 255, 0);
      o.noFill();
      o.stroke(0, 255, 0);
      o.strokeWeight(8);
      
      o.beginShape();
    
      for(int i = 0; i < outline.size(); i++) 
      {
        PointCloudPoint currentPcp = outline.get(i);
        
        
        o.vertex(currentPcp.x, currentPcp.y, currentPcp.z);
        
          
          
          //o.line(currentPcp.x, currentPcp.y, currentPcp.z, nextPcp.x, nextPcp.y, nextPcp.z);
        /* 
        o.pushMatrix();
          o.translate(0, 0, pcp.z);
          o.ellipse(pcp.x, pcp.y, 30, 30);
        o.popMatrix();
        */
       
        
      }
      
      PointCloudPoint firstPcp = outline.get(0);
      o.vertex(firstPcp.x, firstPcp.y, firstPcp.z);
      o.endShape();
    o.popStyle();
  }
}
























