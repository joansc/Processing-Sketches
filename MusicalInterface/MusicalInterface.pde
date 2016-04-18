
/*******************************************************
 ********************************************************
 **************** 4. MUSICAL INTERFACE *****************
 ****************** by JOAN SANDOVAL ********************
 ********************************************************
 *******************************************************/


//Importing libraries and definition of Global Variables
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*;
import controlP5.*;

Minim minim;
AudioOutput out;
Oscil       wave;
LiveInput in;
Wavetable   table;
ControlP5 cp5;
AudioPlayer song;
controlP5.Button b;

//Variables for images
PImage wallpaper;
PImage voc_photo;

//Variables for animation
int anim1 = 0;
boolean animbool = false;

//Initialisation of different parameters for the synth processing
int Number_Harmonics = 16;
int Frequency_tone = 400;
int Scale_value = 1;
int Num_Harm = 16;
float amp = 1;

//Different variables for buttons/toggle/sliders...
boolean toggleValue = true;
boolean mute;
boolean play_stop = true;
Knob myKnobA;



void setup() {

  size(displayWidth, 750);

  //loading images
  wallpaper = loadImage("wallpaper.jpg");
  wallpaper.resize(width, height);
  voc_photo = loadImage("vocoder-photo.png");

  //Creation of different buttons/sliders elements
  cp5 = new ControlP5(this);

  cp5.addNumberbox("Frequency_Tone")
    .setPosition(120, 600)
      .setSize(100, 20)
        .setScrollSensitivity(1.1)
          .setRange(32, 1000)
            .setValue(400)
              ;

  myKnobA = cp5.addKnob("harmonics")
    .setRange(0, 32)
      .setValue(16)
        .setPosition(125, 70)
          .setRadius(50)
            .setDragDirection(Knob.VERTICAL)
              ;


  cp5.addSlider("amplitude")
    .setPosition(970, 70)
      .setSize(200, 20)
        .setRange(0, 2)
          .setValue(1)
            ;

  cp5.addToggle("MUTE_UNMUTE")
    .setPosition(1100, 600)
      .setSize(50, 20)
        .setValue(true)
          .setMode(ControlP5.SWITCH)
            ;

  b = cp5.addButton("Play_Song")
    .setValue(128)
      .setPosition(580, 650)
        .setSize(110, 30)
          ;
  b.setSwitch(true);


  //****** Part based on the vocoderExample of the Minim Library examples

  // initialize minim objects
  minim = new Minim(this);

  out = minim.getLineOut();
  song = minim.loadFile("DaftPunk.mp3");

  // construct a LiveInput with same properties as the output
  AudioStream inputStream = minim.getInputStream( Minim.MONO, 
  out.bufferSize(), 
  out.sampleRate(), 
  out.getFormat().getSampleSizeInBits()
    );
  in = new LiveInput( inputStream );
  // create the vocoder with a 1024 sample frame FFT and 3 overlapping windows
  Vocoder vocode = new Vocoder( 1024, 8 );

  //****** Part based on the wavetableMethods sketch of the Minim Library examples

  //creation of wavetable
  table = Waves.randomNHarms(Number_Harmonics);
  
  // defining the input signal as the modulator (same as original vocoders)
  in.patch( vocode.modulator );
  
  //Creation of tone
  wave  = new Oscil( 440, 0.5f, table );
  
  //sending the tone to the vocoder
  wave.patch( vocode ).patch( out );
}


void draw() {
  
  //Play/Stop the song
  play_stop = b.getBooleanValue();
  if (play_stop) {
    song.play();
  } else song.pause();


  //Mute/Unmute the vocoder
  if (!mute) out.mute();
  else out.unmute();
  
  //Change the parameters of the vocoder: frequency of the tone, amplitude or creating a new waveform
  wave.setFrequency(Frequency_tone);
  wave.setAmplitude(amp);
  wave.setWaveform(table);

  //Animation
  waveform_animation();


  // draw the waveform we are using in the oscillator
  stroke( 193, 84, 0 );
  strokeWeight(4);
  int c=0;
  for ( int i = 0; i < (width-1); i+=2 )
  {
    point(c+((width/2)-320), (height/2) - (height*0.05) * table.value( (float)i / width ) );
    c++;
  }
}


//METHODS AND FUNCTIONS




void waveform_animation() {

  //Variable to change colors of the circle
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


  background(wallpaper);

  //title
  image(voc_photo, (width/2)-150, 10, 300, 50);
  fill(0, 0, 0, 0);
  strokeWeight(3);
  int circle_posx = width/2;
  int circle_posy = height/2;
  stroke(anim1, 0, 0);  
  //circle
  ellipse(width/2, height/2, 500, 500);
  stroke(100, 0, 0);
  strokeWeight(1);


  // draw the waveform of the output
  for (int i = 0; i < out.bufferSize () - 1; i++)
  {
    float isInsideCircle = pow(((width/2)-i), 2)+pow(((height/2)-((height/2)-50) - out.left.get(i)*1), 2);
    if (isInsideCircle<(pow(250, 2))) {
      line( i, ((height/2)-50) - out.left.get(i)*1, i+1, ((height/2)-55) - out.left.get(i+1)*80 );
      line( i, ((height/2)+50) - out.right.get(i)*1, i+1, ((height/2)+55) - out.right.get(i+1)*80 );
    }
  }
}


//Dragging the mouse on the waveform will authomatically change its form, and how would be the morphing between the tone and voice
void mouseDragged()
{
  if ( mouseButton == LEFT && pmouseX > 250 && pmouseX < (width-250) && pmouseY < (height-200) && pmouseY > 200)
  {
    float warpPoint = constrain( (float)pmouseX / width, 0, 1 );
    float warpTarget = constrain( (float)mouseX / width, 0, 1 );
    table.warp( warpPoint, warpTarget );
  }
}


//Functions for the different buttons,slidders,toggles,...
void Frequency_Tone(int theTone) {

  Frequency_tone = theTone;
}

void harmonics(int NHarmonics) {
  table = Waves.randomNHarms(NHarmonics);
}

void amplitude(float Amplitude) {
  amp = Amplitude;
}

void MUTE_UNMUTE(boolean on) {
  mute = on;
}


//Create a new Waveform
void keyPressed() {

  if (keyCode == ENTER) {
    table = Waves.randomNHarms(Num_Harm);
  }
}

