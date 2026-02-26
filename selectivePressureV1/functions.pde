
int randCol() {

  colorMode(HSB, 100, 100, 100);
  int col = (int) (Math.random()*100);
  int c2 = (int) (Math.random()*70+30);
  int c3 = (int) (Math.random()*30+70);

  colorMode(HSB, 100, 100, 100);
  return color (col, c2, c3);
}

creature spawnCreature() {

  int myc = randCol();

  arrow res = (new arrow((int)((Math.random()-0.5)*worldSize*1.8), (int)((Math.random()-0.5)*worldSize*1.8), myc));
  //  critter john = new critter((int)((Math.random()-0.5)*worldSize*1.8),(int)((Math.random()-0.5)*worldSize*1.8),col,c2,c3);

  creatures.add(res);
  return res;
}

boolean alwaysShowTop = false;
void getTop() {
  if (creatures.size()!=0) {
    currentCreatureNum=0;
    selectedCreature=creatures.get(currentCreatureNum);
  }
}

void reColor() {
  for (creature c : creatures) {
    c.col = randCol();
  }
}
