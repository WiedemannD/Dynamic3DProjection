class Config
{
  ///////////////
  // to add config vars: edit varCount and varNames, add var, edit functions save and load (yeah I know this sucks ...)
  ///////////////
  
  int varCount = 11;
  String[] varNames = {"tresh", "fade", "om", "videores", "videotex", "trackedBlobLifetime", "edgeTresh", "posDiscrimination", "debug", "creatureExcess", "camZoom"};
  
  // general vars
  Boolean debug = true;
  
  // tracking vars
  int mapSteps = 5;
  
  // objects for general use
  PApplet main;
  
  Config(PApplet m)
  {
    main = m;
    load();
    //ks.load();
    
  }
  
  
  void save()
  {
     String[] varsToSave = new String[varCount];
     
     //varsToSave[0] = varNames[0] + " = " + tresh;
     
     
     saveStrings("data/config.txt", varsToSave);
     
          
     println("config saved");
  }
  
  void load()
  {
    String[] varsLoaded = loadStrings("data/config.txt");
    
    /*
    tresh =                 Integer.parseInt(getSavedValue(varsLoaded[0]));
    edgeTresh =             float(getSavedValue(varsLoaded[6]));
    posDiscrimination =     boolean(getSavedValue(varsLoaded[7]));
   */
  }
  
  String getSavedValue(String str)
  {
    str = str.substring(str.indexOf(" ") + 3, str.length());
    return str;
  }
  
  void reset()
  {
  
  }
}


