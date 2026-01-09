class neuron{
    double output;
    double bias;
    double[] weights; //one weight for each neuron on the prev layer.
    double weightSum;
    
    neuron(int x, int y, double b, int s){ posx = x; posy = y; bias = b; size = s; 
        output = Math.random();
        bias = Math.random();
    }

    int posx; int posy;
    int size;
    void render(){
        double o = output-0.5;
        fill(toColor(o));
        ellipse(posx,posy,size*2,size*2);
    }
}

class layer{
    neuron[] neurons;

    layer prevLayer = null;
    int size;
    int nSize;
    int posx, posy;
    int spacingY;

    void propagate(){
        for (neuron n : neurons){
            double weightedSum = 0;
            if (prevLayer==null) continue;
            for (int i = 0; i<prevLayer.size; i++){
                neuron pn = prevLayer.neurons[i];
                double weight = n.weights[i];

                weightedSum+=pn.output*weight;
            }
            weightedSum+=n.bias;
            n.output = activationFunction(weightedSum);
        }
    }

    layer(int neuronCount, layer l, int x, int y, int sy, int n){ posx = x; posy = y; prevLayer = l; spacingY = sy; nSize = n;
        size = neuronCount;
        neurons = new neuron[size];
        for (int i = 0; i<neuronCount; i++){
            neuron cNeuron = new neuron(posx,posy+i*spacingY,0,nSize);
            neurons[i] = cNeuron;
            if (prevLayer!=null){
                cNeuron.weights = new double[prevLayer.size];
                for (int j = 0; j<cNeuron.weights.length; j++){
                    cNeuron.weights[j] = (Math.random()-0.5)*5;
                }
            }

        }
    }

    void render(){
        for (neuron n : neurons){

            if (prevLayer==null) continue;
            for (int i = 0; i<prevLayer.size; i++){
                neuron pn = prevLayer.neurons[i];
                strokeWeight(5);
                stroke(toColor(n.weights[i]));
                line(pn.posx,pn.posy,n.posx,n.posy);
            }
        }
    }
    void rendern(){
        for (neuron n : neurons){ n.render(); }
    }
}

int toColor(double inp){
    int hue = (inp>0) ? 60 : 0;
    return color(hue,(int)(abs((float)inp)*255/2),255);
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

double activationFunction(double inp){
    return 1/(1+pow(2.718,(float)-inp));
}