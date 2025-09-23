ArrayList<creature> creatures = new ArrayList<>();
int[] selected;

int simspeed = 1;
boolean paused = false;
int arenasize = 1000;
neuron selectedn;
int centerx;
int centery;
net selectednet;
creature selectedc = null;
float ratio = (float)arenasize/350;
ArrayList<int[]> foods = new ArrayList<>();
void setup() {
  namegen();
  size(1200, 600);
  
  fullScreen();

  centerx = width/2+200;
  centery = height/2;
  
  for (int i = 0; i<50; i++){
    cc();
  }
  
  selectedc=creatures.get(0);
  
  for (int i = 0; i<30; i++){
      foods.add(rpos());
  }
  
}

void cc(){
  
    colorMode(HSB,100,100,100);
    int col = (int) (Math.random()*100);
    int c2 = (int) (Math.random()*70+30);
    int c3 = (int) (Math.random()*30+70);
    
   creatures.add(new creature((int)((Math.random()-0.5)*arenasize*1.8),(int)((Math.random()-0.5)*arenasize*1.8),col,c2,c3)); 
}

void keyPressed(){
  if (key ==' '){
   paused = !paused; 
  }
  if (key ==']'){
   simspeed++;
  }
  if (key =='['){
   simspeed = max(1,--simspeed);
  }
  if (key =='n'){
   creatures = new ArrayList<>();
   cc();
  }
}
int f = 0;
int f2 = 0;

void draw(){
  if(!paused){
    for(int i = 0; i<simspeed; i++){
      supertick();
    }
  }
  rendertick();
  
  if (key=='s' & keyPressed) cc();

  
  renderninfo();
  
}

void rendertick(){
  
  background(#222222);
  rectMode(CENTER);
  noStroke();
  fill(#FFFFFF);
  rect(centerx,centery,arenasize*2/ratio,arenasize*2/ratio);
  selectedc.brain.render();
  for (int i = 0; i<creatures.size(); i++){
    creature c = creatures.get(i);
    c.render();
    //};
  }
 
  for (int i = 0; i<foods.size(); i++){
    int[] c = foods.get(i);
    fill(#FF00FF);
    ellipse(centerx+c[0]/ratio,centery+c[1]/ratio,5,5);
    
    //};
  }
  
}

void supertick(){
  f = (f+1)%10;
  f2 = (f2+1)%10; 
  
  if (f==0){
      for (int i = 0; i<3; i++){
      foods.add(rpos());
        
      }
  }
  
  if(f2==0) cc();
  
  
  for (int i = 0; i<creatures.size(); i++){
    creature c = creatures.get(i);
    c.brain.propagate();
    c.tick();
    if (c.dead) {creatures.remove(i); i--;}
    
    //};
  }
  
}

void renderninfo(){
  colorMode(RGB);
  strokeWeight(5);
    textSize(30);
    fill(255,255,255);
  text("simspeed: "+simspeed+( (paused)?" (paused)":"" ),100,50);
  if (selectedc==null) return;
  if (selectedc.dead) selectedc = creatures.get(0);
  
    int cs = 50;
  text(selectedc.name + " / hp:" + selectedc.health + " / age: "+selectedc.age,100,100);
  stroke(0,0,0);
  fill(0,0,0,0);
    ellipse(selectedc.posx/ratio+centerx, selectedc.posy/ratio+centery, cs, cs);
    stroke(255,0,0);
    strokeWeight(3);
    ellipse(selectedc.posx/ratio+centerx, selectedc.posy/ratio+centery, cs, cs);
   
    
  
  if (selectedn==null) return;
  if (selected==null) return;
    
  
    strokeWeight(5);
    stroke(255, 255, 0);
    fill(0,0,0,100);
    ellipse(selectedn.xpos, selectedn.ypos, circlesize, circlesize);
    fill(0,0,0,0);
    textSize(20);
    String m = "";
    m+= "Layer: "; m+=selected[0];
    m+= "   Neuron no."; m+=selected[1];
    m+= "\nBias: "; m+= selectedn.bias;
    
    m+= "\nWeighted Sum: "; m+= selectedn.wsum;
    m+= "\nWeights:\n";
    if (selected[0]==0){
      m+="N/A (Input Neuron) \n";
    }else{
     float[] pl = selectednet.weights[selected[0]-1][selected[1]];
     int i = 0;
     for (float w : pl){
       m+= "n" + i + ": " + w + " * ";
       m+=selectednet.layers[selected[0]-1].neurons[i].output + "\n";
       i++;
     }
    }
    
    m+= "Output: " + selectedn.output;
    fill(#FFFFFF);
    text(m , 50, selectednet.ypos+150);
  
}

void mousePressed() {
  for (creature c: creatures){
    float d = sqrt(pow(((mouseX-c.posx/ratio)-centerx),2)+pow(((mouseY-c.posy/ratio)-centery),2));
    if (d<20) selectedc = c;
    
    net n = selectedc.brain;
    
    selected = n.checkmouse(mouseX, mouseY);
    
    if (selected!=null){
      selectedn = n.layers[selected[0]].neurons[selected[1]];
      selectednet=n;
      return;
    }
    
  }
  
  
}
