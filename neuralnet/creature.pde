class creature {
  String creatureType = "null";
  net brain = null;
  float posx = 0;
  float posy = 0;
  boolean dead = false;
  int health = 10;
  int score = 0;
  String name = "null";
  int gen = 0;
  int age = 0;

  int getScore(){return score;};
  void tick(){};
  void render(){};

}

creature loadCreature(String infile){
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
  brain = new net(lnc,inNames,outNames,130,360);
  ret.brain = brain;
  for (int i = 0; i<lnc.length; i++){
    layer corrLayer = brain.layers[i];
    float[] biases = parseFloatArray(parseData(lines[cfn])); cfn++;

    for (int k = 0; k<corrLayer.neuroncount; k++){
      neuron cn = corrLayer.neurons[k];
      cn.bias = biases[k];
    }

    if (i==lnc.length-1) continue;
    cfn++;
    float[][] cweights = brain.weights[i];
    for (int k = 0; k<cweights.length; k++){
      cweights[k] = parseFloatArray(parseData(lines[cfn])); cfn++;
    }
  }
  
  return ret;
}

String[] parseData(String in){
  println(in);
  String[] t = in.split(" ");
  return Arrays.copyOfRange(t,1,t.length);
}

int[] parseIntArray(String[] in){
  int[] ret = new int[in.length];
  for (int i = 0; i<in.length; i++){
    int t = Integer.parseInt(in[i]);
    ret[i] = t;
  }
  return ret;
}
float[] parseFloatArray(String[] in){
  float[] ret = new float[in.length];
  for (int i = 0; i<in.length; i++){
    ret[i] = Float.parseFloat(in[i]);
  }
  return ret;
}