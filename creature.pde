class creature{
  net brain;
  float posx;
  float posy;
  int col = 0;
  int c2 = 0;
  int c3 = 0;
  String name;
  
  creature(int x, int y){
    posx = x;
    posy = y;
    rebrain();
  }
  
  void rebrain(){
    
    brain = new net(new int[]{4,5,4,3,2},50,250); 
    col = (int) (Math.random()*100);
    c2 = (int) (Math.random()*70+30);
    c3 = (int) (Math.random()*30+70);
    
    name = namegen();
  }
  
  float mm = 5;
  void tick(){
   float rx = mouseX-centerx-posx;
   float ry = mouseY-centery-posy;
   
    int mx = (int)max(abs(posx),abs(posy));
    if (mx>250){ 
      rebrain() ;
      posx=(float)(Math.random()-0.5)*100;
      posy=(float)(Math.random()-0.5)*100;
      
    }
    float nx = 0;
    float ny = 0;
    int cd = 9999;
    for (creature c:creatures){
      if (c!=this){
        int cont = (int)sqrt(pow((posx-c.posx),2)+pow((posy-c.posy),2));
        if (cont<cd){
          cd=cont;
          nx = posx-c.posx;
          ny = posy-c.posy;
          
        }
      }
    }
    nx/=100;
    ny/=100;
   brain.setinputs(new float[] {posx/250,posy/250,/*rx/250,ry/250,*/nx,ny}); 
    
   neuron[] outputlayer = brain.layers[brain.layers.length-1].neurons; 
   posx+=outputlayer[0].output*mm;
   posy+=outputlayer[1].output*mm;
   
  }
  
  void render(){
    colorMode(HSB,100,100,100);
    noStroke();
    fill(col,c2,c3);
    ellipse(centerx+posx,centery+posy,20,20);
  }
  
}

String namegen(){
  String[] conso = new String[]{"qu","wr","r","t","th","y","p","ph","pr","pl","s","st","sh","sq","sk","sn","sp","d","dr","fr","f","fl","g","gh","gl","h","j","k","kl","cl","c","l","z","v","b","br","n","m"};
  String[] vowel = new String[]{"a","e","i","o","u",};
  int cl = conso.length;
  int vl = vowel.length;
  String name = "";
  name+=conso[(int)(Math.random()*cl)];
  name+=vowel[(int)(Math.random()*vl)];
  name+=conso[(int)(Math.random()*cl)];
  name+=vowel[(int)(Math.random()*vl)];
  if (Math.random()<0.5){
  name+=conso[(int)(Math.random()*cl)];
  name+=vowel[(int)(Math.random()*vl)];
  }
  
  print(name);
  return name;
}
