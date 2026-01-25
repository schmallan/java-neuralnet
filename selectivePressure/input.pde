
int currentCreatureNum = 0;
void keyPressed() {

  //adjust simspeed according to number keys
  if (keyCode>=48 && keyCode<=58) {
    int mm = keyCode-49;
    if (mm==-1) mm+=10;
    int[] simSpeeds = new int[]{1, 2, 10, 50, 300, 1000, 2000, 5000, 10000, 20000};
    simSpeed = simSpeeds[mm];
  }

  switch (keyCode) {
    case (DELETE): //delete a creature
    if (selectedCreature!=null) {
      creatures.remove(selectedCreature);
      selectedCreature=null;
    }
    break;

    case (TAB): //cycle to viewing next creature
    if (creatures.size()!=0) {
      currentCreatureNum=(currentCreatureNum+1)%creatures.size();
      selectedCreature=creatures.get(currentCreatureNum);
    }
    break;
  }

  switch (key) {
    case ('t'):
    getTop();
    break;
    case ('a'):
    alwaysShowTop=!alwaysShowTop;
    break;
    case ('r'):
    reColor();
    break;
    case (' '):
    isPaused = !isPaused;
    break;
    case ('n'):
    creatures = new ArrayList<>();
    spawnCreature();
    break;
    case ('l'):
    creature load = loadCreature("critters/ghusti15684.txt");
    creature n = spawnCreature();
    n.brain = load.brain;
    break;
  }
}

//selects the creature that you clicked on.
void mousePressed() {
  for (arrow c : creatures) {
    float d = sqrt(pow(((mouseX-c.posx/ratio)-centerX), 2)+pow(((mouseY-c.posy/ratio)-centerY), 2));
    if (d<20) selectedCreature = c;
    if (selectedCreature==null) return;
    net n = selectedCreature.brain;

    selectedNeuronIndex = n.checkmouse(mouseX, mouseY);

    if (selectedNeuronIndex!=null) {
      selectedn = n.layers[selectedNeuronIndex[0]].neurons[selectedNeuronIndex[1]];
      selectedNet=n;
      return;
    }
  }
}

