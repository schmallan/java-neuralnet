ArrayList<int[]> foods = new ArrayList<>();

class creature {
  net brain;
  float posx;
  int size = 10;
  float posy;
  int col = 0;
  int c2;
  int c3;
  int health = 1000;
  String name;
  boolean dead = false;

  creature(int x, int y, int c, int c2uah, int c3ah) {
    posx = x;
    posy = y;
    col = c;
    rebrain();
    c2 = c2uah;
    c3 = c3ah;
  }

  creature(int x, int y, int c, int c2uah, int c3ah, String n) {
    posx = x;
    posy = y;
    col = c;
    name = n;
    c2 = c2uah;
    c3 = c3ah;
  }
  void reproduce() {

    creature offspring = new creature((int)posx, (int)posy, (int)((col+Math.random()-0.5)*1)%100, (int)((c2+Math.random()-0.5)*1)%100, (int)((c3+Math.random()-0.5)*1)%100, name + " jr");
    offspring.brain = brain.ncopy();
    net n = offspring.brain;
    for (layer l : n.layers) {
      print("[");
      if (l==null) {
        print("?");
      }
      print("]\n");
    }
    creatures.add(offspring);
  }

  void rebrain() {

    brain = new net(new int[]{4, 5, 4, 2},
      new String[]{"nearestX", "nearestY", "nearestppX", "nearestppY", },
      new String[]{"vX", "vY", }, 130, 250);
    name = namegen();
  }

  float mm = 5;
  void tick() {
    // if (health>3000) health*=0.97;
    health--;

    size = health/100;

    //EAT!!
    for (int i = 0; i<foods.size(); i++) {
      int[] c = foods.get(i);
      if (abs(posx-c[0])+abs(posy-c[1])<  size*1.5  ) {
        foods.remove(i);
        health+=555;
      }
    }

    int mx = (int)max(abs(posx), abs(posy));
    if (mx>arenasize || health<10) {
      dead = true;
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
    for (creature c : creatures) {
      if (c!=this) {
        float dx = c.posx-this.posx;
        float dy = c.posy-this.posy;
        int cont = (int)(abs(dx)+abs(dy));
        if (cont<cd) {
          pnx = dx;
          pny = dy;
        }
        if (cont<size) {
          int div = abs(col-c.col) + abs(c2-c.c2) + abs(c3-c.c3);
          if (div>20) {

            if (size<c.size) {
              this.health = 0;
            } else {
              if (this.health>0) {
                this.health+=555*(c.health/this.health);
              }
            }
          }
        }
      }
    }
    pnx/=100;
    pny/=100;

    // nx = (nx>0) ? 0 : 1;
    // ny = (ny>0) ? 0 : 1;




    brain.setinputs(new float[] {nx, ny, pnx, pny});

    neuron[] outputlayer = brain.layers[brain.layers.length-1].neurons;
    posx+=(outputlayer[0].output-0.5)*mm;
    posy+=(outputlayer[1].output-0.5)*mm;
  }

  void render() {
    noStroke();
    colorMode(HSB, 100, 100, 100);
    fill(col, c2, c3);
    ellipse(centerx+posx, centery+posy, size*2, size*2);
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

int[] rpos() {
  return new int[]{   (int)((Math.random()-0.5)*arenasize*2), (int)((Math.random()-0.5)*2*arenasize) };
}
