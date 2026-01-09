void setup(){
    colorMode(HSB,255,255,255);
    size(599,599);
}

    net myn = new net(new int[]{1,2,3,2,1},50,250,100,100,20);

void draw(){
    background(255);
    myn.render();
}