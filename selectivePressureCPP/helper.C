#include <SDL3/SDL.h>
#include "headers.h"
#include <stdio.h>

void rect(int x, int y, int w, int h){

    SDL_FRect myrect;
    myrect.x=x;
    myrect.y=y;
    myrect.w=w;
    myrect.h=h;
    SDL_RenderFillRect(renderer,&myrect);

}


void fill(int r, int g, int b){
    SDL_SetRenderDrawColor(renderer,r,g,b,SDL_ALPHA_OPAQUE);
    printf("set color:");
}