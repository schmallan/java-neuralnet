#include "headers.h"

void rect(float x, float y, float w, float h){

    SDL_FRect myrect;
    myrect.x=x;
    myrect.y=y;
    myrect.w=w;
    myrect.h=h;
    SDL_RenderFillRect(renderer,&myrect);

}
void worldRect(float x, float y, float w, float h){
    float pos[2] = {x,y};
    world2screen(pos);
    rect(pos[0]+canvasCenter[0], pos[1]+canvasCenter[1], w*scale, h*scale);
    fill(0,0,255);
}

void fill(int r, int g, int b){
    SDL_SetRenderDrawColor(renderer,r,g,b,SDL_ALPHA_OPAQUE);
}