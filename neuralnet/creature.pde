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