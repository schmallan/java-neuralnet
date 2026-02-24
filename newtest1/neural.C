#include "headers.h"


void calcNodePos(int *tuple, int node, int lnc, int layer)
{
    int x = npx + layer * xspacing;
    int y = npy + node * yspacing - (lnc - 1) * yspacing / 2;
    tuple[0] = x;
    tuple[1] = y;
}

// double random_num = (double)rand() / (double)RAND_MAX;

void propagateLayer(struct neuralNet *net)
{
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
                    net->biases[node][pnode] = rn;
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

                    float weightval = net->biases[node][pnode];

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

            float biasval = net->biases[layer][node];
            float a = 255-abs(biasval)*100;
            if (biasval>0){
                fill(a,255,a);
            } else {
                fill(255,a,a);
            }
            if (node==selectedNeuron[1]&layer==selectedNeuron[2]) fill(255,255,0);
            circle(xy[0], xy[1], neuronSize+3);

            float nodeval = net->outputs[layer][node];
            int cnv = 255 * nodeval;
            fill(cnv, cnv, cnv);
            if (node==selectedNeuron[1]&layer==selectedNeuron[2]) fill(0,255,255);
            circle(xy[0], xy[1], neuronSize);
            


        }
    }
}
