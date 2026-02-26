#define M_PI 3.14159265358979323846
#include "headers.h"
#include <math.h>

void triangle(SDL_Vertex *vertices){
    float r;
    float g;
    float b;
    float a;
    SDL_GetRenderDrawColorFloat(renderer,&r,&g,&b,&a);
    for (int n = 0; n<3; n++){
        vertices[n].color.r = r;
        vertices[n].color.g = g;
        vertices[n].color.b = b;
        vertices[n].color.a = a;
    }
    SDL_RenderGeometry(renderer,NULL,vertices,3,NULL,0);
}
void worldTriangle(SDL_Vertex *vertices){
    for (int n = 0; n<3; n++){
        float xy[2];
        xy[0]=vertices[n].position.x;
        xy[1]=vertices[n].position.y;
        world2screen(xy);
        vertices[n].position.x = xy[0];
        vertices[n].position.y = xy[1];
        
    }
    triangle(vertices);

}
void circle(float x, float y, float r){
    const int points = 16;
    
    const float fracRad = M_PI*2/points;
    for (int i = 0; i<points; i++){
        int j = i+1;
        if (j==points) j=0;
        SDL_Vertex verts[points];
        float vec[2];
        angle2Vector(vec,fracRad*i,r);
        float vec2[2];
        angle2Vector(vec2,fracRad*j,r);
        verts[0].position.x = vec[0]+x;
        verts[0].position.y = vec[1]+y;
        verts[1].position.x = vec2[0]+x;
        verts[1].position.y = vec2[1]+y;
        verts[2].position.x = x;
        verts[2].position.y = y;
        
        //printf("i: %d, x: %f, y: %f\n",i,vec[0],vec[1]);
        triangle(verts);

    }

};

void thickLine(float x1, float y1, float x2, float y2,int t){
    for (int j = -t; j<=t; j++){
        SDL_RenderLine(renderer,x1,y1+j,x2,y2+j);
    }
}

void angle2Vector(float *ptr,float angle,float mag){
    float x = cos(angle);
    float y = sin(angle);
    x*=mag;
    y*=mag;
    ptr[0]=x;
    ptr[1]=y;
}


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
    rect(pos[0], pos[1], w*scale, h*scale);
    fill(0,0,255);
}

void fill(int r, int g, int b){
    SDL_SetRenderDrawColor(renderer,r,g,b,SDL_ALPHA_OPAQUE);
}