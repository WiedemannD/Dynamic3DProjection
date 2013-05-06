import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

class VisualizerMesh extends Visualizer
{
  MeshCreatorThread meshCreatorThread;
  HE_Mesh mesh;
  WB_Render meshRenderer;
  
  float originX, originY, originZ; 
  float lastMoveX = 0;
  float lastMoveY = 0;
  float lastMoveZ = 0;
  
  VisualizerMesh(PointCloud cloud, int vCount)
  {
    super(cloud, vCount);
  }
  
  void init()
  {
    super.init();
    
    if(pointCloud.size() >= 4)
    {
      originX = pointCloud.x;
      originY = pointCloud.y;
      originZ = pointCloud.z;
      
      meshCreatorThread = new MeshCreatorThread(pointCloud.getWB_Point3dArray());
      meshRenderer = new WB_Render(config.main);
    }
  }
  
  void draw()
  {
    if(pointCloud.size() >= 4)
    {
      if(mesh == null)
      {
        getMesh();
        drawOutline(1);
      }
      else
      {
        drawMesh();
      }
    }
    else
    {
      drawOutline(0);
    }
    
    //drawId();
  }
  
  void getMesh()
  {
    if(meshCreatorThread != null && meshCreatorThread.meshIsCreated())
    {
      mesh = meshCreatorThread.mesh;
    }
  }
  
  void drawMesh()
  {
    o.pushMatrix();
    o.pushStyle();
      
      // move coordinate system
      float lerpAmount = 0.2;
      float moveX = lerp(lastMoveX, pointCloud.x - originX, lerpAmount); //pointCloud.x - originX;
      float moveY = lerp(lastMoveY, pointCloud.y - originY, lerpAmount); //pointCloud.y - originY;
      float moveZ = lerp(lastMoveZ, pointCloud.z - originZ, lerpAmount); //pointCloud.z - originZ;
      
      o.translate(moveX, moveY, moveZ);
      
      lastMoveX = moveX;
      lastMoveY = moveY;
      lastMoveZ = moveZ; 
      
      // draw mesh
      o.stroke(47, 142, 127);
      //meshRenderer.drawEdges(mesh, o);
      o.noStroke();
      o.fill(7, 232, 200);
      meshRenderer.drawFaces(mesh, o);
      
    o.popStyle();
    o.popMatrix();
  }
  
  void drawOutline(int mode)
  {
    PointCloud outline = pointCloud.separateOutline(false);
    
    o.pushStyle();
      o.noFill();
      o.strokeWeight(8);
    
      color colHigh = color(200);
      color colLow = color(100);
      
      o.beginShape();
    
      for(int i = 0; i < outline.size(); i++) 
      {
        PointCloudPoint currentPcp = outline.get(i);
        
        switch(mode)
        {
          case 0:
            o.stroke(colLow);
            break;
            
          case 1:
            if(i % 8 > 4)
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
  
  void drawId()
  {
     // draw id
    o.pushMatrix();
      o.fill(255);
      o.translate(pointCloud.x, pointCloud.y, pointCloud.z);
      o.rotateX(radians(180));
      o.textSize(100);
      o.text("id: " + pointCloud.id, 0, 0);
    o.popMatrix();
  }
}



// thread that handles just the creation of the mesh separate
class MeshCreatorThread extends Thread
{
  boolean running;                   // Is the thread running?  Yes or no?
  boolean available;                 // is thread available for others to request
  String id = "MeshCreatorThread";
  
  WB_Point3d[] points;
  HEC_ConvexHull meshCreator;
  HE_Mesh mesh;
  Boolean meshIsCreated;
  
  MeshCreatorThread(WB_Point3d[] ps)
  {
    points = ps;
    running = false;
    meshIsCreated = false;
    
    start();
  }
  
  void start()
  {
    // thread stuff
    running = true;
    super.start();
  }
  
  void run()
  {
    while(running)
    {
      meshCreator = new HEC_ConvexHull();
      meshCreator.setPoints(points); //alternatively points can be WB_Point[], HE_Vertex[], any Collection<WB_Point>, any Collection<HE_Vertex>, double[][] or int[][]
      meshCreator.setN(points.length); // set number of points, can be lower than the number of passed points, only the first N points will be used
      meshCreator.setUseQuickHull(true);// (default and recommended)use external John Lloyd’s QuickHull3D package. Included with hemesh. Don't forget to attribute John if you use this.
      
      try
      {
        mesh = new HE_Mesh(meshCreator);
      }
      catch(IllegalArgumentException e)
      {
        //println("IllegalArgumentException: " + e);
      }
      
      if(mesh != null)
      {
        HET_Diagnosis.validate(mesh, false, true, true); // no clue if needed
      
        meshIsCreated = true;
      }
      
      // stop thread
      quit();
    }
  }
  
  Boolean meshIsCreated()
  {
    return meshIsCreated;
  }
  
  void quit() 
  {
    running = false;  // Setting running to false ends the loop in run()
    // In case the thread is waiting. . .
    interrupt();
  }
  
  boolean isAvailable() 
  {
    return available;
  }
}






















