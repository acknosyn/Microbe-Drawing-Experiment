class View {
  Btn cancel_btn, done_btn;
  Btn back_btn;

  CreateMicrobe create;

  final color NORMC = color(127, 140, 141);
  final color CREATEC = color(45, 45, 50, 200);

  ArrayList<Btn> buttons;

  float x, y;
  float fullscreenX, fullscreenY;
  float currentX, currentY;
  float w, h;
  float currentW, currentH;
  float drawW, drawH;
  float drawW2, drawH2, drawX, drawY;
  float drawX1, drawY1, drawX2, drawY2;

  float scale = 0.7;
  float diameter;

  boolean mode = false;
  boolean fullscreen = false;

  View(float x, float y, float w, float h, boolean m) {
    this.x = x;
    this.y = y;
    this.w = w * scale;
    this.h = h * scale;
    this.mode = m;

    this.fullscreenX = width/2;
    this.fullscreenY = height/2;
    this.currentX = x;
    this.currentY = y;
    this.currentW = w;
    this.currentH = h;

    this.drawW = this.w - (this.w * 0.2);
    this.drawH = this.h * 1.2;

    this.drawW2 = drawW * 0.9;
    this.drawH2 = drawH * 0.81;
    this.drawX = ((drawW - drawW2)/2) + x - (drawW/2);
    this.drawY = ((drawW - drawW2)/2) + y - (drawH/2);

    this.diameter = currentH * scale;

    create = new CreateMicrobe(this.drawX, this.drawY, this.drawW2, this.drawH2);

    buttons = new ArrayList<Btn>();

    cancel_btn = new Btn(x - (w * 0.130), y + (h * 0.35), w * 0.238, h * 0.08333333333, "Cancel", 18, false, false);
    done_btn = new Btn(x + (w * 0.130), y + (h * 0.35), w * 0.238, h * 0.08333333333, "Done", 18, false, false); // used to be x, y+(h*0.35), w*0.5, h*0.0833333
    back_btn =  new Btn(UI.div * 4, UI.y2/2, UI.x2, UI.w1, "Back", 12, false, false);

    buttons.add(cancel_btn);
    buttons.add(done_btn);
    buttons.add(back_btn);
  }


  void update() {
    if (cancel_btn.active()) { 
      UI.console.addText("Create Microbe Canceled");
      UI.console.setId(2);
    }
    else if (done_btn.active()) { 
      UI.console.addText("New microbe Created");
      UI.console.setId(1);
    }
    else if (back_btn.active()) {
      UI.console.addText("Fullscreen Mode Deactivated");
      UI.console.setId(1);
    }

    if (fullscreen) {
      currentX = fullscreenX;
      currentY = fullscreenY;
      currentW = width;

      scale = 0.9;
      diameter = currentH * scale;

      microscope.bg.fullscreenActiv = true;
    }
    else {
      currentX = x;
      currentY = y;
      currentW = w;

      scale = 0.7;
      diameter = currentH * scale;

      microscope.bg.fullscreenActiv = false;
    }
  }


  void draw() {
    if (mode) { // create microbe mode providing an area to draw
      pushStyle();
      fill(CREATEC);
      stroke(255);
      strokeWeight(10);

      pushMatrix();
      rectMode(CENTER);
      translate(currentX, currentY);

      rect(0, 0, drawW, drawH);

      popMatrix();
      popStyle();


      pushStyle(); // Active drawing area
      noFill();
      stroke(255);

      pushMatrix();
      rectMode(CORNER);
      translate(drawX, drawY);

      rect(0, 0, drawW2, drawH2);

      popMatrix();
      popStyle(); 


      pushStyle();
      stroke(40); // center lines
      strokeWeight(2);

      pushMatrix();
      translate(x, drawY + (drawH2/2));

      line(-drawW*0.15, 0, drawW*0.15, 0);
      line(0, -drawW*0.15, 0, drawW*0.15);

      popMatrix();
      popStyle();

      cancel_btn.update();
      done_btn.update(); 

      cancel_btn.draw();   
      done_btn.draw(); 

      if (mode) {
        create.update();
        create.draw();
      }
    }

    if (fullscreen) {
      back_btn.update();
      back_btn.draw();

      pushStyle();
      fill(20, 220);
      noStroke();
      rect(0, 0, UI.w * 0.8, UI.h * 0.1);
      popStyle();
    }

    for (Btn b : buttons) { // done should stay false unless clicked, after clicked, it turns false again
      b.stateActv = false;
    }
  }


  void setMode(boolean m) {
    mode = m;
  }


  void setScreen(boolean s) {
    fullscreen = s;
  }


  void handleMouseClicked() {
    //for every element that is interested in receiving these events do it here

    for (Btn b : buttons ) {
      b.mouseClicked();
    }
  }
}
