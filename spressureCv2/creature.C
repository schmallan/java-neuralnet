#include "neural.h"
#include "headers.h"

int crc = 0;
creature myCreatures[numCreatures];

void spawnCreature(){
    creature myCreature;
    setupNet(&myCreature.brain);
    myCreature.x=0;
    myCreature.y=0;
    myCreature.ang=0;
    myCreatures[crc] = myCreature;
    crc++;
}

void renderCreature(creature *mycreature){
    float x = mycreature->x;
    float y = mycreature->y;

    float ang = mycreature->ang;

    fill(0,0,0);
    float size = 30;
    float tailsize = 20;
    float front[2];
    angle2Vector(front,ang,size);
    front[0]+=x;
    front[1]+=y;
    
    float left[2];
    angle2Vector(left,ang-2.5,tailsize);
    left[0]+=x;
    left[1]+=y;
    
    float right[2];
    angle2Vector(right,ang+2.5,tailsize);
    right[0]+=x;
    right[1]+=y;
    
    

    SDL_Vertex vl;
    SDL_Vertex vr;
    SDL_Vertex vf;
    SDL_Vertex vc;
    
    vl.position.x = left[0];
    vl.position.y = left[1];
    vf.position.x = front[0];
    vf.position.y = front[1];
    vr.position.x = right[0];
    vr.position.y = right[1];
    vc.position.x = x;
    vc.position.y = y;
    
    
    

    fill(255,0,0);

    SDL_Vertex myv[3];
    myv[0] = vf;
    myv[1] = vl;
    myv[2] = vc;
    worldTriangle(myv);
    myv[0] = vf;
    myv[1] = vr;
    myv[2] = vc;
    worldTriangle(myv);

}

void tickCreature(creature *mycreature){

    neuralNet *brain = &mycreature->brain;
    float *in = brain->outputs[0];
    float *out = brain->outputs[layers-1];
    in[0] = mycreature->x/borderSize;
    in[1] = mycreature->y/borderSize;
    

    propagateNet(brain);

    float mv = out[0];
    mycreature->ang += (mv-0.5)/100;
    float xy[2];
    angle2Vector(xy,mycreature->ang,0.1);
    mycreature->x+=xy[0];
    mycreature->y+=xy[1];
    
    
}