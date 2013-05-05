class VisualizerCentral
{
  int visualizerType = 0;
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
    for(int i = 0; i < visualizers.size(); i++)
    {
      Visualizer visualizer = (Visualizer) visualizers.get(i);
      visualizer.draw();
    }
  }
}