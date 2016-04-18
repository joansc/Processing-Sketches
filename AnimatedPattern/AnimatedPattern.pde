
/*******************************************************
 ********************************************************
 **************** 2. ANIMATED PATTERN *****************
 ****************** by JOAN SANDOVAL ********************
 ********************************************************
 *******************************************************/


/*




*/

//GLOBAL VARIABLES

//Variable for camera pos
float x, y, z;

//variable for iterating
int m=0;

//initialization of arrays
float[] x_pos = new float[800];
float[] y_pos = new float[800];
float[] velocity = new float[800];
float[] rotation = new float[800];

//variables used when calling the method
int incr = 0;
int f_start = 0;
int f_end = 29;
int f_z_axis = 600;
int f_dir = 1;
int f_col_r = 150;
int f_col_g = 0;
int f_col_b = 0;
float f_vel = 0;
float f_rot = 0;

void setup() {
  //CHOOSE SCREEN SIZE
  size(displayWidth, 750, P3D); // (Recommended for better visualisation)
  //size(800, 600,P3D);

  //Define the axis
  x = 0;
  y = 0;
  z = 0;

  //fill the arrays: velocity array with consecutive numbers in order to have a uniform distribution in the circle and don't touch each other(more or less)
  //                 rotation array with random values for different rotations for the different cubes
  for (int i=0; i<800; i++) {
    velocity[i]=incr;
    rotation[i]=random(0, 1);
    incr++;
  }
}


void draw() {
  background(0);
  noCursor();

  //Calling the custom method several times(with different values) for having multiple circles with cubes
  for (int i=0; i<25; i++) {
    animation(f_start, f_end, f_vel, f_rot, 200, f_z_axis, f_col_r, f_col_g, f_col_b, f_dir, 1,4,4);
    f_start +=30;
    f_end +=30;
    f_z_axis -=60;
    f_col_r-=8;
    f_vel+=0.001;
    f_rot+=0.001;
  }
  //Restart the parameters for the next iteration in the draw()
  f_start = 0;
  f_end = 29;
  f_z_axis = 600;
  f_col_r=150;
  f_vel = 0;
  f_rot = 0;
}

//custom method
void animation(int start, int finish, float vel, float rot, int dist, int z_axis, int col_r, int col_g, int col_b, int dir, int mult, int mult1, int mult2) {

  for (int m=start; m<finish; m++) {
    //creation of a sinus and cosinus functions in order to cubes follow a circle path
    x_pos[m] = mult*(((sin(2*PI+dir*velocity[m])+1)*(100-0)/(1+1))+0);
    y_pos[m] = mult*(((cos(2*PI+dir*velocity[m])+1)*(100-0)/(1+1))+0);
    pushMatrix();
    translate((mult1*x_pos[m]+width/2)-dist, (mult2*y_pos[m]+height/2)-dist, z_axis);
    rotateX(rotation[m]);
    rotateY(rotation[m]);
    rotateZ(rotation[m]);
    fill(col_r,col_g,col_b);
    noStroke();
    stroke(0);
    box(20);
    popMatrix();
    velocity[m]+= vel;
    rotation[m]+= rot;
  }
  
}

