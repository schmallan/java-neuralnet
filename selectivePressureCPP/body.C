#include "headers.h"
#include <math.h>

bool showInfoPanel = true;

void infp(){
    if (showInfoPanel){
        canvasCenter[0]=(screenWidth-500)/2+500;
        canvasCenter[1]=screenHeight/2;
    } else {
        canvasCenter[0]=(screenWidth)/2;
        canvasCenter[1]=screenHeight/2;
    }
}

bool keys[150] = {false};
void keyDown(int keyCode)
{
    if (keyCode<150) keys[keyCode] = true;   

    char keyChar = (char)keyCode;

    printf("Key: %c Keycode: %d\n", keyChar, keyCode);

    switch (keyChar)
    {
    case 'h':
        showInfoPanel=!showInfoPanel;
        infp();
        break;
    
    }
}
void keyUp(int keyCode)
{
    if (keyCode<150) keys[keyCode] = false;   
}

float canvasCenter[2];
void setup()
{
    infp();
}

void draw()
{
    float spd = 0.5/scale;
    if (keys[(int)'w']) camOffy-=spd;
    if (keys[(int)'s']) camOffy+=spd;
    if (keys[(int)'a']) camOffx-=spd;
    if (keys[(int)'d']) camOffx+=spd;
    if (keys[(int)'q']) scale*=1.001;
    if (keys[(int)'e']) scale/=1.001;
    scale = fmin(fmax(0.5,scale),50);

    fill(100, 100, 100);
    SDL_RenderClear(renderer);

    //draw a grid
    for (int i = 0; i<10; i++){
        for (int j = 0; j<10; j++){
            int x = i*50-250;
            int y = j*50-250;
            fill(200,200,200);
            if ((i+j)%2==0) fill(255,255,255);
            worldRect(x,y,50,50);
        }
    }

    fill(255, 0, 0);
    worldRect(0,0,50,50);
    fill(9, 0, 255);
    worldRect(30,-20,10,90);
    
    if (showInfoPanel){
        fill(0, 0, 0);
        rect(0, 0, 500, screenHeight);
    }
}

void infopane()
{
}