//Saves a creature as a file in the "critters" folder
void saveNet(creature myCreature) {
  PrintWriter fout = createWriter("critters/"+myCreature.name+myCreature.gen+".txt");
  fout.println("creatureType: "+myCreature.creatureType);
  fout.println("creatureName: "+myCreature.name);
  fout.println("generation: "+myCreature.gen);
  fout.println("score: "+myCreature.score);

  fout.print("netstructure: ");
  for (int n : myCreature.brain.layernc) {
    fout.print(n);
  }
  fout.println();
  net myNet = myCreature.brain;

  fout.print("inputlayer: ");
  for (String s : myCreature.brain.inpnames) {
    fout.print(s+" ");
  }
  fout.println("outlayer: ");
  for (String s : myCreature.brain.outnames) {
    fout.print(s+" ");
  }
  fout.println();

  for (int layerN = 0; layerN<myNet.numlayers; layerN++) {
    layer myLayer = myNet.layers[layerN];
    fout.print("biases: ");
    for (int i = 0; i<myLayer.neuroncount; i++) {
      fout.print(myLayer.neurons[i].bias+" ");
    }
    fout.println();
    if (layerN!=myNet.numlayers-1) {
      fout.println("weights:");
      for (int i = 0; i<myNet.weights[layerN].length; i++) {
        fout.print("------neuron"+i+": ");
        float[] nweights = myNet.weights[layerN][i];
        for (int j = 0; j<nweights.length; j++) {
          fout.print(nweights[j]);
          fout.print(" ");
        }
        fout.println();
      }
    }
  }


  fout.flush();
}

//Loads a creature from a file, returns creature
creature loadCreature(String infile) {
  String[] lines = loadStrings(infile);
  String type = parseData(lines[0])[0];
  String name = parseData(lines[1])[0];
  int gen = Integer.parseInt(parseData(lines[2])[0]);
  int score = Integer.parseInt(parseData(lines[3])[0]);
  int[] lnc = parseIntArray(parseData(lines[4]));
  String[] inNames = parseData(lines[5]);
  String[] outNames = parseData(lines[6]);
  int cfn = 7;

  creature ret = new creature();
  net brain;
  brain = new net(lnc, inNames, outNames, 130, 360);
  ret.brain = brain;
  for (int i = 0; i<lnc.length; i++) {
    layer corrLayer = brain.layers[i];
    float[] biases = parseFloatArray(parseData(lines[cfn]));
    cfn++;

    println("nc: "+corrLayer.neuroncount);
    for (int k = 0; k<corrLayer.neuroncount; k++) {
      neuron cn = corrLayer.neurons[k];
      cn.bias = biases[k];
    }

    if (i==lnc.length-1) continue;
    cfn++;
    float[][] cweights = brain.weights[i];
    for (int k = 0; k<cweights.length; k++) {
      cweights[k] = parseFloatArray(parseData(lines[cfn]));
      cfn++;
    }
  }

  return ret;
}

String[] parseData(String in) {
  println(in);
  String[] t = in.split(" ");
  return Arrays.copyOfRange(t, 1, t.length);
}
int[] parseIntArray(String[] in) {
  int[] ret = new int[in.length];
  for (int i = 0; i<in.length; i++) {
    int t = Integer.parseInt(in[i]);
    ret[i] = t;
  }
  return ret;
}
float[] parseFloatArray(String[] in) {
  float[] ret = new float[in.length];
  for (int i = 0; i<in.length; i++) {
    ret[i] = Float.parseFloat(in[i]);
  }
  return ret;
}
