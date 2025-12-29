

class arrow extends creature{

    float rot = 0;
    float size = 25;
    int col = 0;
    arrow(int x, int y, int c){
        health = 1000;
        posx = x;
        posy = y;
        rebrain();
        col = c;
    }

    void rebrain(){
        name = namegen();
        brain = new net(new int[]{2,3,2},new String[]{"nx","ny"},new String[]{"angleMov","velocMov"}, 130, 360);
    }

  void reproduce() {
    //if (bhealth<hatch*3+1300) return;
    arrow offspring = new arrow((int)(posx + random(-15,15)), (int)(posy + random(-15,15)),col);
    offspring.brain = brain.ncopy();
    creatures.add(offspring); 
  }

  void tick(){
    rot+=2*PI;
    age++;
    rot = rot%(PI+PI);
    //println(rot);

    if (health==0){
        dead = true;
        return;
    }



    if (health>3000){
        health = 2000;
        reproduce();
    }
    
    for (int i = 0; i<foods.size(); i++) {
      int[] c = foods.get(i);
      if (abs(posx-c[0])+abs(posy-c[1])<  size  ) {
        foods.remove(i);
        health+=555;
      }
    }


    float nx = 0;
    float ny = 0;
    int cd = 99999;
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

    nx+=0.5;
    ny+=0.5;
    if (nx<0) nx= 0;
    if (ny<0) ny= 0;
    if (nx>1) nx= 1;
    if (ny>1) ny= 1;
    
    //x = (atan2(ny,nx));

      brain.setinputs(new float[]{nx,ny});
    brain.propagate();
    neuron[] outputlayer = brain.layers[brain.layers.length-1].neurons;
  
    
    rot=(outputlayer[0].output)*PI*2;
    
    float pedal = outputlayer[1].output*3;
    posx+=cos(rot)*pedal;
    posy+=sin(rot)*pedal;
    

    health-=1;
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