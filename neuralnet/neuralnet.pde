import java.util.Collections;
import java.util.ArrayList;
import java.util.Comparator;
ArrayList<arrow> creatures = new ArrayList<>();

int[] selected;

int simSpeed = 1;
boolean isPaused = false;
int worldSize = 800;
neuron selectedn;
int centerX;
int centerY;
net selectedNet;
arrow selectedCreature = null;
float ratio = (float)worldSize/350;
ArrayList<int[]> foods = new ArrayList<>();
void setup() {
  namegen();
  size(1200, 600);
  
  fullScreen();

  centerX = width/2+200;
  centerY = height/2;
  
  for (int i = 0; i<20; i++){
    spawnCreature();
  }
  
  selectedCreature=creatures.get(0);
  
  for (int i = 0; i<30; i++){
      foods.add(rpos());
  }
  
}

void spawnCreature(){
  
    colorMode(HSB,100,100,100);
    int col = (int) (Math.random()*100);
    int c2 = (int) (Math.random()*70+30);
    int c3 = (int) (Math.random()*30+70);
    
    colorMode(HSB, 100, 100, 100);
    int myc = color(col, c2, c3);

    creatures.add(new arrow((int)((Math.random()-0.5)*worldSize*1.8),(int)((Math.random()-0.5)*worldSize*1.8),myc));
 //  critter john = new critter((int)((Math.random()-0.5)*worldSize*1.8),(int)((Math.random()-0.5)*worldSize*1.8),col,c2,c3);
 
   //creatures.add(john);
}

int curc = 0;
void keyPressed(){
  print(keyCode);
  if (keyCode>=49 && keyCode<=57){
    int mm = keyCode-49;
    switch (mm){
      case (0):
        simSpeed = 1;
        break;
      case (1):
        simSpeed = 2;
        break;
      case (2):
        simSpeed = 5;
        break;
      case (3):
        simSpeed = 10;
        break;
      case (4):
        simSpeed = 20;
        break;
      case (5):
        simSpeed = 50;
        break;
      case (6):
        simSpeed = 500;
        break;
      case (7):
        simSpeed = 1000;
        break;
      case (8):
        simSpeed = 2000;
        break;
      
        
        
    }
  }
  if (keyCode==9){
    curc=(curc+1)%creatures.size();
    selectedCreature=creatures.get(curc);
  }
  if (key ==' '){
   isPaused = !isPaused; 
  }
  if (key ==']'){
   simSpeed++;
  }
  if (key =='['){
   simSpeed = max(1,--simSpeed);
  }
  if (key =='n'){
   creatures = new ArrayList<>();
   spawnCreature();
  }
  if (key =='s'){
   saveNet(selectedCreature);
  }
}

int f = 0; int f2 = 0;
void draw(){


  if(!isPaused){
    for(int i = 0; i<simSpeed; i++){
      simulationTick();
    }
  }

  renderTick();
  renderNetInfo();
  

}



void renderTick(){
  
  background(#222222);

  fill(255);

  rectMode(CENTER);
  noStroke();
  fill(#FFFFFF);
  rect(centerX,centerY,worldSize*2/ratio,worldSize*2/ratio);
  selectedCreature.brain.render();
  for (int i = 0; i<creatures.size(); i++){
    creature c = creatures.get(i);
    c.render();
    //};
  }
 
  for (int i = 0; i<foods.size(); i++){
    int[] c = foods.get(i);
    fill(#FF00FF);
    rect(centerX+c[0]/ratio,centerY+c[1]/ratio,3,3);
    
    //};
  }

  fill(255);
  text("GENERATION: "+genNum+" time: "+(genTime-g),500,50);
  
}

void newGen(){
  genNum++;

  creatures.sort(Collections.reverseOrder(Comparator.comparing(creature::getScore)));
  ArrayList<arrow> temp = new ArrayList<>();

  for (int i = 0; i<10; i++){
    if (creatures.size()<=i) continue;
    arrow c = creatures.get(i);
    temp.add(c.reproduce());
    temp.add(c.reproduce());
  }
  for (int i = 10; i<20; i++){
    if (creatures.size()<=i) continue;
    arrow c = creatures.get(i);
    temp.add(c.reproduce());
  }
  creatures = temp;
  println(creatures.size());
  while (creatures.size()<40){
    spawnCreature();
  }


}

int genNum = 0;
int genTime = 2000;
int g = 0;
void simulationTick(){
  f = (f+1)%30;
  f2 = (f2+1)%50; 
  g = (g+1)%genTime;
  if (g==0){
    newGen();
  }
  
  if (f==0 & foods.size()<100){
    
      for (int i = 0; i<3; i++){
      foods.add(rpos());
        
      }
  }

 // if (creatures.size()<50) spawnCreature();
  
  //if(f2==0) spawnCreature();
  
  
  for (int i = 0; i<creatures.size(); i++){
    creature c = creatures.get(i);

    //println(c.name);
    
    //  print(c.dead);
    c.tick();
    if (c.dead) {
   //   println(c.dead);
      creatures.remove(i); i--;}
    
    //};
  }
  
}

void renderNetInfo(){

  colorMode(RGB);
  strokeWeight(5);
    textSize(30);
    fill(255,255,255);
  text("simSpeed: "+simSpeed+( (isPaused)?" (isPaused)":"" ),100,50);
  if (selectedCreature==null) return;
  if (selectedCreature.dead) selectedCreature = creatures.get(0);
  
  creatures.sort(Collections.reverseOrder(Comparator.comparing(creature::getScore)));

    textSize(10);
    String leaderboard = "";
    for (int i = 0; i<10; i++){
      creature c = creatures.get(i);
      leaderboard+="\n"+i+": "+c.name + " - "+c.score;
    }
    text(leaderboard,30,100);

    textSize(30);

    int cs = 50;
  text(selectedCreature.name + "\n gen:"+selectedCreature.gen+" hp:" + selectedCreature.health + " \n age: "+selectedCreature.age+ " \n score: "+selectedCreature.score,100,100);
  stroke(0,0,0);
  fill(0,0,0,0);
    ellipse(selectedCreature.posx/ratio+centerX, selectedCreature.posy/ratio+centerY, cs, cs);
    stroke(255,0,0);
    strokeWeight(3);
    ellipse(selectedCreature.posx/ratio+centerX, selectedCreature.posy/ratio+centerY, cs, cs);
   
    
  
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
     float[] pl = selectedNet.weights[selected[0]-1][selected[1]];
     int i = 0;
     for (float w : pl){
       m+= "n" + i + ": " + w + " * ";
       m+=selectedNet.layers[selected[0]-1].neurons[i].output + "\n";
       i++;
     }
    }
    
    m+= "Output: " + selectedn.output;
    fill(#FFFFFF);
    text(m , 50, selectedNet.ypos+150);
  
  }

void mousePressed() {
  for (arrow c: creatures){
    float d = sqrt(pow(((mouseX-c.posx/ratio)-centerX),2)+pow(((mouseY-c.posy/ratio)-centerY),2));
    if (d<20) selectedCreature = c;
    
    net n = selectedCreature.brain;
    
    selected = n.checkmouse(mouseX, mouseY);
    
    if (selected!=null){
      selectedn = n.layers[selected[0]].neurons[selected[1]];
      selectedNet=n;
      return;
    }
    
  }
  
  
}
