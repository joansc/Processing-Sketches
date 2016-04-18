/**************************************************** //<>// //<>//
 MMT: DSP & Audio Programming
 ****************************************************
 * 
 * Processing Sketch by Joan Sandoval
 * 
 ***********************************/


//import libraries
import processing.serial.*;  
import ddf.minim.*;
import ddf.minim.ugens.*;
import controlP5.*;

//Variables for getting the data from Arduino
Serial port; 
int [] inputs = new int[6];
String stringIn;
boolean avoid_error = false;

//Variables for the different blocks
int var1, var2, var3, var4;
boolean one_block1 = true;
boolean one_block2 = true;
boolean one_block3 = true;
boolean one_block4 = true;

//Arraylist of Objects Figure
ArrayList<Figure> figures;


//Minim initialisation variables
Minim minim;
AudioOutput out1;
AudioOutput out2;
AudioOutput out3;
AudioOutput out4;
Oscil wave;
Oscil wave1;
Oscil wave2;
Oscil wave3;

//Variables User Interface
boolean display = false;
ControlP5 cp5;
controlP5.Slider sineh;
controlP5.Slider triangleh;
controlP5.Slider squareh;
controlP5.Slider sawh;
int sine = 0;
int triangle = 0;
int square = 0;
int saw = 0;



//SETUP, just once
void setup() {
  clear();
  size(displayWidth, displayHeight, P3D);
  //Serial port to get data
  port = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  frameRate(30);

  //Initialise inputs (I found sometimes I was receiving more than 4 values so 
  //I add two extra positions to not get errors)
  inputs[0]=0;
  inputs[1]=0;
  inputs[2]=0;
  inputs[3]=0;
  inputs[4]=0;
  inputs[5]=0;
  port.bufferUntil('\n');

  //variables initialisation
  figures = new ArrayList();
  minim = new Minim(this);
  out1 = minim.getLineOut( Minim.STEREO, 1024 );
  out2 = minim.getLineOut( Minim.STEREO, 1024 );
  out3 = minim.getLineOut( Minim.STEREO, 1024 );
  out4 = minim.getLineOut( Minim.STEREO, 1024 );

  background(0);

  //fill array with zeros
  for (int i=0; i < inputs.length; i++) {         
    inputs[i] = 0;
  }

  //Initialisation User Interface variables
  cp5 = new ControlP5(this);

  sineh = cp5.addSlider("sine")
    .setPosition(width/3-150, 260)
    .setSize(35, 300)
    .setRange(0, 255)
    .setColorValue(color(255, 0, 0, 75))
    .setColorBackground(color(100, 0, 0, 75))
    .setColorForeground(color(200, 0, 0, 75))
    .setColorActive(color(255, 0, 0, 75))
    ;

  triangleh = cp5.addSlider("triangle")
    .setPosition(width/2-150, 260)
    .setSize(35, 300)
    .setRange(0, 255)
    .setColorValue(color(0, 255, 0, 75))
    .setColorBackground(color(0, 100, 0, 75))
    .setColorForeground(color(0, 200, 0, 75))
    .setColorActive(color(0, 255, 0, 75));
  ;

  squareh = cp5.addSlider("square")
    .setPosition(width*2/3-150, 260)
    .setSize(35, 300)
    .setRange(0, 255)
    .setColorValue(color(0, 0, 255, 75))
    .setColorBackground(color(0, 0, 100, 75))
    .setColorForeground(color(0, 0, 200, 75))
    .setColorActive(color(0, 0, 255, 75));
  ;

  sawh = cp5.addSlider("saw")
    .setPosition(width*5/6-150, 260)
    .setSize(35, 300)
    .setRange(0, 255)
    .setColorValue(color(255, 0, 255, 75))
    .setColorBackground(color(100, 0, 100, 75))
    .setColorForeground(color(200, 0, 200, 75))
    .setColorActive(color(255, 0, 255, 75));
  ;
}




//DRAW
void draw() {

  background(0);
  //variables received from Arduino (one for each FSR sensor)

  var1 = inputs[0];
  var2 = inputs[1];
  var3 = inputs[2];
  var4 = inputs[3];


  if (display) {
    var1 = sine;
    var2 = triangle;
    var3 = square;
    var4 = saw;
  }


  //change audio amplitude, first do mapping between values
  float amplitude1 = map(var1, 0, 255, 0, 1);
  float amplitude2 = map(var2, 0, 255, 0, 1);
  float amplitude3 = map(var3, 0, 255, 0, 1);
  float amplitude4 = map(var4, 0, 255, 0, 1);

  //BLOCK 1

  //if the FSR is not zero and the shape is not created yet
  if (var1>1 && one_block1) {
    //Create new Object
    figures.add(new Figure(1, int(random(0+50, width-50)), int(random(0+50, height-50)), int(random(1, 10)), random(0.01, 0.5), random(0.01, 0.5), "1"));
    one_block1 = false;
    /*Wavetable myEnv = WavetableGenerator.gen7( 8192, 
     new float[] { 0.00, 1.00, 0.15, 1.00, 0.00 }, 
     new int[]   { 1024, 1024, 64, 6080 }  );*/

    //Create sine waveform with random frequency
    wave = new Oscil( random(50, 1500), 0.1, Waves.SINE );
    wave.patch( out1 );
  }

  //BLOCK 2

  if (var2>1 && one_block2) {
    figures.add(new Figure(1, int(random(0+50, width-50)), int(random(0+50, height-50)), int(random(1, 10)), random(0.01, 0.5), random(0.01, 0.5), "2"));
    one_block2 = false;

    //Create square waveform with random frequency
    wave1 = new Oscil( random(50, 1500), 0.1, Waves.SQUARE );
    wave1.patch( out2 );
  }

  //BLOCK 3

  if (var3>1 && one_block3) {
    figures.add(new Figure(1, int(random(0+50, width-50)), int(random(0+50, height-50)), int(random(1, 10)), random(0.01, 0.5), random(0.01, 0.5), "3"));
    one_block3 = false;

    //Create triangle waveform with random frequency
    wave2 = new Oscil( random(50, 1500), 0.1, Waves.TRIANGLE );
    //wave2 = new Oscil( random(500, 1000), 0.1, myEnv );
    wave2.patch( out3 );
  }

  //BLOCK 4

  if (var4>1 && one_block4) {
    figures.add(new Figure(1, int(random(0+50, width-50)), int(random(0+50, height-50)), int(random(1, 10)), random(0.01, 0.5), random(0.01, 0.5), "4"));
    one_block4 = false;

    //Create saw waveform with random frequency
    wave3 = new Oscil( random(50, 1500), 0.1, Waves.SAW );
    //wave3 = new Oscil( random(1000, 2000), 0.1, myEnv );
    wave3.patch( out4 );
  }

  //Change amplitude values depending on FSR values received
  if (var1>1) wave.setAmplitude(amplitude1);
  if (var2>1) wave1.setAmplitude(amplitude2);
  if (var3>1) wave2.setAmplitude(amplitude3);
  if (var4>1) wave3.setAmplitude(amplitude4);

  //Booleans for not creating more objects once they are created once
  if (var1<1) one_block1 = true;
  if (var2<1) one_block2 = true;
  if (var3<1) one_block3 = true;
  if (var4<1) one_block4 = true;

  //call function
  figures();

  hideSliders();
}



void figures() {

  //Iterate through the objects that exist
  for (int i=0; i<figures.size(); i++) { 


    //BLOCK 1

    if (figures.get(i).block == "1") {
      //Set object properties
      figures.get(i).display(0.01, 0.3, 255, 0, 0, 255, 1.5);
      figures.get(i).sizeblock(int(map(var1, 0, 255, 0, 60)));
      //draw circular waveform
      float waveform_size1 = map(var1, 0, 255, 0, 50);
      noStroke();
      pushMatrix();
      translate(figures.get(i).x, figures.get(i).y);
      rotate(radians(frameCount % 360 * 2));
      for (int j = 0; j < 360; j++) {
        stroke(100, 0, 0);
        strokeWeight(1);
        line(cos(j)*waveform_size1, sin(j)*waveform_size1, cos(j)*abs(out1.left.get(j))*150 + cos(j)*10, sin(j)*abs(out1.right.get(j))*150 + sin(j)*10);
      }
      popMatrix();
    }


    //BLOCK 2

    if (figures.get(i).block == "2") {
      figures.get(i).display(0.1, 0.1, 0, 255, 0, 255, 1);
      figures.get(i).sizeblock(int(map(var2, 0, 255, 0, 60)));
      float waveform_size2 = map(var1, 0, 255, 0, 50);
      noStroke();
      pushMatrix();
      translate(figures.get(i).x, figures.get(i).y);
      rotate(radians(frameCount % 360 * 2));
      for (int j = 0; j < 360; j++) {
        stroke(0, 100, 0);
        strokeWeight(1);
        line(cos(j)*waveform_size2, sin(j)*waveform_size2, cos(j)*abs(out2.left.get(j))*150 + cos(j)*1, sin(j)*abs(out2.right.get(j))*150 + sin(j)*1);
      }
      popMatrix();
    }


    //BLOCK 3

    if (figures.get(i).block == "3") {
      figures.get(i).display(-0.05, 0, 0, 0, 255, 255, 3);
      figures.get(i).sizeblock(int(map(var3, 0, 255, 0, 60)));
      float waveform_size3 = map(var3, 0, 255, 0, 50);
      noStroke();
      pushMatrix();
      translate(figures.get(i).x, figures.get(i).y);
      rotate(radians(frameCount % 360 * 2));
      for (int j = 0; j < 360; j++) {
        stroke(0, 0, 100);
        strokeWeight(1);
        line(cos(j)*waveform_size3, sin(j)*waveform_size3, cos(j)*abs(out3.left.get(j))*150 + cos(j)*1, sin(j)*abs(out3.right.get(j))*150 + sin(j)*1);
      }
      popMatrix();
    }


    //BLOCK 4

    if (figures.get(i).block == "4") {
      figures.get(i).display(-0.1, 0.05, 255, 0, 255, 255, 3);
      figures.get(i).sizeblock(int(map(var4, 0, 255, 0, 60)));
      float waveform_size4 = map(var3, 0, 255, 0, 50);
      noStroke();
      pushMatrix();
      translate(figures.get(i).x, figures.get(i).y);
      rotate(radians(frameCount % 360 * 2));
      for (int j = 0; j < 360; j++) {
        stroke(75, 0, 75);
        strokeWeight(1);
        line(cos(j)*waveform_size4, sin(j)*waveform_size4, cos(j)*abs(out4.left.get(j))*150 + cos(j)*1, sin(j)*abs(out4.right.get(j))*150 + sin(j)*1);
      }
      popMatrix();
    }



    //Create the linking lines
    stroke(255);
    int steps = 10;
    float scribVal = 3.0;
    strokeWeight(3);
    if (i>0) {
      scribble(figures.get(i).x, figures.get(i).y, figures.get(i-1).x, figures.get(i-1).y, steps, scribVal*2);
    }


    //Removing objects when the FSR are not pressed any more

    //BLOCK 1
    if (one_block1 && figures.size()!=0 && (figures.size()-i)>0) {
      if (figures.get(i).block == "1") {
        wave.unpatch(out1);
        figures.remove(i);
      };
    }

    //BLOCK 2
    if (one_block2 && figures.size()!=0 && (figures.size()-i)>0) {
      if (figures.get(i).block == "2") {
        wave1.unpatch(out2);
        figures.remove(i);
      };
    }

    //BLOCK 3
    if (one_block3 && figures.size()!=0 && (figures.size()-i)>0) {
      if (figures.get(i).block == "3") {
        wave2.unpatch(out3);
        figures.remove(i);
      };
    }

    //BLOCK 4
    if (one_block4 && figures.size()!=0 && (figures.size()-i)>0) {
      if (figures.get(i).block == "4") {
        wave3.unpatch(out4);
        figures.remove(i);
      };
    }
  }
}





//Here I read and get the data coming from the serial port
void serialEvent(Serial port) { 
  String stringIn = port.readStringUntil('\n');
  if (stringIn != null) {
    stringIn = trim(stringIn);
    if (avoid_error && stringIn.contains(",")) {
      inputs = int(split(stringIn, ","));
      //println(stringIn);
      //println(inputs[0]+"\t"+inputs[1]+"\t"+inputs[2]+"\t"+inputs[3]);
    }
    avoid_error = true;
  }
}



//Create the linking lines
void scribble(float x1, float y1, float x2, float y2, int steps, float scribVal) {
  float xStep = (x2-x1)/steps;
  float yStep = (y2-y1)/steps;
  for (int i=0; i<steps; i++) {
    if (i<steps-1) {
      line(x1, y1, x1+=xStep+random(-scribVal, scribVal), y1+=  yStep+random(-scribVal, scribVal));
    } else {
      line(x1, y1, x2, y2);
    }
  }
}


void hideSliders() {
  if (display == false) {
    sineh.hide();
    triangleh.hide();
    squareh.hide();
    sawh.hide();
  } else {
    sineh.show();
    triangleh.show();
    squareh.show();
    sawh.show();
  }
}



//PRESS s to show the User Interface and h to hide it
void keyPressed() {
  if (key == 'h') {
    display = false;
  }
  if (key == 's') {
    display = true;
  }
}