#define layers sizeof(layerSizes)/sizeof(layerSizes[0])
#define biggestLayer 6
const int layerSizes[] = {2,2,1};

typedef struct{

    //which layer, which neuron
    float biases[layers][biggestLayer];
    
    float outputs[layers][biggestLayer];

    //which layer, which neuron, which preceding neuron
    //first row of array is useless
    float weights[layers][biggestLayer][biggestLayer];

} neuralNet;
const int xspacing = 130;
const int yspacing = 130;
const int npx = 350;
const int npy = 450;
const int neuronSize = 35;

extern void setupNet(neuralNet *net);


extern void renderNet(neuralNet *net);
extern void propagateNet(neuralNet *net);
extern void propagateLayer(neuralNet *net,int layer);

typedef struct{
    neuralNet brain;
    float x;
    float y;
    float ang;
    float heading;
} creature;
extern int crc;
extern creature myCreatures[];
extern void spawnCreature();

extern void renderCreature(creature *mycreature);
extern void tickCreature(creature *mycreature);
extern float activationFunc(float in);