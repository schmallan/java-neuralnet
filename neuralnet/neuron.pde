static int circlesize = 30;
static int spacing = 20;
static int sidespacing = 30;
class neuron {
  int xpos;
  int ypos;
  float wsum = -1;
  float output = -1;
  float bias;
  
  neuron ncopy(float bm){
     return new neuron(xpos,ypos,bias+bm); 
  }

  neuron(int x, int y, float b) {
    xpos = x;
    ypos = y;
    bias = b;
  }

  void render() {
    int col = 0;
    if (output>0.5) col = 70;
    colorMode(HSB, 255, 50, 255);
    fill(col, Math.abs(output-0.5)*100, 255);
    //  strokeWeight(Math.abs(bias));
    ellipse(xpos, ypos, circlesize, circlesize);
  }
}

class layer {
  public neuron[] neurons;
  int xpos;
  int ypos;
  int neuroncount;
  layer(int nc, int x, int y) {
    xpos = x;
    ypos = y;
    neuroncount = nc;
    neurons = new neuron[nc];
    int gap = circlesize+spacing;
    int sh = y- gap/2*(nc-1);
    for (int i = 0; i<nc; i++) {
      neuron n = new neuron(xpos, sh+i*gap, (float)(Math.random()-0.5));
      neurons[i] = n;
    }
  }

  void render() {
    for (int i = 0; i<neuroncount; i++) {
      neuron n = neurons[i];
      n.render();
    }
  }
}

class net {
  int xpos;
  int ypos;
  int numlayers;
  int[] layernc;
  float[][][] weights;
  layer[] layers;
  
  String[] inpnames;
  String[] outnames;


  net ncopy() {
    net ret = new net(layernc, inpnames, outnames, xpos, ypos);
    
    ret.numlayers = numlayers;
    ret.layers = new layer[numlayers];
    ret.weights = new float[numlayers-1][][];
    
    //copy neurons
    for (int i = 0; i<numlayers; i++) {
      layer li = new layer(layernc[i], xpos + (sidespacing+circlesize)*i, ypos);
      ret.layers[i] = li;
      layer oi = ret.layers[i];
      for (int j = 0; j<oi.neurons.length; j++){
     
        //NEURON BIAS MOD
        float nb = (float)(Math.random()-0.5)/80;

        neuron cn = oi.neurons[j].ncopy(nb); 
        li.neurons[j] = cn;
      }
    }
    
    //copy weights
    for (int back = 0; back<numlayers-1; back++) { //1
      int front = back+1;
      float[][] wlay = new float[layernc[front]][];
      ret.weights[back] = wlay;
      for (int i = 0; i<layernc[front]; i++) { //2
        float[] wlay2 = new float[layernc[back]];
        wlay[i] = wlay2;
        for (int k = 0; k<layernc[back]; k++) { //3

          //WEIGHT MOD
          float wm = (float)(Math.random()-0.5)/80;

          wlay2[k] = weights[back][i][k] + wm;
        }
      }
    }
    
    return ret;
  }

  
  void recurrent() {
    layer l = layers[numlayers-1];
    layer f = layers[0];
    for (int i = 0; i<l.neurons.length; i++) {
      f.neurons[f.neurons.length-1-i].output = l.neurons[l.neurons.length-i-1].output;
    }
  }

  void player(int l) {
    neuron[] cnl = layers[l].neurons;
    float[][] cfa = weights[l-1];
    neuron[] pnl = layers[l-1].neurons;

    for (int n = 0; n<cnl.length; n++) {
      neuron cn = cnl[n];
      float sum = 0;
      for (int pn = 0; pn<pnl.length; pn++) {
        float cweight = cfa[n][pn];
        neuron pneuron = pnl[pn];
        sum += cweight*pneuron.output;
      }
      cn.wsum = sum;
      cn.output = activationfunction(sum + cn.bias);
    }
  }
  void propagate() {
    for (int i = 1; i<numlayers; i++) {
      player(i);
    }
  }
  net(int[] nc, String[] in, String[] on, int x, int y) {
    inpnames = in;
    outnames = on;
    xpos = x;
    ypos = y;
    numlayers = nc.length;
    layernc = nc;
    layers = new layer[numlayers];
    weights = new float[numlayers-1][][];
    for (int i = 0; i<numlayers; i++) {
      layers[i] = new layer(nc[i], x + (sidespacing+circlesize)*i, y);
    }
    for (int back = 0; back<numlayers-1; back++) { //1
      int front = back+1;
      float[][] wlay = new float[nc[front]][];
      weights[back] = wlay;
      for (int i = 0; i<nc[front]; i++) { //2
        float[] wlay2 = new float[nc[back]];
        wlay[i] = wlay2;
        for (int k = 0; k<nc[back]; k++) { //3
          wlay2[k] = (0.5-(float)Math.random())*4;
        }
      }
    }
  }

  int[] checkmouse(int x, int y) {
    int hs = circlesize/2;
    int ai = 0;
    for (layer a : layers) {
      int bi = 0;
      for (neuron b : a.neurons) {

        int nx = b.xpos;
        int ny = b.ypos;
        if ( x<nx+hs & x>nx-hs & y<ny+hs & y>ny-hs) {
          return new int[] {ai, bi};
        }

        bi++;
      }
      ai++;
    }
    return null;
  }

  void setinputs(float[] inputs) {
    for (int i = 0; i<inputs.length; i++) {
      layers[0].neurons[i].output = inputs[i];
    }
  }

  void render() {

    for (int i = 0; i<numlayers; i++) {
      layer n = layers[i];
      fill(200);
      strokeWeight(2);
      stroke(0);
      if (i==0) stroke(#eb4034);
      if (i==numlayers-1) stroke(#b6ff85);
      n.render();
    }
    
     for (int nn = 0; nn<layernc[0]; nn++){
       neuron cn = layers[0].neurons[nn];
       fill(255);
       textSize(20);
       String w = inpnames[nn];
       text(w,cn.xpos-w.length()*10-circlesize/2,cn.ypos+10);
     }
     for (int nn = 0; nn<layernc[numlayers-1]; nn++){
       neuron cn = layers[numlayers-1].neurons[nn];
       fill(255);
       textSize(20);
       String w = outnames[nn];
       text(w,cn.xpos+circlesize,cn.ypos+10);
     }

    int ai=0;
    for (float[][] a : weights) {
      int bi = 0;
      for (float[] b : a) {
        int ci = 0;
        for (float c : b) {
          
          

          neuron frontn = layers[ai+1].neurons[bi];
          neuron backn = layers[ai].neurons[ci];

          int h = circlesize/2;
          int col = 0;
          if (c>0) col = 70;
          colorMode(HSB, 255, 50, 255);
          stroke(col, Math.abs(c)*100, 255);
          strokeWeight(abs(c)*3);
          line(frontn.xpos-h, frontn.ypos, backn.xpos+h, backn.ypos);


          ci++;
        }
        bi++;
      }

      ai++;
    }
  }
}

float activationfunction(float x) {
  //return x;
  //return Math.max(0,x); // rectified linear
  return (1/(1+exp(-x))); //sigmoid function //sigma
}
