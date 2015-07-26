class BG {

  final color BG = color(20);
  final color NORMC = color(127, 140, 141);

  float x, y;
  float currentX, currentY;
  float w, h;
  float currentW, currentH;

  float scale = 0.7;

  boolean fullscreenActiv = false;

  BG(float x, float y, float w, float h, boolean f) {
    this.x = x;
    this.y = y;
    this.currentX = x;
    this.currentY = y;
    this.w = w;
    this.h = h;
    this.currentW = w;
    this.currentH = h;
    this.fullscreenActiv = f;
  }

  void update() {
    if (fullscreenActiv) {
      currentX = 0;
      currentY = 0;
      currentW = width;

      scale = 0.9;
    }
    else {
      currentX = x;
      currentY = y;
      currentW = w;

      scale = 0.7;
    }
  }

  void draw() {
    pushStyle();
    fill(BG);
    noStroke();

    pushMatrix();
    translate(currentX, currentY);

    rect(0, 0, currentW, currentH);

    fill(NORMC);

    ellipse(0 + (currentW*0.5), 0 + (currentH*0.5), currentH * scale, currentH * scale);

    popMatrix();
    popStyle();
  }
}
