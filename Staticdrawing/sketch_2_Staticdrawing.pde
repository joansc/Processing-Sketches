
/*******************************************************
 ********************************************************
 ****************** 2. STATIC DRAWING *******************
 ****************** by JOAN SANDOVAL ********************
 ********************************************************
 *******************************************************/

/**** CONCEPT AND ARTISTIC MOTIVATION FOR THE PIECE:

Two main ideas have been considered when creating this piece:

  - Expanded Eye(http://cargocollective.com/expandedeye/tattoo): In my opinion, one of the best art tattoo 
    groups that exist. Incredible abstract and minimalist draws. Some of its ideas have been made here, 
    like the face, raindrops, triangles,... 
    
  - Joan Miró(http://www.joan-miro.net/joan-miro-paintings.jsp): One of my favourite paintors (also catalan).
    Surrealist paintor whose paintings show minimalist figures and lines and also a variety of intense 
    colors. In my piece, it can be seen the minimalistic lines, dots and shapes.
    
    
Free interpretation and understanding of the piece. 'Less is More' phrase used in order to reference again the
Minimalism.

*****/


//CODE

//GLOBAL VARIABLES
int i_sum = 0;
int m_sum = 0;

void setup() {
  
  // CHOOSE SCREEN SIZE
  
  size(1200, 300);
  //size(800, 600);
  //size(600,250);
  
  background(255);
  
  //Calling functions
  pyramidtriangles();
  complex_line();
  face();
  lines();
  square();
  raindrops();
  lines_right();
  title();
  
}

// FUNCTIONS


void pyramidtriangles() {

  fill(0);
  //Making a matrix of triangles
  for (int m=0; m<5; m++) {
    for (int i =0; i<10; i++) {
      triangle((width/20)+m_sum, (height/6)+i_sum, (width/20)+m_sum, (height/6)+10+i_sum, (width/20)+20+m_sum, (height/6)+5+i_sum);
      i_sum+=10;
    }
    m_sum+=20;
    i_sum=0;
  }
  fill(255);
  noStroke();
  //Drawing a white triangle on the matrix in order to have this cutting effect
  triangle((width/20), (height/6), (width/20)+m_sum+2, (height/6), (width/20)+m_sum+2, (height/6)+40);
}


void complex_line() {
  stroke(0);
  fill(255);
  int density =3;
  //Making the column with a line pattern inside
  rect((width/20)+m_sum+2, (height/6)+45, 8, 50);
  for (int rect_y = (height/6)+42; rect_y<(height/6)+90; rect_y+=density) {
    line((width/20)+m_sum+2, rect_y+density, (width/20)+m_sum+10, rect_y+4+density);
  }
  fill(0);
  //Making the black column
  rect((width/20)+m_sum+2, (height/6)+95, 8, 50);
}


void face() {
  stroke(0);
  line((width/20)+m_sum+2+8, (height/6)+45, (width/20)+m_sum+70, (height/6)+45);
  line((width/20)+m_sum+70, (height/6)+45, (width/20)+m_sum+90, (height/6)+100);
  //Using curve to draw the nose of the face
  curve(width/4, height/4, (width/20)+m_sum+90, (height/6)+100, (width/20)+m_sum+60, (height/6)+100, width/3, height/3);
  stroke(0);
  strokeWeight(1);
  fill(255);
  //Drawing the eye
  ellipse((width/20)+m_sum+70, (height/6)+60, 20, 20);
  fill(0);
  ellipse((width/20)+m_sum+74, (height/6)+63, 5, 5);
  ellipse((width/20)+m_sum+68, (height/6)+58, 5, 5);
}


void lines() {
 stroke(0);
  //Drawing the dash line
  dashline((width/20)+m_sum+90, (height/6)+60, (width/20)+m_sum+(width/3), (height/6)+60,5,4);
}


void square() {

  stroke(0);
  fill(255);
  strokeWeight(2);
  noSmooth();
  //Drawing the square
  rect((width/20)+m_sum+(width/3)+15, (height/6)+25,70,70);
  stroke(255);
  //To delete one line of the square I paint a new white line above
  line((width/20)+m_sum+(width/3)+85,(height/6)+26,(width/20)+m_sum+(width/3)+85,(height/6)+94);
  smooth();
}


void raindrops() {
  fill(0);
  noStroke();
  //Drawing 10 raindrops
  for (int i=0; i<10; i++) {
    int r = int(random(2,5));
    int x_len = int(random((width/20)+m_sum+(width/3)+15,(width/20)+m_sum+(width/3)+85));
    int y_len = int(random(0,(height/6)+10));
    //Using curveVertex in order to draw the different raindrops
    beginShape();
    curveVertex(x_len, y_len);
    curveVertex(x_len, y_len);
    curveVertex(x_len+r, y_len+(2*r));
    curveVertex(x_len, y_len+(3*r));
    curveVertex(x_len-r, y_len+(2*r));
    curveVertex(x_len, y_len);
    curveVertex(x_len, y_len);
    endShape();
  } 
}


void lines_right(){
  
  //Drawing the different lines and dots on the right of the piece
  fill(255,0,0);
  triangle(width-(width/6)-10,height-(height/3),width-(width/10),height/3,width-(width/4),height/8);
  stroke(0);
  strokeWeight(2);
  line((width/20)+m_sum+(width/3)+85,(height/6)+25,width-(width/10)+10,height/2);
  line((width/20)+m_sum+(width/3)+85,(height/6)+94,width-(width/4),height/8);
  line(width-(width/10)+10,height/2,width-(width/10),height/3);
  line(width-(width/4),height/8,width-(width/6)-10,height-height/3);
  line(width-(width/10),height/3,width-(width/6)-10,height-(height/3));
  fill(0);
  ellipse(width-(width/4),height/8,8,8);
  ellipse(width-(width/10),height/3,8,8);
  ellipse(width-(width/10)+10,height/2,8,8);
  fill(255);
  ellipse(width-(width/6)-10,height-(height/3),8,8);
}


void title(){
  
  textSize(10);
  fill(0);
  //Adding the phrase
  text("L     E     S     S                I     S                 M     O     R     E",width/10,height-20);
  
}




//**********
//Code EXTRACTED from https://processing.org/discourse/beta/num_1202486379.html
// in order to draw a dash line

/*
 * Draw a dashed line with given set of dashes and gap lengths.
 * x0 starting x-coordinate of line.
 * y0 starting y-coordinate of line.
 * x1 ending x-coordinate of line.
 * y1 ending y-coordinate of line.
 * spacing array giving lengths of dashes and gaps in pixels;
 *  an array with values {5, 3, 9, 4} will draw a line with a
 *  5-pixel dash, 3-pixel gap, 9-pixel dash, and 4-pixel gap.
 *  if the array has an odd number of entries, the values are
 *  recycled, so an array of {5, 3, 2} will draw a line with a
 *  5-pixel dash, 3-pixel gap, 2-pixel dash, 5-pixel gap,
 *  3-pixel dash, and 2-pixel gap, then repeat.
 */
void dashline(float x0, float y0, float x1, float y1, float[ ] spacing)
{
  float distance = dist(x0, y0, x1, y1);
  float [ ] xSpacing = new float[spacing.length];
  float [ ] ySpacing = new float[spacing.length];
  float drawn = 0.0;  // amount of distance drawn

  if (distance > 0)
  {
    int i;
    boolean drawLine = true; // alternate between dashes and gaps

    /*
      Figure out x and y distances for each of the spacing values
     I decided to trade memory for time; I'd rather allocate
     a few dozen bytes than have to do a calculation every time
     I draw.
     */
    for (i = 0; i < spacing.length; i++)
    {
      xSpacing[i] = lerp(0, (x1 - x0), spacing[i] / distance);
      ySpacing[i] = lerp(0, (y1 - y0), spacing[i] / distance);
    }

    i = 0;
    while (drawn < distance)
    {
      if (drawLine)
      {
        line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]);
      }
      x0 += xSpacing[i];
      y0 += ySpacing[i];
      /* Add distance "drawn" by this line or gap */
      drawn = drawn + mag(xSpacing[i], ySpacing[i]);
      i = (i + 1) % spacing.length;  // cycle through array
      drawLine = !drawLine;  // switch between dash and gap
    }
  }
}

/*
 * Draw a dashed line with given dash and gap length.
 * x0 starting x-coordinate of line.
 * y0 starting y-coordinate of line.
 * x1 ending x-coordinate of line.
 * y1 ending y-coordinate of line.
 * dash - length of dashed line in pixels
 * gap - space between dashes in pixels
 */
void dashline(float x0, float y0, float x1, float y1, float dash, float gap)
{
  float [ ] spacing = { 
    dash, gap
  };
  dashline(x0, y0, x1, y1, spacing);
}




