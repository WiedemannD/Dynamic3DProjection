class VisualizerCentral
{
  int visualizerType = 2;
  ArrayList pointClouds;
  ArrayList visualizers;
  int updateVisualizerCount = 0;
  
  VisualizerCentral()
  {
    visualizers = new ArrayList();
  }
  
  void updatePointClouds(ArrayList clouds)
  {
    pointClouds = clouds;
    
    updateVisualizers();
  }
  
  void updateVisualizers()
  {
    if(pointClouds != null)
    {
      for(int i = 0; i < pointClouds.size(); i++)
      {
        PointCloud pointCloud = (PointCloud) pointClouds.get(i);
        Boolean createNewVisualizer = true;
        
        for(int j = 0; j < visualizers.size(); j++)
        {
          Visualizer visualizer = (Visualizer) visualizers.get(j);
          
          if(visualizer.id == pointCloud.id)
          {
            visualizer.updatePointCloud(pointCloud, updateVisualizerCount);
            createNewVisualizer = false;
            break;
          }
        }
        
        if(createNewVisualizer)
        {
          /////////////////
          // place creation of different visualizers here
          // change visualizerType if needed
          /////////////////
          
          switch(visualizerType)
          {
            case 0:
              //just default visualizers
              visualizers.add(new Visualizer(pointCloud, updateVisualizerCount));
              break;
              
            case 1:
              //outline drawing visualizer
              visualizers.add(new VisualizerTron(pointCloud, updateVisualizerCount));
              break;
              
            case 2:
              //outline drawing visualizer
              visualizers.add(new VisualizerMesh(pointCloud, updateVisualizerCount));
              break;
              
            case 3:
              //outline drawing visualizer
              visualizers.add(new VisualizerSimpleMesh(pointCloud, updateVisualizerCount));
              break;
              
            default:
              //just default visualizers
              visualizers.add(new Visualizer(pointCloud, updateVisualizerCount));
              break;
          }
        }
      }
      
      removeUnusedVisualizers();
    
      updateVisualizerCount++;  
    }
  }
  
  void removeUnusedVisualizers()
  {
    for(int i = 0; i < visualizers.size(); i++)
    {
      Visualizer visualizer = (Visualizer) visualizers.get(i);
      
      if(visualizer.updateVisualizerCount != updateVisualizerCount)
      {
        visualizers.remove(visualizer);
        i--;
      }
    }
  }
  
  void draw()
  {
    //o.lights(); // add default lighting
    o.ambientLight(100, 100, 100);
    o.directionalLight(200, 200, 200, 0.3, -0.3, 0.3);
    //o.pointLight(255, 255, 255, 0, 0, 1000);
    
    for(int i = 0; i < visualizers.size(); i++)
    {
      Visualizer visualizer = (Visualizer) visualizers.get(i);
      visualizer.draw();
    }
  }
}
