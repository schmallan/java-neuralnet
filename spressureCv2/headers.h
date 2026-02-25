#include <SDL3/SDL.h>
#include <stdio.h>
#include <stdlib.h>

extern int selectedNeuron[4];
extern int screenHeight;
extern int screenWidth;

extern void calcNodePos(int *tuple, int node, int lnc, int layer);

extern void mouseDown(SDL_Event *event);

extern void rect(float x, float y, float w, float h);
extern void worldRect(float x, float y, float w, float h);
extern void fill(int r, int g, int b);
extern void circle(float x, float y, float r);
extern void angle2Vector(float *ptr,float angle,float mag);

extern void setup();
extern void draw();
extern void keyDown(int k);
extern void keyUp(int k);

extern float camOffx;
extern float camOffy;
extern float scale;
extern void world2screen(float *in);
extern void screen2world(float *in);

extern void thickLine(float x1, float y1, float x2, float y2,int t);

extern void setupNet(struct neuralNet *net);

const int layerSizes[] = {3,4,3};

#define layers sizeof(layerSizes)/sizeof(layerSizes[0])
#define biggestLayer 6

const int xspacing = 130;
const int yspacing = 130;
const int npx = 100;
const int npy = 350;
const int neuronSize = 35;


extern void renderNet(struct neuralNet *net);


struct neuralNet{

    //which layer, which neuron
    float biases[layers][biggestLayer];
    
    float outputs[layers][biggestLayer];

    //which layer, which neuron, which preceding neuron
    //first row of array is useless
    float weights[layers][biggestLayer][biggestLayer];

};

extern void propagateNet(struct neuralNet *net);
extern void propagateLayer(struct neuralNet *net,int layer);

extern float canvasCenter[2];

extern SDL_Renderer *renderer;
extern SDL_Window *window;
