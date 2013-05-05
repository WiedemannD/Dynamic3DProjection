import java.util.Comparator;
import java.util.Collections;

class PointCloud extends ArrayList<PointCloudPoint>
{
  float x, y, z;
  float mostTop, mostRight, mostBottom, mostLeft, mostFront, mostBack;
  float w, h, d = 0;
  int id;
  int trackCount = 0;
  ArrayList lines; // maybe add concentric circles
  PointCloud outline;
  
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
  
  PointCloudPoint get(int index)
  {
    if(index < 0)
    {
      return null;
    }
    
    return (PointCloudPoint) super.get(index);
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
  
  // separate pointCloud into lines of pointClouds
  ArrayList separateLines(Boolean overwrite)
  {
    if(overwrite || lines == null)
    {
      lines = new ArrayList();
      lines.add(new PointCloud());
      
      for (PointCloudPoint pcp : this) 
      {
        PointCloud currentLine = (PointCloud) lines.get(lines.size() - 1);
        PointCloudPoint lastPcp = currentLine.get(currentLine.size() - 1);
        
        if(currentLine.size() == 0 || lastPcp.mapY == pcp.mapY)
        {
          currentLine.add(pcp);
        }
        else
        {
          PointCloud newLine = new PointCloud();
          newLine.add(pcp);
          lines.add(newLine);
        }
      }
    }
    
    return lines;
  }
  
  // separate pointCloud into lines and then separate outline
  PointCloud separateOutline(Boolean overwrite)
  {
    if(overwrite || outline == null)
    {
      separateLines(false);
      
      //////////////
      // this approach of determing the complete outline is not correct but might be sufficient for most cases
      //////////////
      
      // add all points of top line
      outline = (PointCloud) lines.get(0);
      
      // add all right most points, except from top and bottom lines
      for(int i = 1; i < lines.size() - 1; i++)
      {
        PointCloud line = (PointCloud) lines.get(i);
        outline.add(line.get(line.size() - 1));
      }
      
      // add all bottom points in reverse order
      PointCloud bottomLine = (PointCloud) lines.get(lines.size() - 1);
      for(int j = bottomLine.size() - 1; j >= 0; j--)
      {
        outline.add(bottomLine.get(j));
      }
      
      // add all left most points, except from top and bottom lines in reverse order
      for(int k = lines.size() - 2; k >= 1; k--)
      {
        PointCloud line = (PointCloud) lines.get(k);
        outline.add(line.get(0));
      }
    }
    
    return outline;
  }
  
  // sorts the pointCloud after mapY and then mapX, it seems the points are by default sorted like this
  void sortMapYX()
  {
    Collections.sort(this, new ComparatorMapYX());
  }
  
  // sorts the pointCloud after z
  void sortZ()
  {
    Collections.sort(this, new ComparatorZ());
  }
}

// Comparator class to sort PointCloud
class ComparatorMapYX implements Comparator<PointCloudPoint>
{
  int compare(PointCloudPoint pcp1, PointCloudPoint pcp2)
  {
    //first sort after mapY
    if(pcp1.mapY != pcp2.mapY)
    {
      return pcp1.mapY - pcp2.mapY;
    } 
    //second sort after mapX
    else 
    {
      return pcp1.mapX - pcp2.mapX;
    }
  }
}

// Comparator class to sort PointCloud
class ComparatorZ implements Comparator<PointCloudPoint>
{
  int compare(PointCloudPoint pcp1, PointCloudPoint pcp2)
  {
    return int(pcp1.z) - int(pcp2.z);
  }
}
