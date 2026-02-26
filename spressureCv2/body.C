#include "headers.h"
#include <math.h>
#include <SDL3/SDL_render.h>
#include "neural.h"

neuralNet *mynet;
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
    if (keyCode == 9 & selectedNeuron[1]>0){
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
        propagateNet(mynet);
        break;
    case '=':
        mynet->outputs[selectedNeuron[1]][selectedNeuron[2]] += 0.1;
        break;
    case '-':
        mynet->outputs[selectedNeuron[1]][selectedNeuron[2]] -= 0.1;
        break;
    case '\'':
        mynet->biases[selectedNeuron[1]][selectedNeuron[2]] += 0.1;
        break;
    case ';':
        mynet->biases[selectedNeuron[1]][selectedNeuron[2]] -= 0.1;
        break;
    case '[':
        mynet->weights[selectedNeuron[1]][selectedNeuron[2]][selectedNeuron[3]] -=0.5;
        break;
    case ']':
        mynet->weights[selectedNeuron[1]][selectedNeuron[2]][selectedNeuron[3]] +=0.5;
        break;
    
    
    case 'n':
    spawnCreature();
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
   // mynet = &myCreatures[crc-1].brain;
    //setupNet(&mynet);
   // srand((unsigned)time(NULL));
    infp();
}

void renderTick(){
    
    for (int i = 0; i<crc; i++){
        renderCreature(&myCreatures[i]);
    }
}

void worldTick(){
    
    for (int i = 0; i<crc; i++){
        tickCreature(&myCreatures[i]);
    }
}

void draw()
{   
    selectedNeuron[0] = crc-1;
    mynet = &myCreatures[selectedNeuron[0]].brain;

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

    const int bgSize = 25;
    const int bgg = borderSize/bgSize;
    //draw a grid
    for (int i = -bgg; i<bgg; i++){
        for (int j = -bgg; j<bgg; j++){
            int x = i*bgSize;
            int y = j*bgSize;
            fill(230,230,230);
            if ((i+j)%2==0) fill(255,255,255);
            worldRect(x,y,bgSize,bgSize);
        }
    }


    if (showInfoPanel){
        fill(0, 0, 0);
        rect(0, 0, paneSize, screenHeight);

        fill(255,255,200);
        char msg[] = "Click on a neuron to view info\n"
            "Press <TAB> to cycle through weights\n"
            "Press <?/?> to manually adjust values\n";
        renderStr(msg,1.5,50,120);

        if (selectedNeuron[2]!=-1){
            char msg[50];
            int tx = 50;
            int ty = 250;
            float ts = 1.5;
            fill(255,200,255);
            sprintf(msg,"<+/-> neuron output: \n    %f \n"
                        "<;/'> neuron bias: \n    %f - %d"
                        ,mynet->outputs[selectedNeuron[1]][selectedNeuron[2]]
                        ,mynet->biases[selectedNeuron[1]][selectedNeuron[2]],crc);
            renderStr(msg,ts,tx,ty);
            if (selectedNeuron[1]>0){
                fill(200,200,255);
                sprintf(msg,"<[/]> weight: \n    %f",mynet->weights[selectedNeuron[1]][selectedNeuron[2]][selectedNeuron[3]]);
                renderStr(msg,ts,tx,ty+100);
            }
        }
        
        
        if (selectedNeuron[0]!=-1){
        renderNet(mynet);
        }
    }

    
    fill(255,255,255);
    char msg[] = "SELECTIVE PRESSURE \nPress <H> to toggle info panel";
    renderStr(msg,1.5,10,20);

    worldTick();
    renderTick();
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