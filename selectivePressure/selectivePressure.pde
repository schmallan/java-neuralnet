import java.util.Collections;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Arrays;

ArrayList<arrow> creatures = new ArrayList<>();

arrow selectedCreature = null;
net selectedNet;
int[] selectedNeuronIndex;
neuron selectedn;

int simSpeed = 1;
boolean isPaused = false;
int worldSize = 800;
int centerX;
int centerY;
float ratio = (float)worldSize/350;

ArrayList<int[]> foods = new ArrayList<>();
void setup() {
  namegen();
  size(1200, 600);

  fullScreen();

  centerX = width/2+200;
  centerY = height/2;

  for (int i = 0; i<30; i++) {
    foods.add(rpos());
  }
  while (creatures.size()<30) {
    spawnCreature();
  }
}

void draw() {

  if (!isPaused) {
    for (int i = 0; i<simSpeed; i++) {
      simulationTick();
    }
  }

  renderTick();
  renderNetInfo();
}



//spawns new generation
void newGen() {
  genNum++;

  //sort by biggest score
  creatures.sort(Collections.reverseOrder(Comparator.comparing(creature::getScore)));
  ArrayList<arrow> temp = new ArrayList<>();

  int bracket1 = 10; //creatures in first bracket survive & reproduce
  int bracket2 = 5; //creatures in second bracket survive
  //everyone else dies.

  for (int i = 0; i<bracket1; i++) {
    if (creatures.size()<=i) continue;
    arrow c = creatures.get(i);
    temp.add(c.reproduce());
    temp.add(c.reproduce());
  }
  for (int i = bracket1; i<bracket1+bracket2; i++) {
    if (creatures.size()<=i) continue;
    arrow c = creatures.get(i);
    temp.add(c.reproduce());
  }
  creatures = temp;
  //println(creatures.size());
}

int genNum = 0;
int genTime = 2000;
int currentTime = 0;
void simulationTick() {
  currentTime = (currentTime+1)%genTime;
  if (currentTime==0) {
    newGen();
  }

  for (int i = 0; i<creatures.size(); i++) {
    creature c = creatures.get(i);
    c.tick();
    if (c.dead){  creatures.remove(i);  i--;  }
  }
}


