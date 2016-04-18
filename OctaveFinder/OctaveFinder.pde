
/*******************************************************
 ********************************************************
 ******** 1. FIND OCTAVE NUMBER FROM FREQUENCY **********
 ****************** by JOAN SANDOVAL ********************
 ********************************************************
 *******************************************************/
/***** IMPORTANT!!! READ BEFORE RUNNING THE CODE ******/

// THIS SKETCH REQUIRES THE MINIM LIBRARY: Go to Sketch --> Import Library... --> Add Library... --> Minim Library --> Install
import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioInput in;
FFT fft;

// GLOBAL VARIABLES

//Variables for Built-in Analysis
int n;
int sampleRate = 44100;
float [] max= new float [sampleRate/2];
float maximum;
float frequency;
float midi;
boolean check;

//Variables for Animation
int num_apples=0;
int apple_x;
int apple_y;
int NUM = 100;
PVector[] positions = new PVector[NUM];
int sz;

//Variable for Octave Finder
int circle_x;
int circle_y;
int x_box;
int y_box;
int w_box;
int h_box;
String blinkChar;
boolean inside_box;
boolean inside_circle;
String txt="";
String in_frequency="";
boolean check_octave = false;
boolean isNumber;



void setup() {

  // CHOOSE SCREEN SIZE 

  size(displayWidth, 750);
  //size(400, 400);
  //size(400, 600);

  //Initialize Minim objects
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.MONO, 4096, sampleRate);
  fft = new FFT(in.left.size(), sampleRate);

  //Define values for some global variables
  x_box=width/14;
  y_box=height/2;
  w_box=width/6;
  h_box=height/14;
  apple_x=int(random(10, width));
  apple_y=int(random(10, height));
  circle_x =(width/14)*10;
  circle_y =height/2;
}


void draw() {

  background(0);
  noCursor();

  //Main animation before Octave Finder
  animation();


  //Checking number of apples eaten

    if (num_apples==0) {
    fill(255);
    text("Eat five apples", width/4, 50);
  }

  //When 5 apples are eaten, display Octave Finder
  if (num_apples>=5) {
    textSize(width/14);
    fill(255);
    text("Octave Finder", (width/4), (height/6));

    //Manually input frequency value
    write_frequency();

    //Analyze frequencies coming from the micro Built-in of the computer
    //(Sing near the micro and a bit loud if possible) :-) Have fun
    octaveFinder();
  }
}


// FUNCTIONS

void animation() {

  //Save last NUM mouse Positions
  positions[NUM - 1] = new PVector(mouseX, mouseY); 
  check = true;
  for (int i=0; i<NUM-1; i++)
  {
    positions[i]=positions[i + 1];
    if (positions[i] == null) check = false;
  }

  //When positions is not null, draw three different circles of 
  //colors R,G,B varying its size, color intensity and placing them depending on positions[m]
  if (check!=false) {
    int it=150;
    float sz=0;
    for (int m=50; m<100; m++) {
      noStroke();
      fill(0, it, 0);
      ellipse(positions[m].x-4, positions[m].y+4, sz, sz);
      fill(it, 0, 0);
      ellipse(positions[m].x+4, positions[m].y+4, sz, sz);
      fill(0, 0, it);
      ellipse(positions[m].x, positions[m].y-4, sz, sz);
      sz+=0.2;
      it=it+2;
    }
  }

  //Drawing apples 
  fill(150, 0, 0);
  noStroke();
  ellipse(apple_x, apple_y, 15, 13);
  stroke(0, 200, 0);
  strokeWeight(3);
  line(apple_x, apple_y-5, apple_x+3, apple_y-11);

  //Formulas used for checking if mouse is touching an apple
  float isInsideApple = pow((apple_x-mouseX), 2)+pow((apple_y-mouseY), 2);
  if (isInsideApple<pow(13, 2)) {
    apple_x=int(random(10, width));
    apple_y=int(random(10, height));
    num_apples+=1;
  }

  //just draw a cross in mouse position
  stroke(255);
  strokeWeight(1);
  line(mouseX-4, mouseY-4, mouseX+4, mouseY+4);
  line(mouseX-4, mouseY+4, mouseX+4, mouseY-4);
}


void write_frequency() {

  textSize(width/40);
  fill(0, 150, 0);
  text("Introduce a frequency value (Hz):", (width/14), (height/3));

  stroke(50);
  inside_box = false;
  // If mouse is inside the box a boolean will allow to type numbers inside and press enter to check its octave
  if (mouseX > x_box & mouseX < (x_box+w_box) & mouseY > y_box & mouseY < (y_box+h_box)) {
    stroke(0, 255, 0);
    inside_box = true;
  }

  //Draw the box
  fill(0);
  rect(x_box, y_box, w_box, h_box);
  fill(255);
  blinkChar = "";
  if (inside_box == true && (frameCount % 30) == 0) {
    blinkChar = "_";
  }

  textSize(width/40);
  fill(255);
  //Showing the values typed + the blink char
  text(txt + blinkChar, x_box, y_box, w_box, h_box);

  // If ENTER is pressed, read each character and detect if there is a letter or symbol and print an ERROR if true
  if (check_octave) {
    isNumber = true;
    for (int i=0; i<in_frequency.length (); i++) {
      char character = in_frequency.charAt(i);
      if ((character >= 'A' && character <= 'Z') || (character >= 'a' && character <= 'z') || 
        (character== ' ') || (character== ',') || (character== '-') || (character== '!') || 
        (character== '"') || (character== '·') || (character== '$') || (character== '%') || 
        (character== '&') || (character== '/') || (character== '(') || (character== ')') || 
        (character== '=') || (character== '?') || (character== '¿') || (character== '`') || 
        (character== '+') || (character== '*') || (character== '{') || (character== '}') || 
        (character== '_') || (character== ':') || (character== '@') || (character== '|') || 
        (character== '#') || (character== '') || (character== '∞') || (character== '>') || 
        (character== '<')) {
        fill(200, 0, 0);
        textSize(width/50);
        text("ERROR. "+ "\n" +"Type only numbers and a dot for decimals", width/14, height*0.75);
        isNumber = false;
      }
    }

    //If there is no error (input is typed correctly):
    if (isNumber) {
      float f = Float.parseFloat(in_frequency);

      //EXERCISE 1, check the value of f for the different ranges and print the corresponing message
      if (32.70 <= f && f < 65.41) {
        fill(0, 100, 0);
        textSize(width/50);
        text(f + " Hz" +" frequency corresponds to Octave 1", width/14, height*0.75);
      } else if (65.41 <= f && f < 130.81) {
        fill(0, 150, 0);
        textSize(width/50);
        text(f + " Hz" +" frequency corresponds to Octave 2", width/14, height*0.75);
      } else if (130.81 <= f && f < 261.63) {
        fill(0, 200, 0);
        textSize(width/50);
        text(f + " Hz" +" frequency corresponds to Octave 3", width/14, height*0.75);
      } else if (261.63 <= f && f < 523.25) {
        fill(0, 250, 0);
        textSize(width/50);
        text(f + " Hz" +" frequency corresponds to Octave 4", width/14, height*0.75);
      } else {
        fill(200, 0, 0);
        textSize(width/50);
        text("ERROR. "+ "\n" +f + " Hz" +" frequency is out of bounds", width/14, height*0.75);
      }
    }
  }
}


void octaveFinder() {

  textSize(width/40);
  fill(0, 150, 0);
  text("Sing or play an instrument:", (width/14)*8, (height/3));

  //Check if mouse is inside circle
  stroke(50);
  inside_circle = false;
  float isInsideCircle = pow((circle_x-mouseX), 2)+pow((circle_y-mouseY), 2);
  if (isInsideCircle<pow((height/8), 2)) {
    stroke(0, 255, 0);
    inside_circle = true;
  }
  fill(0);
  ellipse(circle_x, circle_y, height/4, height/4);

  //If mouse is inside circle:
  if (isInsideCircle<pow((height/8), 2)) {

    // Following part of code EXTRACTED from: http://creativec0d3r.blogspot.ie/2013/01/how-to-get-frequency-values-from-mic.html
    // in order to analyze frequencies coming from computer micro
    //**************************** 
    fft.forward(in.left);
    for (int f=0; f<sampleRate/2; f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
      max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value
    }
    maximum=max(max);//get the maximum value of the max array in order to find the peak of volume

    for (int i=0; i<max.length; i++) {// read each frequency in order to compare with the peak of volume
      if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
        frequency= i;
      }
    }
    midi= 69+12*(log((frequency-6)/440));// formula that transform frequency to midi numbers
    n= int (midi);//cast to int
    //****************************

    //Print different messages depending on freq. (freq. is in MIDI value)
    fill(255);
    if (60<=n && n<72) {
      fill(0, 250, 0);
      textSize(width/50);
      text("Octave 4", (width/14)*8, height*0.75);
    } else if (48<=n && n<60) {
      fill(0, 200, 0);
      textSize(width/50);
      text("Octave 3", (width/14)*8, height*0.75);
    } else if (36<=n && n<48) {
      fill(0, 150, 0);
      textSize(width/50);
      text("Octave 2", (width/14)*8, height*0.75);
    } else if (24<=n && n<36) {
      fill(0, 100, 0);
      textSize(width/50);
      text("Octave 1", (width/14)*8, height*0.75);
    } else {
      fill(200, 0, 0);
      textSize(width/50);
      text("Out of Bounds", (width/14)*8, height*0.75);
    }
    fill(255);
    text(int(frequency) + " Hz", (width/14)*8, height*0.8);
  }
}


// Function to store frequency value when ENTER key is pressed and add characters to the input string
void keyTyped() {
  if (inside_box) {
    char k = key;
    if (k== ENTER) {
      in_frequency = txt;
      txt = "";
      check_octave = true;
    } else txt += str(k);
  }
}

