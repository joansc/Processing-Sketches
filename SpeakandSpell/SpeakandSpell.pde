
/*******************************************************
 ********************************************************
 **************** 3. SPEAK AND SPELL PLAYER *****************
 ****************** by JOAN SANDOVAL ********************
 ********************************************************
 *******************************************************/


//Importing minim library and defining global variables
Minim minim; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
AudioPlayer[] player = new AudioPlayer[12]; 


PImage space_photo;
PImage space_invader;
PFont numbers;

int invader_posx = 10;
int invader_posy = 30;
boolean direction = true;
int check_color = 11;

int fire = 3000;
int last = -3100;

int score = 0;


ArrayList<Missile> missiles;


void setup() {
  size(displayWidth, 750);
  frameRate(25);

  //load images and fonts
  space_photo = loadImage("space.jpg");
  space_invader = loadImage("space_invader.png");
  space_photo.resize(width, height);
  numbers = loadFont("font1.vlw");

  minim = new Minim(this);

  //storing differnt samples in an array
  player[0] = minim.loadFile("0.wav");
  player[1] = minim.loadFile("1.wav");
  player[2] = minim.loadFile("2.wav");
  player[3] = minim.loadFile("3.wav");
  player[4] = minim.loadFile("4.wav");
  player[7] = minim.loadFile("7.wav");
  player[8] = minim.loadFile("8.wav");
  player[9] = minim.loadFile("9.wav");
  player[10] = minim.loadFile("song.mp3");
  player[11] = minim.loadFile("fx.wav");   
  player[10].setGain(0);
  player[10].loop();

  //create an arrayList of missiles
  missiles = new ArrayList();
}


void draw() {

  draw_numbers();
  invader();
  missiles();


  //text and number of the score
  pushStyle();
  textFont(numbers, 30);
  fill(0, 255, 0);
  text("SCORE", (width/2)-57, height-120);
  text(score, (width/2)-15, height-80);
  popStyle();
}

void draw_numbers() {
  background(0);
  background(space_photo);
  textFont(numbers, 80);
  
  //Here I create the different number, make them change to colour when pressed and create 
  // a missile everytime a number is pressed, taking into account when the last one was created
  if (check_color == 1) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((1*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("1", (1*width/11)-30, height-50);
  if (check_color == 2) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((2*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("2", (2*width/11)-30, height-50);
  if (check_color == 3) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((3*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("3", (3*width/11)-30, height-50);
  if (check_color == 4) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((4*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("4", (4*width/11)-30, height-50);
  if (check_color == 7) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((7*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("7", (7*width/11)-30, height-50);
  if (check_color == 8) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((8*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("8", (8*width/11)-30, height-50);
  if (check_color == 9) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((9*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("9", (9*width/11)-30, height-50);
  if (check_color == 0) {
    fill(255, 0, 0);
    if (fire<=millis()-last) {
      missiles.add (new Missile((10*width/11)-5, height-120, 4, 5, 15));
      last=millis();
    }
  } else fill(255);
  text("0", (10*width/11)-30, height-50);
}




void invader() {
  
  //creation of the invader, following a line path
  image(space_invader, invader_posx, invader_posy, 50, 50);
  if (invader_posx > (width-60)) {
    direction = false;
  }
  if (invader_posx < 10) {
    direction = true;
  }
  if (direction) {
    invader_posx+=4;
  }
  if (!direction) {
    invader_posx-=4;
  }
}

void missiles() {
  
  //going to every missile shot, update its position and see if it is touching the invader
  for (Missile currentMissile : missiles ) {   
    currentMissile.move();
    currentMissile.display();
    
    //algorithm to know if the missile is touchink the invader
    float isTouchingAlien = pow(((invader_posx+25)-(currentMissile.x+2)), 2)+pow(((invader_posy+25)-currentMissile.y), 2);
    if (isTouchingAlien<(pow(13, 2)+150)) {      
      //putting the missile so far of the screen size to make it disappear
      currentMissile.x = 3000;
      currentMissile.y = 3000;
      invader_posx =10;
      invader_posy =30;
      
      //Making a particular sound when a missile touch the invader
      player[11].setGain(-10);
      player[11].play();
      player[11].rewind();
      score++;
    }
  }
}


// Playing back different sounds when the different number keys are pressed
// Also changing some variables for then at the draw(), knowing from where the missile has
// to be shot or to make the number change the colour
void keyPressed() {
  noStroke();
  fill(255, 0, 0);
  switch(key) {
  case '1':
    text("1", (width/11)-30, height-50);
    check_color = 1;
    player[1].setGain(-10);
    player[1].play();
    player[1].rewind();
    break;
  case '2':
    text("2", (2*width/11)-30, height-50);
    check_color = 2;
    player[2].setGain(-10);
    player[2].play();
    player[2].rewind();
    break;
  case '3':
    text("3", (3*width/11)-30, height-50);
    check_color = 3;
    player[3].setGain(-10);
    player[3].play();
    player[3].rewind();
    break;
  case '4':
    text("4", (4*width/11)-30, height-50);
    check_color = 4;
    player[4].setGain(-10);
    player[4].play();
    player[4].rewind();
    break;
  case '7':
    text("7", (7*width/11)-30, height-50);
    check_color = 7;
    player[7].setGain(-10);
    player[7].play();
    player[7].rewind();
    break;
  case '8':
    text("8", (8*width/11)-30, height-50);
    check_color = 8;
    player[8].setGain(-10);
    player[8].play();
    player[8].rewind();
    break;
  case '9':
    text("9", (9*width/11)-30, height-50);
    check_color = 9;
    player[9].setGain(-10);
    player[9].play();
    player[9].rewind();
    break;
  case '0':
    text("0", (10*width/11)-30, height-50);
    check_color = 0;
    player[0].setGain(-10);
    player[0].play();
    player[0].rewind();
    break;
  }

  //Using SPACEBAR to clear the missiles shot
  if (key == ' ') {
    for (Missile currentMissile : missiles ) {
      currentMissile.x = 3000;
      currentMissile.y = 3000;
    }
  }
}

//When the number key is released, change the colour again to white
void keyReleased() {
  noStroke();
  fill(255);
  switch(key) {
  case '1':
    text("1", (width/11)-30, height-50);
    check_color = 11;
    break;
  case '2':
    text("2", (2*width/11)-30, height-50);
    check_color = 11;
    break;
  case '3':
    text("3", (3*width/11)-30, height-50);
    check_color = 11;
    break;
  case '4':
    text("4", (4*width/11)-30, height-50);
    check_color = 11;
    break;
  case '7':
    text("7", (7*width/11)-30, height-50);
    check_color = 11;
    break;
  case '8':
    text("8", (8*width/11)-30, height-50);
    check_color = 11;
    break;
  case '9':
    text("9", (9*width/11)-30, height-50);
    check_color = 11;
    break;
  case '0':
    text("0", (10*width/11)-30, height-50);
    check_color = 11;
    break;
  }
}