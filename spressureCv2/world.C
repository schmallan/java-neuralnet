#include "headers.h"
float camOffx = 0;
float camOffy = 0;
float scale = 1;
void world2screen(float *arr){
    float x = arr[0];
    float y = arr[1];
    x-=camOffx;
    y-=camOffy;
    x*=scale;
    y*=scale;
    arr[0] = x+canvasCenter[0];
    arr[1] = y+canvasCenter[1];
}
void screen2world(float *arr){
    float x = arr[0]-canvasCenter[0];
    float y = arr[1]-canvasCenter[1];
    x/=scale;
    y/=scale;
    x+=camOffx;
    y+=camOffy;
    arr[0] = x;
    arr[1] = y;
}