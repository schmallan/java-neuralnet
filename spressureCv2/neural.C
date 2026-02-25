#include "headers.h"
#include <math.h>

void calcNodePos(int *tuple, int node, int lnc, int layer)
{
    int x = npx + layer * xspacing;
    int y = npy + node * yspacing - (lnc - 1) * yspacing / 2;
    tuple[0] = x;
    tuple[1] = y;
}

// double random_num = (double)rand() / (double)RAND_MAX;

float activationFunc(float in){
    return 1/(1+pow(3,-in));
}

void propagateLayer(struct neuralNet *net,int layer)
{
    for (int node = 0; node<layerSizes[layer]; node++){
        float weightedSum = 0;
        for (int pnode = 0; pnode<layerSizes[layer-1]; pnode++){
            float output = net->outputs[layer-1][pnode];
            float weight = net->weights[layer][node][pnode];
            float weightedOutput = output*weight;
            weightedSum+=weightedOutput;
        }
        
        float bias = net->biases[layer][node];
        weightedSum+=bias;
        float finalOut = activationFunc(weightedSum);
        net->outputs[layer][node] = finalOut;
    }
}

void propagateNet(struct neuralNet *net){
    for (int layer = 1; layer<layers; layer++){
        propagateLayer(net,layer);
    }
}

void setupNet(struct neuralNet *net)
{
    for (int layer = 0; layer < layers; layer++)
    {
        int layerNodeCount = layerSizes[layer];

        for (int node = 0; node < layerNodeCount; node++)
        {
            net->outputs[layer][node] = (double)rand() / (double)RAND_MAX;
            net->biases[layer][node] = ((double)rand() / (double)RAND_MAX-0.5)*5;
        }


        if (layer != 0)
        {
            int prevLayerNodeCount = layerSizes[layer - 1];
            for (int node = 0; node < layerNodeCount; node++)
            {
                for (int pnode = 0; pnode < prevLayerNodeCount; pnode++)
                {
                    float rn = (((double)rand() / (double)RAND_MAX)-0.5)*5;
                    net->weights[layer][node][pnode] = rn;
                }
            }
        }
    }
}

void renderNet(struct neuralNet *net)
{
    for (int layer = 0; layer < layers; layer++)
    {
        int layerNodeCount = layerSizes[layer];

        if (layer != 0)
        {
            int prevLayerNodeCount = layerSizes[layer - 1];
            for (int node = 0; node < layerNodeCount; node++)
            {
                for (int pnode = 0; pnode < prevLayerNodeCount; pnode++)
                {
                    int np[2];
                    calcNodePos(np, node, layerNodeCount, layer);
                    int vp[2];
                    calcNodePos(vp, pnode, prevLayerNodeCount, layer - 1);

                    float weightval = net->weights[layer][node][pnode];
                    
                    if (layer == selectedNeuron[2] & node == selectedNeuron[1] & pnode == selectedNeuron[3]){
                        fill(0,0,255);
                        thickLine(np[0], np[1], vp[0], vp[1], abs(weightval)+5+5*abs(node-pnode));
                    }

                    if (weightval > 0) { fill(0, 255, 0); }
                    else { fill(255, 0, 0); }


                    thickLine(np[0], np[1], vp[0], vp[1], abs(weightval));
                    fill(255, 255, 255);
                }
            }
        }

        for (int node = 0; node < layerNodeCount; node++)
        {
            int xy[2];
            calcNodePos(xy, node, layerNodeCount, layer);

            //draw a box around the neuron if it is selected
            if (node==selectedNeuron[1]&layer==selectedNeuron[2]){
                fill(0,0,255);
                rect(xy[0]-neuronSize-10,xy[1]-neuronSize-10,neuronSize*2+20,neuronSize*2+20);
            }  

            //draw the bias as a colored border around neuron
            float biasval = net->biases[layer][node];
            float a = 255-abs(biasval)*100;
            a = fmax(0,fmin(255,a));
            if (biasval>0){
                fill(a,255,a);
            } else {
                fill(255,a,a);
            }
            circle(xy[0], xy[1], neuronSize+3);

            //draw the neuron as a colored circle
            float nodeval = net->outputs[layer][node];
            nodeval = fmax(0,fmin(1,nodeval));
            int cnv = 255 * nodeval;
            fill(cnv, cnv, cnv);
            circle(xy[0], xy[1], neuronSize);
            
        }
    }
}
