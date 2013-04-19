void drawStats()
{  
  String stats = "fps: "+frameRate;/*+
                 "\ncamZoom:"+config.camZoom+" <z/Z>"+
                 "\ncreatures: "+creatures.size()+
                 "\ncreatureExcess: "+config.creatureExcess+" <x/X>"+
                 "\ngroundEffects: "+groundEffects.size()+
                 "\ntrackObjects: "+trackedObjects.size()+
                 "\nflob.thresh:"+config.tresh+" <t/T>"+
                 "\nflob.fade:"+config.fade+"   <f/F>"+
                 "\nflob.om:"+flob.getOm()+" <o>"+
                 "\nflob.image:"+config.videotex+" <i>"+
                 "\nflob.presence:"+flob.getPresencef()+
                 "\nedgeTresh:"+config.edgeTresh+" <e/E>"+
                 "\nposDiscrimination:"+config.posDiscrimination+" <p>"+
                 "\n\nset background <b>"+
                 "\ntoggle keystone mode <k>"+
                 "\ntoggle fullscreen mode <cmd+f>"+
                 "\ncreate random creature <c>"+
                 "\ncreate random creature in the center <C>"+
                 "\nremove all creatures <r>"+
                 "\ntoggle debug info <d>"+
                 "\nsave config AND save keystone <s>"+
                 "\nset background AND save config AND save keystone <space>";*/
  textSize(14);
  fill(0);
  text(stats, 4, 24);
  fill(255);
  text(stats, 5, 25);
}
