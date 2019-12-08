PGraphics canvas;
CanvasController canvasController;
int iterations = 100;
int plainSize = 4;
int lastTimeCheck;
int timeIntervalFlag = 3000; 
void settings() {
  fullScreen();
}

void setup() {
  background(0);
  noStroke();
  canvasController = new CanvasController(generate(iterations));
  image(canvasController.currentCanvas, (displayWidth - displayHeight) / 2 , 0);
  
  lastTimeCheck = millis();
}


void draw() {
  if ( millis() > lastTimeCheck + timeIntervalFlag ) {
    lastTimeCheck = millis();
  }
}
void applyImage() {
  image(canvas, (displayWidth - displayHeight) / 2 , 0);
}
float posX = 0;
float posY = 0;
float zoom = 1;


void mousePressed() {
  int offset = (displayWidth - displayHeight) / 2;
  int diffX = displayHeight / 2 - mouseX + offset;
  int diffY =  displayHeight / 2 - mouseY;
  zoom = zoom / 100;
  
  float[] coord = GetCoordinate(displayHeight / 2 - diffX, (displayHeight / 2) - diffY);
  
  posX = coord[0];
  posY = coord[1];
  canvas = generate(iterations);
  image(canvas, offset, 0);
}

void keyPressed() {
  if (key == ESC) {
    exit();
  }
}

void render() {
  canvas = generate(iterations);
  iterations += 100;
}


PGraphics generate(int iterations) {
  PGraphics pg = createGraphics(displayWidth, displayHeight);
  pg.beginDraw();
  pg.background(0);
  colorMode(HSB, iterations);
  for (int x = 0; x < displayHeight; x++) {
    for (int y = 0; y < displayHeight; y++) {
      float[] coord = GetCoordinate(x, y);
      float a = (coord[0] * zoom) + posX;
      float b = (coord[1] * zoom) + posY;
      float bkA = a;
      float bkB = b;
      
      int i = 0;
       while(i <= iterations) {
          float aa = a * a - b * b;
          float bb = 2 * a * b;
      
          a = aa + bkA;
          b = bb + bkB;
          if (abs(a + b) > 16) {
           break; 
          }
          i++;
        }
        
        if (i < iterations) {
          color c = color(i, iterations, iterations);
          pg.stroke(c);
        } else {
          pg.stroke(0);
        }
         
        pg.point(x, y);
    }
  }
  pg.endDraw();

  return pg;
}


float[] GetCoordinate(float x, float y) {
  float a = (((x * (plainSize)) / displayHeight) - 2);
  float b = (((y * (plainSize)) / displayHeight) - 2);
   
  float[] coord = {a, b};
  
  return coord;
}
