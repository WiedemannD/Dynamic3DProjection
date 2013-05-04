class PointCloud extends ArrayList
{
  float x, y, z;
  float mostTop, mostRight, mostBottom, mostLeft, mostFront, mostBack;
  float w, h, d = 0;
  int id;
  int trackCount = 0;
  
  PointCloud()
  {
    super();
  }
  
  boolean add(PointCloudPoint pcp)
  {
    boolean returnValue = super.add(pcp); 
    
    calcDimensions(pcp);
    
    return returnValue;
  }
  
  void add(int index, PointCloudPoint pcp)
  {
    super.add(index, pcp);
    
    calcDimensions(pcp);
  }
  
  void calcDimensions(PointCloudPoint pcp)
  {
    if(this.size() == 1)
    {
      this.x = pcp.x; 
      this.mostRight = pcp.x; 
      this.mostLeft = pcp.x;
      this.y = pcp.y; 
      this.mostTop = pcp.y; 
      this.mostBottom = pcp.y;
      this.z = pcp.z;
      this.mostFront = pcp.z;
      this.mostBack = pcp.z;
    }
    else if(pcp.x > this.mostRight)
    {
      this.mostRight = pcp.x;
    }
    else if(pcp.x < this.mostLeft)
    {
      this.mostLeft = pcp.x;
    }
    else if(pcp.y > this.mostBottom)
    {
      this.mostBottom = pcp.y;
    }
    else if(pcp.y < this.mostTop)
    {
      this.mostTop = pcp.y;
    }
    else if(pcp.z > this.mostBack)
    {
      this.mostBack = pcp.z;
    }
    else if(pcp.z < this.mostFront)
    {
      this.mostFront = pcp.z;
    }
    
    w = mostRight - mostLeft;
    h = mostBottom - mostTop;
    d = mostFront - mostBack;
    x = mostLeft + (w/2);
    y = mostTop + (h/2);
    z = mostBack + (d/2);
  }
}
