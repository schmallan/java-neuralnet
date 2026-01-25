

class critter extends creature {

  int hatch = 300;
  int size = 15;
  int col = 0;
  int c2;
  int c3;

  float adjr(float m){
    return (float) (Math.random()-0.5)*m;
  }

  critter(int x, int y, int c, int c2uah, int c3ah) {
    dead = false;
    posx = x;
    posy = y;
    col = c;
    rebrain();
    c2 = c2uah;
    c3 = c3ah;
  }

  critter(int x, int y, int c, int c2uah, int c3ah, String n, int s, int g) {
    dead = false;
    posx = x;
    posy = y;
    col = c;
    name = n;
    c2 = c2uah;
    c3 = c3ah;
    health = s;
    gen = g;
  }
  void reproduce() {
    int bhealth = (int)( health*0.2);
    health-=bhealth;
    //if (bhealth<hatch*3+1300) return;
    critter offspring = new critter((int)(posx + random(-15,15)), (int)(posy + random(-15,15)), (int)((col+Math.random()-0.5)*1)%100, (int)((c2+Math.random()-0.5)*1)%100, (int)((c3+Math.random()-0.5)*1)%100, name,(int)bhealth,gen+1);
    offspring.brain = brain.ncopy();
  //  creatures.add(offspring); 
  }


  void rebrain() {
    println("braind");
    brain = new net(new int[]{5, 3},
      new String[]{"nearestX", "nearestY", "nearestppX", "nearestppY", "health"},
      new String[]{"vX", "vY", "reproduce"}, 130, 360);
    name = namegen();
  }

  float mm = 10;
  void tick() {
    if (hatch==0) brain.propagate();

    age++;
    if (age>10000) dead = true;
    
    int mx = (int)max(abs(posx), abs(posy));
    if (health<10) {
      dead = true;
    }
    if (mx>worldSize){
      dead = true;
      /*
      posx = max(posx,-worldSize);
      posy = max(posy,-worldSize);
      posx = min(posx,worldSize);
      posy = min(posy,worldSize);
    */  
    }

    if (dead) return;

    if (hatch>0) {hatch-=1; return;}
    //if (health>3000) health*=0.996;

    health-=1;
    //size = (int)sqrt(health/3);

    //EAT!!
    for (int i = 0; i<foods.size(); i++) {
      int[] c = foods.get(i);
      if (abs(posx-c[0])+abs(posy-c[1])<  size  ) {
        foods.remove(i);
        health+=555;
      }
    }

    float nx = 0;
    float ny = 0;
    int cd = 9999;
    for (int[] f : foods) {

      int cont = (int)( abs(posx-f[0])+abs(posy-f[1]) );
      if (cont<cd) {
        cd=cont;
        nx = posx-f[0];
        ny = posy-f[1];
      }
    }
    nx/=100;
    ny/=100;

    float pnx = 0;
    float pny = 0;
    int pcd = 9999;
    for (creature d : creatures) {
      critter c = (critter)d;

      if (c!=this & !(c.hatch>0)) {
        float dx = c.posx-this.posx;
        float dy = c.posy-this.posy;
        int cont = (int)(abs(dx)+abs(dy));
        if (cont<pcd) {
          pnx = dx;
          pny = dy;
        }
        if (cont<size) {
          int div = abs(col-c.col) + abs(c2-c.c2) + abs(c3-c.c3);
          if (div>20) {
            if (size>c.size){
              c.dead = true;
              c.health=0;
              if (this.health>0) {
                this.health+=c.health;
              }
            }
          }
        }
      }
        
    }
    pnx/=1000;
    pny/=1000;





    brain.setinputs(new float[] {nx, ny, pnx, pny, log(health)/10-0.5});

    neuron[] outputlayer = brain.layers[brain.layers.length-1].neurons;
    posx+=(outputlayer[0].output-0.5)*mm;
    posy+=(outputlayer[1].output-0.5)*mm;
    if (outputlayer[2].output > 0.5){
      reproduce();
    }
  }

  void render() {
    noStroke();
    colorMode(HSB, 100, 100, 100);
    fill(col, c2, c3);
    if (hatch>0){
      
    ellipse(centerX+posx/ratio, centerY+posy/ratio, size/ratio, size/ratio);
      return;
    }
    ellipse(centerX+posx/ratio, centerY+posy/ratio, size*2/ratio, size*2/ratio);
  }
}

String namegen() {
  String[] conso = new String[]{"qu", "wr", "r", "t", "th", "y", "p", "ph", "pr", "pl", "s", "st", "sh", "sq", "sk", "sn", "sp", "d", "dr", "fr", "f", "fl", "g", "gh", "gl", "h", "j", "k", "kl", "cl", "c", "l", "z", "v", "b", "br", "n", "m", "skibid"};
  String[] vowel = new String[]{"a", "e", "i", "o", "u", };
  int cl = conso.length;
  int vl = vowel.length;
  String name = "";
  name+=conso[(int)(Math.random()*cl)];
  name+=vowel[(int)(Math.random()*vl)];
  name+=conso[(int)(Math.random()*cl)];
  name+=vowel[(int)(Math.random()*vl)];
  if (Math.random()<0.5) {
    name+=conso[(int)(Math.random()*cl)];
    name+=vowel[(int)(Math.random()*vl)];
  }

  return name;
}
float dd = 1.5;
int[] rpos() {
  return new int[]{   (int)((Math.random()-0.5)*worldSize*dd), (int)((Math.random()-0.5)*worldSize*dd) };
}
