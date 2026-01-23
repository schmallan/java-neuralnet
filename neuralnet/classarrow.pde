class arrow extends creature{

    int foodsEaten = 0;
    float rot = 0;
    float size = 20;
    arrow(int x, int y, int c){
      creatureType = "arrow";
        health = 10000;
        posx = x;
        posy = y;
        rebrain();
        col = c;
    }

    void rebrain(){
        name = namegen();
        brain = new net(new int[]{4,5,2},new String[]{"nx","ny","rot","healthLeft"},new String[]{"angleMov","movSpeed"}, 130, 360);
    }


  arrow reproduce() {
    //if (bhealth<hatch*3+1300) return;
    arrow offspring = new arrow((int)(posx + random(-35,35)), (int)(posy + random(-35,35)),col);
    offspring.name = name;
    offspring.gen = gen+1;
    offspring.brain = brain.ncopy();
    return (offspring); 
  }

  void tick(){
    rot+=2*PI;
    age++;
    rot = rot%(PI+PI);
    //println(rot);

    if (health<=0){
      size = 5;
      return;
    }
    //if (health<=0){
      //  dead = true;
       // for (int i= 0; i<foodsEaten/2; i++){
       //   reproduce();
      //  }
       // return;
    //}

    if (max(abs(posx),abs(posy))>worldSize){posx=0; posy=0; score-=5;};


    //if (health>3000){
      //  health = 2000;
      //  reproduce();
    //}
    
    for (int i = 0; i<foods.size(); i++) {
      int[] c = foods.get(i);
      if (abs(posx-c[0])+abs(posy-c[1])<  size  ) {
        foods.remove(i);
        score++;
       // foodsEaten+=1;
      //  health+=455;
       // reproduce();
      }
    }


    float nx = 0;
    float ny = 0;
    int cd = 9999999;
    for (int[] f : foods) {

      int cont = (int)( abs(posx-f[0])+abs(posy-f[1]) );
      if (cont<cd) {
        cd=cont;
        nx = posx-f[0];
        ny = posy-f[1];
        if (cont<100){
           // break;
        }
       // break;
      }
    }
    nx/=30;
    ny/=30;

   // nx+=0.5;
   // ny+=0.5;
   // if (nx<0) nx= 0;
   // if (ny<0) ny= 0;
   // if (nx>1) nx= 1;
   // if (ny>1) ny= 1;
    
    rot = (rot+PI*2)%(PI*2);

    //float x = (atan2(ny,nx));
   // x/=(PI*2);
    //x-=rot;
   // rot =x+PI;

    //x+=0.5;

      brain.setinputs(new float[]{nx,ny,rot/PI/2,health/10000});
    brain.propagate();
    neuron[] outputlayer = brain.layers[brain.layers.length-1].neurons;
  
    float op = (outputlayer[0].output-0.5);
    rot+=op;
    health-=op*op*10;
    //rot=(outputlayer[0].output)*2*PI;
    

    float pedal = outputlayer[1].output*5;
    health-=pedal*pedal;
    //pedal = 1;
    posx+=cos(rot)*pedal;
    posy+=sin(rot)*pedal;
    

  //  health-=1;
  }
  void render(){
    noStroke();
    fill(col);
    
    beginShape();
    vertTheta(rot+0,size);
    vertTheta(rot+PI+0.7,size);
    vertTheta(rot+PI,size/2);
    vertTheta(rot+PI-0.7,size);
    
    endShape();
  }

  void vertTheta(float theta,float len){
    float x = (cos(theta)*len+posx)/ratio+centerX;
    float y = (sin(theta)*len+posy)/ratio+centerY;
    vertex(x,y);
  }
}
