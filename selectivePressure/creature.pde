class creature {
  String creatureType = "null";
  net brain = null;
  float posx = 0;
  float posy = 0;
  int col = 0;
  boolean dead = false;
  float health = 10;
  int score = 0;
  String name = "null";
  int gen = 0;
  int age = 0;

  int getScore(){return score;};
  void tick(){};
  void render(){};

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