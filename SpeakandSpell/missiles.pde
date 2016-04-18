
class Missile {

  int x;
  int y;
  int speed ;  
  int size_x;
  int size_y;

  Missile(int X, int Y, 
  int Speed, 
  int SizeX, int SizeY) {
    x = X;
    y = Y;
    size_x = SizeX;
    size_y = SizeY;
    speed = Speed;
  }

  void move() {
    y = y - speed;
  } 

  void display() {
    fill(255, 0, 0);
    noStroke();
    rect(x, y, size_x, size_y);
  }
}

