ArrayList<int[]> foods = new ArrayList<>();

class creature{
  net brain;
  float posx;
  int size = 10;
  float posy;
  int col = 0;
  int health = 2000;
  String name;
  boolean dead = false;
  
  creature(int x, int y,int c){
    posx = x;
    posy = y;
    rebrain();
    col = c;
  }
  
  void reproduce(){
   creature offspring = new creature((int)posx,(int)posy,col); 
   creatures.add(offspring);
  }
  
  void rebrain(){
    
    brain = new net(new int[]{4,4,4,2},
                new String[]{"nearestX+","nearestX-","nearestY+","nearestY-",}, 
                new String[]{"vX","vY",},100,250); 
    name = namegen();
  }
  
  float mm = 5;
  void tick(){
    health--;
   
   //EAT!!
   for (int i = 0; i<foods.size(); i++){
    int[] c = foods.get(i);
    if (abs(posx-c[0])+abs(posy-c[1])<  size*1.5  ){
      foods.set(i,rpos());
      health+=555;
      
      creature baby = new creature((int)posx,(int)posy,col);
      creatures.add(baby);
      net bc = brain.ncopy();
      for (int i2 = 0; i2<bc.layers.size(); i2++){
       println("a"); 
      }
    }
  }
   
    int mx = (int)max(abs(posx),abs(posy));
    if (mx>arenasize || health<0){ 
      dead = true;
      
    }
    float nx = 0;
    float ny = 0;
    int cd = 9999;
    for (int[] f:foods){
      
        int cont = (int)sqrt(pow((posx-f[0]),2)+pow((posy-f[1]),2));
        if (cont<cd){
          cd=cont;
          nx = posx-f[0];
          ny = posy-f[1];
          
        }
      
    }
    nx/=100;
    ny/=100;
     
    float pnx = Math.max(0,nx);
    float pny = Math.max(0,ny);
    float nnx = abs(Math.min(0,nx));
    float nny = abs(Math.min(0,ny));
    
    
    
   brain.setinputs(new float[] {pnx,nnx,pny,nny}); 
    
   neuron[] outputlayer = brain.layers[brain.layers.length-1].neurons; 
   posx+=(outputlayer[0].output-0.5)*mm;
   posy+=(outputlayer[1].output-0.5)*mm;
   
  }
  
  void render(){
    noStroke();
    fill(col);
    ellipse(centerx+posx,centery+posy,size*2,size*2);
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

int[] rpos(){
  return new int[]{   (int)((Math.random()-0.5)*arenasize*2),(int)((Math.random()-0.5)*2*arenasize) };
}
