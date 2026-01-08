class neuron{
    double output;
    double bias;
    double[] weights; //one weight for each neuron on the prev layer.
    double weightSum;
    
    neuron(int x, int y, double b, int s){ posx = x; posy = y; bias = b; size = s;}

    int posx; int posy;
    int size;
    void render(){
        ellipse(posx,posy,size*2,size*2);
    }

    void sumWeights(){
        weightSum = 0;
        for (double w : weights){
            weightSum+=w;
        }
    }

}

class layer{
    layer prevLayer = null;
    int size;
    int nSize;
    int posx, posy;
    int spacingY;

    layer(int neuronCount, layer l, int x, int y, int sy, int n){ posx = x; posy = y; prevLayer = l; spacingY = sy; nSize = n;
        size = neuronCount;
        neurons = new neuron[size];
        for (int i = 0; i<neuronCount; i++){
            neuron cNeuron = new neuron(posx,posy+i*spacingY,0,nSize);
            neurons[i] = cNeuron;
            if (prevLayer!=null){
                cNeuron.weights = new double[prevLayer.size];
            }
        }
    }

    void render(){
        for (neuron n : neurons){

            if (prevLayer==null) continue;
            for (int i = 0; i<prevLayer.size; i++){
                neuron pn = prevLayer.neurons[i];
                line(pn.posx,pn.posy,n.posx,n.posy);
            }
        }
    }
    void rendern(){
        for (neuron n : neurons){ n.render(); }
    }

    neuron[] neurons;

}

class net{
    int size;
    layer[] layers;

    int posx, posy;

    net(int[] layerSizes, int posx, int posy, int spacingX, int spacingY, int nSize){
        size = layerSizes.length;

        layers = new layer[size];
        layer prevLayer = null;
        for (int i = 0; i<size; i++){
            int lsi = layerSizes[i];
            layer newLayer = new layer(lsi,prevLayer,posx+spacingX*i,posy-lsi*(spacingY/2),spacingY, nSize);
            layers[i] = newLayer;
            prevLayer = newLayer;
        }
    }

    void render(){
        for (layer l : layers){
            l.render();
        }
        for (layer l : layers){
            l.rendern();
        }
    }
}
