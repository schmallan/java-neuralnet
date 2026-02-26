#include <SDL3/SDL.h>
#include <stdio.h>
#include <stdlib.h>

const int borderSize = 500;

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
extern void worldTriangle(SDL_Vertex *v);

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

const int numCreatures = 30;

extern void renderStr(char *msg, int size, int x, int y);

extern float canvasCenter[2];

extern SDL_Renderer *renderer;
extern SDL_Window *window;
