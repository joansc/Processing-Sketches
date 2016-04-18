//Done a class for each object of each block

class Figure {

  int size_block;
  int x;
  int y;
  int detail ;  
  float rotX;
  float rotY;
  String block;

  Figure(int Size_block, int X, int Y, int Detail, float RotX, float RotY, String Block) {
    size_block = Size_block;
    x = X;
    y = Y;
    detail = Detail;
    rotX = RotX;
    rotY = RotY;
    block = Block;
  }

  void display(float rx, float ry, int c1, int c2, int c3, int Stroke, float strokeweight) {
    pushMatrix();
    translate(x, y, 0);
    rotateY(rotX+=rx);
    rotateX(rotY+=ry);
    sphereDetail(detail);
    fill(c1, c2, c3);
    stroke(Stroke);
    strokeWeight(strokeweight);
    sphere(size_block);
    popMatrix();
  }

  void sizeblock(int Size_Block) {
    size_block = Size_Block;
  }
}