void setup(){
    size(599,599);
}

void draw(){
    background(255);
    net myn = new net(new int[]{1,2,3,2,1},50,250,100,100,20);
    myn.render();
}