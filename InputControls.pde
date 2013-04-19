int currentCorner = CornerPinSurface.TL;

void keyPressed(){
  /*
  if(key == 'k') // enter/leave calibration mode, where surfaces can be warped and moved, also general calibration mode
  {
    switch(generalCalibration)
    {
      case -1: // switch to projector/cam calibration
        drawVideoCapture = true;
        drawFlobs = false;
        drawTrackedObjects = false;
        populateCreatures = false;
        config.debug = true;
        
        config.videotex = 0;
        flob.setImage(config.videotex);
        
        creatures = new ArrayList();
        groundEffects = new ArrayList();
        
        ks.toggleCalibration(); // turn keystone calibration on
        
        generalCalibration = 0;
        break;
      
      case 0: // switch to tracking calibration
        drawFlobs = true;
        drawTrackedObjects = true;
        
        ks.toggleCalibration(); // turn keystone calibration off
        
        config.videotex = 3;
        flob.setImage(config.videotex);
        
        generalCalibration = 1;
        break;
        
      case 1:
        populateCreatures = true;
        drawFlobs = false;
        drawTrackedObjects = false;
        config.debug = false;
        
        generalCalibration = -1;
        break;
    }
    
    
  }
  
  
  if(key == 'd') // toggle debug mode
  {
    if(!config.debug)
    {
      config.debug = true;
    }
    else
    {
      config.debug = false;
    }
  }
  */
   
  ////////////////
  // Keystone corner positioning via keyboard 
  ////////////////
  
  float moveAmount = 1.0;
  
  if(key=='1') // set keystone corener point
  {
    currentCorner = CornerPinSurface.TL;
  }
  
  if(key=='2') // set keystone corener point
  {
    currentCorner = CornerPinSurface.TR;
  }
  
  if(key=='3') // set keystone corener point
  {
    currentCorner = CornerPinSurface.BR;
  }
  
  if(key=='4') // set keystone corener point
  {
    currentCorner = CornerPinSurface.BL;
  }
  
  switch(keyCode)
  {
    case 38: // top arrow
      if(keyEvent.isShiftDown())
      {
        rotX += 0.1f;
      }
      else
      {
        surface.moveMeshPointBy(currentCorner, 0, - moveAmount);
      }  
      break;
      
    case 39: // right arrow
      if(keyEvent.isShiftDown())
      {
        rotY -= 0.1f;
      }
      else
      {
        surface.moveMeshPointBy(currentCorner, moveAmount, 0);
      }
      break;
      
    case 40: // bottom arrow
      if(keyEvent.isShiftDown())
      {
        rotX -= 0.1f;
      }
      else
      {
        surface.moveMeshPointBy(currentCorner, 0, moveAmount);
      }
      break;
      
    case 37: // left arrow
      if(keyEvent.isShiftDown())
      {
        rotY += 0.1f;
      }
      else
      {
        surface.moveMeshPointBy(currentCorner, - moveAmount, 0);
      }
      break;
      
    default:
      println("unmapped key clicked: " + keyCode);
      break;
  }
}














