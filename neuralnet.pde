ArrayList<creature> creatures = new ArrayList<>();
int[] selected;
neuron selectedn;
int centerx;
int centery;
net selectednet;
creature selectedc = null;
void setup() {
  namegen();
  size(1000, 800);
  //fullScreen();

  centerx = width/2+130;
  centery = height/2;
  
  for (int i = 0; i<50; i++){
   creatures.add(new creature(i,0)); 
  }
  
  selectedc=creatures.get(0);
  
}

void keyPressed(){
  
}

void draw(){
  
  
  
  background(#222222);
  rectMode(CENTER);
  noStroke();
  fill(#FFFFFF);
  rect(centerx,centery,500,500);
 
  selectedc.brain.render();
  for (creature c : creatures){
    c.brain.propagate();
    c.render();
    //if (keyPressed){
    c.tick();
    //};
  }
  
  renderninfo();
  
}

void renderninfo(){
  colorMode(RGB);
  strokeWeight(5);
  if (selectedc==null) return;
  
    int cs = 50;
    textSize(30);
    fill(255,255,255);
  text(selectedc.name,100,50);
  stroke(0,0,0);
  fill(0,0,0,0);
    ellipse(selectedc.posx+centerx, selectedc.posy+centery, cs, cs);
    stroke(255,0,0);
    strokeWeight(3);
    ellipse(selectedc.posx+centerx, selectedc.posy+centery, cs, cs);
    
  
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
    float d = sqrt(pow((mouseX-c.posx-centerx),2)+pow((mouseY-c.posy-centery),2));
    if (d<20) selectedc = c;
    net n = c.brain;
    selected = n.checkmouse(mouseX, mouseY);
    if (selected!=null){
      selectedn = n.layers[selected[0]].neurons[selected[1]];
      selectednet=n;
      return;
    }
  }
  
  
}
