#include "headers.h"
#include <math.h>
#include <SDL3/SDL_render.h>

struct neuralNet mynet;
//note: add guard rails on selecting neurons/biases that dont exist. just in case
//node, layer, pnode
int selectedNeuron[4] = {-1,-1,-1,0};

bool showInfoPanel = true;
int paneSize = 800;
void infp(){
    if (showInfoPanel){
        canvasCenter[0]=(screenWidth-paneSize)/2+paneSize;
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
    if (keyCode == 9){
        selectedNeuron[3] = selectedNeuron[3]+1;
        selectedNeuron[3] = selectedNeuron[3]%layerSizes[selectedNeuron[1]-1];
    }

    switch (keyChar)
    {
    case 'h':
        showInfoPanel=!showInfoPanel;
        infp();
        break;
    case 'p':
        propagateNet(&mynet);
        break;
    case '=':
        mynet.outputs[selectedNeuron[1]][selectedNeuron[2]] += 0.1;
        break;
    case '-':
        mynet.outputs[selectedNeuron[1]][selectedNeuron[2]] -= 0.1;
        break;
    case '\'':
        mynet.biases[selectedNeuron[1]][selectedNeuron[2]] += 0.1;
        break;
    case ';':
        mynet.biases[selectedNeuron[1]][selectedNeuron[2]] -= 0.1;
        break;
    case '[':
        mynet.weights[selectedNeuron[1]][selectedNeuron[2]][selectedNeuron[3]] -=0.5;
        break;
    case ']':
        mynet.weights[selectedNeuron[1]][selectedNeuron[2]][selectedNeuron[3]] +=0.5;
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
    setupNet(&mynet);
   // srand((unsigned)time(NULL));
    infp();
}


void draw()
{
    printf("oh myg odbruh");
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
        rect(0, 0, paneSize, screenHeight);
        fill(255,255,255);
        
        char msg[50];
        sprintf(msg,"neuron output: %f",mynet.outputs[selectedNeuron[1]][selectedNeuron[2]]);
        SDL_RenderDebugText(renderer,100,600,msg);
        sprintf(msg,"neuron bias: %f",mynet.biases[selectedNeuron[1]][selectedNeuron[2]]);
        SDL_RenderDebugText(renderer,100,630,msg);
        sprintf(msg,"weight: %f",mynet.weights[selectedNeuron[1]][selectedNeuron[2]][selectedNeuron[3]]);
        SDL_RenderDebugText(renderer,100,660,msg);

        renderNet(&mynet);
    }


    


}

void mouseDown(SDL_Event *event){
    float x;
    float y;
    SDL_GetMouseState(&x,&y);
    
    bool brk = false;
    for (int layer = 0; layer < layers; layer++)
    {
        int layerNodeCount = layerSizes[layer];
        for (int node = 0; node < layerNodeCount; node++)
        {   
            int np[2];
            calcNodePos(np,node,layerNodeCount,layer);
            int nx = np[0];
            int ny = np[1];

            int diff = fmax(abs(nx-x),abs(ny-y));
            if (diff<neuronSize){
               selectedNeuron[2] = node;
               selectedNeuron[1] = layer;
               selectedNeuron[3] = 0;
               brk = true;
               break;
            }   
        }
        if (brk) break;
    }
    if (!brk){
        selectedNeuron[0] = -1;
        selectedNeuron[2] = -1;
        selectedNeuron[1] = -1;
        
    }

    printf("screencoords: %d, %d ",screenWidth,screenHeight);
    printf("mouseDown: %f,%f\n",x,y);
};