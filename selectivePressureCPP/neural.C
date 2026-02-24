#include "headers.h"

const int layerSizes[] = {3,5,3};
const int layers = sizeof(layerSizes)/sizeof(layerSizes[0]);
const int biggestLayer = 5;

struct neuralNet{
    
    //which layer, which neuron
    float biases[layers][biggestLayer];

    //which layer, which neuron, which preceding neuron
    float weights[layers][biggestLayer][biggestLayer];

};