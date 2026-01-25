void renderTick() {
  if (alwaysShowTop) {
    getTop();
  }

  background(#222222);

  fill(255);

  rectMode(CENTER);
  noStroke();
  fill(#FFFFFF);
  rect(centerX, centerY, worldSize*2/ratio, worldSize*2/ratio);
  if (selectedCreature!=null) {
    selectedCreature.brain.render();
  }
  for (int i = 0; i<creatures.size(); i++) {
    creature c = creatures.get(i);
    c.render();
    //};
  }

  for (int i = 0; i<foods.size(); i++) {
    int[] c = foods.get(i);
    fill(#FF00FF);
    rect(centerX+c[0]/ratio, centerY+c[1]/ratio, 3, 3);

    //};
  }
}

void renderNetInfo() { //renders information about the brain of selected creature
  colorMode(RGB);
  strokeWeight(5);
  textSize(30);


  fill(255);
  text("GENERATION: "+genNum+" time: "+(genTime-currentTime), 500, 50);

  fill(255);
  text("simSpeed: "+simSpeed+( (isPaused)?" (isPaused)":"" ), 100, 50);

  if (selectedCreature==null) return;

  showLeaderboard();

  textSize(30);

  int cs = 50;
  text(selectedCreature.name + "\n gen:"+selectedCreature.gen+" hp:" + selectedCreature.health + " \n age: "+selectedCreature.age+ " \n score: "+selectedCreature.score, 100, 100);
  stroke(0, 0, 0);
  fill(0, 0, 0, 0);
  ellipse(selectedCreature.posx/ratio+centerX, selectedCreature.posy/ratio+centerY, cs, cs);
  stroke(255, 0, 0);
  strokeWeight(3);
  ellipse(selectedCreature.posx/ratio+centerX, selectedCreature.posy/ratio+centerY, cs, cs);



  if (selectedn==null) return;
  if (selectedNeuronIndex==null) return;


  strokeWeight(5);
  stroke(255, 255, 0);
  fill(0, 0, 0, 100);
  ellipse(selectedn.xpos, selectedn.ypos, circlesize, circlesize);
  fill(0, 0, 0, 0);
  textSize(20);
  String m = "";
  m+= "Layer: ";
  m+=selectedNeuronIndex[0];
  m+= "   Neuron no.";
  m+=selectedNeuronIndex[1];
  m+= "\nBias: ";
  m+= selectedn.bias;

  m+= "\nWeighted Sum: ";
  m+= selectedn.wsum;
  m+= "\nWeights:\n";
  if (selectedNeuronIndex[0]==0) {
    m+="N/A (Input Neuron) \n";
  } else {
    float[] pl = selectedNet.weights[selectedNeuronIndex[0]-1][selectedNeuronIndex[1]];
    int i = 0;
    for (float w : pl) {
      m+= "n" + i + ": " + w + " * ";
      m+=selectedNet.layers[selectedNeuronIndex[0]-1].neurons[i].output + "\n";
      i++;
    }
  }

  m+= "Output: " + selectedn.output;
  fill(#FFFFFF);
  text(m, 50, selectedNet.ypos+150);
}

void showLeaderboard() {
  fill(255);
  creatures.sort(Collections.reverseOrder(Comparator.comparing(creature::getScore)));
  textSize(10);
  String leaderboard = "";
  for (int i = 0; i<10; i++) {
    if (i>=creatures.size()) break;
    creature c = creatures.get(i);
    leaderboard+="\n"+i+": "+c.name + " - "+c.score;
  }
  text(leaderboard, 30, 100);
}

