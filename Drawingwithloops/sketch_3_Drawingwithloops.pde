
/*******************************************************
 ********************************************************
 **************** 3. DRAWING WITH LOOPS *****************
 ****************** by JOAN SANDOVAL ********************
 ********************************************************
 *******************************************************/

//GLOBAL VARIABLES

//Variables for animation
int anim1 = 0;
boolean animbool = false;

//Variable for knowing in which scene are we
int scene = 0;

//Variable for camera pos
float x, y, z;

//Variables for 3D shape positions
int[] posx = new int[100];
int[] posy = new int[100];
int[] posz = new int[100];
int[] rotx = new int[100];
int[] roty = new int[100];
int[] rotz = new int[100];


void setup() {

  //CHOOSE SCREEN SIZE
  size(displayWidth, 750, P3D); // (Recommended for better visualisation)
  //size(800, 600,P3D);

  //Define the axis
  x = width/2;
  y = height/2;
  z = height/2;
}


void draw() {
  background(0);

  //Each scene is a different view

  //First view (animation)
  if (scene==0) animation();

  //View corresponding to exercise in 2D
  if (scene==1) {
    exercise2D();
    noLoop();
  }

  //View corresponding to exercise in 3D
  if (scene==2) {
    exercise3D();
    noLoop();
  }
}


// FUNCTIONS


void animation() {
  clear();
  background(0);

  //Variable to change colors
  if (anim1<150 && animbool!=true) {
    anim1+=1;
    animbool=false;
  }
  if (anim1>=150 || animbool==true) {
    anim1-=1; 
    animbool=true;
    if (anim1<20) {
      animbool=false;
    }
  }

  //Variables for moving the circle in relation to mouse position
  float x=height*0.4*sin(PI*2*float(mouseX)/float(width));
  float y=height*0.4*cos(PI*2*float(mouseX)/float(width));
  float dist_x= 2*height*0.4*cos(2*PI);
  float dist_y= 2*height*0.4*cos(2*PI);
  //Color gradient
  fill(0);
  strokeWeight(5);
  int numextcirc=10;
  int extcircolor=100;
  int extcirc = 50;
  for (int i=0; i<numextcirc; i++) {
    stroke(anim1-abs(extcircolor), 0, 0);
    ellipse(width/2, height/2, dist_x+extcirc, dist_y+extcirc);
    extcircolor-=10;
    extcirc-=5;
  }

  //Main circle and little one
  stroke(anim1, 0, 0);
  ellipse(width/2, height/2, dist_x, dist_y);
  ellipse(x+width/2, y+height/2, 30, 30);

  //Screen noise
  fill(255);
  noStroke();
  ellipse(random(width), random(height), 3, 3);

  //Buttons and Text
  int circolor=0;
  int circsize=height/4;
  int numbcirc=height/20;
  for (int i=0; i<numbcirc; i++) {
    noStroke();
    fill(circolor, 0, 0);
    ellipse((width/2)-(width/10), height/2, circsize, circsize);
    ellipse((width/2)+(width/10), height/2, circsize, circsize);
    circolor+=7;
    circsize-=5;
  }
  fill(255);
  textSize(height/25);
  text("2D", (width/2)-(width/10)-15, (height/2)+5);
  text("3D", (width/2)+(width/10)-15, (height/2)+5);
}


void exercise2D() {
  clear();
  background(0);

  //Back button
  backbutton();
  fill(255);
  textSize(height/25);
  text("BACK", (width/8)-30, (height/8)+5);

  //Drawing squares and circles, with random color and size
  for (int i=0; i<100; i++) {
    if (i<50) {
      noStroke();
      fill(random(0, 255), random(0, 255), random(0, 255));
      int size = int(random(10, 80));
      rect(random(0, width), random(0, height), size, size);
    } else {
      noStroke();
      fill(random(0, 255), random(0, 255), random(0, 255));
      int size = int(random(10, 80));
      ellipse(random(0, width), random(0, height), size, size);
    }
  }
}


void exercise3D() {
  clear();
  background(0);

  //Back button
  backbutton();
  fill(255);
  textSize(height/25);
  text("BACK", (width/8)-30, (height/8)+5);

  //Moving camera to a certain position
  translate(x, y, z);

  // Creation of different cubes and spheres with random position and rotation
  // Saving all the info in different arrays for the later access
  for (int i = 0; i<100; i++) { 
    int a = (int)random(-width/2, width/2);
    int b = (int)random(-height/2, height/2);
    int c = (int)random(-1000, -350);
    int d = (int)random(0, PI);
    int e = (int)random(0, PI);
    int f = (int)random(0, PI);
    posx[i] = 0; 
    posy[i] = 0; 
    posz[i] = 0; 
    rotx[i] = 0;
    roty[i] = 0;
    rotz[i] = 0;
    posx[i] = a; 
    posy[i] = b; 
    posz[i] = c; 
    rotx[i] = d;
    roty[i] = e;
    rotz[i] = f;

    //drawing cubes and spheres, using popMatrix and pushMatrix() for changing coordinate system, 
    //using lights() for having a more real perception of 3D shapes
    if (i<50) {
      int rect_size = int(random(10, 80));
      pushMatrix();
      translate(posx[i], posy[i], posz[i]);
      rotateX(rotx[i]);
      rotateY(roty[i]);
      rotateZ(rotz[i]);
      fill(random(0, 255), random(0, 255), random(0, 255));
      box(rect_size);
      lights();
      popMatrix();
    } else {
      int sphere_size= int(random(10, 80));
      pushMatrix();
      translate(posx[i], posy[i], posz[i]);
      rotateX(rotx[i]);
      rotateY(roty[i]);
      rotateZ(rotz[i]);
      fill(random(0, 255), random(0, 255), random(0, 255));
      sphere(sphere_size);
      lights();
      popMatrix();
    }
  }
}


//function used for changing scene when the mouse is clicked inside the area of the different buttons
void mouseClicked() {
  float isInside2D = pow(((width/2)-(width/10)-mouseX), 2)+pow(((height/2)-mouseY), 2);
  float isInside3D = pow(((width/2)+(width/10)-mouseX), 2)+pow(((height/2)-mouseY), 2);
  float isInsideBack = pow(((width/8)-mouseX), 2)+pow(((height/8)-mouseY), 2);
  if (scene==0) {
    if (isInside2D<pow((height/12), 2)) {
      scene = 1;
    }
    if (isInside3D<pow((height/12), 2)) {
      scene = 2;
    }
  }
  if (scene ==1) {
    if (isInsideBack<pow((height/12), 2)) {
      scene = 0;
      loop();
    }
  }
  if (scene ==2) {
    if (isInsideBack<pow((height/12), 2)) {
      scene = 0;
      loop();
    }
  }
}


//function for the back button
void backbutton() {
  int circolor=0;
  int circsize=height/4;
  int numbcirc=height/20;
  for (int i=0; i<numbcirc; i++) {
    noStroke();
    fill(circolor, 0, 0);
    ellipse(width/8, height/8, circsize, circsize);
    circolor+=7;
    circsize-=5;
  }
}

