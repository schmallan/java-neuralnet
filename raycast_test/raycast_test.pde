void setup(){
 size(500,500); 
 
}


int[] origin = new int[] {0,0};

int[] offsets = new int[] {0,0};
float theta = 0;
float len = 0;


void mousePressed(){
  reset();
  int[] g = new int[]{mouseX,mouseY}; 
  if (mouseButton == LEFT){
    p1 = g;
    origin = new int[] {mouseX/50,mouseY/50};
    offsets = new int[] {mouseX-50*origin[0],mouseX-50*origin[1]};
    len = sqrt(pow(p1[0]-p2[0],2)+pow(p1[1]-p2[1],2));
  } else {
  p2 = g;
  }
  
  check();
}

//diddyblud

void check(){
  grid[origin[0]][origin[1]]= true;
  double ox = 50-offsets[0];
  double oy = offsets[1];
  double len = sqrt(pow(p1[0]-p2[0],2)+pow(p1[1]-p2[1],2));
  theta = atan2((float)ox,(float)oy);
  double fx = ox/cos(theta);
  double fy = oy/sin(theta);
  double rx = 50/cos(theta);
  double ry = 50/sin(theta);
  println(theta);
  println((fx>fy) ? "X" : "Y");
  
  int curX = origin[0];
  int curY = origin[1];
  double pos = 0;
  while (pos<len){
    curY+=1;
    curY=min(curY,9);
    pos+=ry;
    grid[curX][curY] = true;
  }


}

void reset(){
 grid = new boolean[10][10];
}

int[] p1 = new int[] {0,0};
int[] p2 = new int[] {0,0};
boolean[][] grid = new boolean[10][10];
void draw(){
  stroke(0);
  strokeWeight(2);
 for (int i = 0; i<grid.length; i++){
   for (int k= 0; k<grid.length; k++){
     fill(255);
     if (grid[i][k]) fill(80);
   rect(i*50,k*50, 50,50);  
   }
 }
 fill(255,0,0);
 ellipse(p1[0],p1[1],10,10);
 fill(55,0,250);
 ellipse(p2[0],p2[1],10,10);
 stroke(255,0,255);
 strokeWeight(5);
 line(p1[0],p1[1],p2[0],p2[1]);
 
}
