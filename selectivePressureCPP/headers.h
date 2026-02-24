#include <SDL3/SDL.h>
#include <stdio.h>

extern int screenHeight;
extern int screenWidth;

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

extern float canvasCenter[2];

extern SDL_Renderer *renderer;
extern SDL_Window *window;
