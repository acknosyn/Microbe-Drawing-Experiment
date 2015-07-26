class CreateMicrobe {
  Microbe convert;

  ArrayList< ArrayList<PVector> > paths;
  ArrayList< PVector > line;

  float x, y;
  float w, h;

  float speed;
  float force;  
  float ownMind;
  int trail;
  float trailWidth;
  color c;

  CreateMicrobe(float x, float y, float w, float h) {
    paths = new ArrayList< ArrayList<PVector> >();
    line = new ArrayList< PVector >();

    this.w = w;
    this.h = h; 
    this.x = x;
    this.y = y;
  }


  void update() {
    pushMatrix();

    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      if (mousePressed && mouseMoved) {      
        line.add(new PVector(mouseX, mouseY));
      }
    }

    popMatrix();
  }


  void draw() {

    // Draw list of paths
    pushStyle();
    strokeWeight(2);
    stroke(19, 160, 78);

    for (ArrayList<PVector> ls : paths) {
      for (int i = 0; i < ls.size() - 1; ++i) {    
        if (ls.get(i) != null && ls.get(i+1) != null) {
          line(ls.get(i).x, ls.get(i).y, ls.get(i+1).x, ls.get(i+1).y);
        }
      }
    }

    popStyle();

    // Drawing current line that user is creating
    pushStyle();
    strokeWeight(2);
    stroke(255);

    for (int i = 0; i < line.size() - 1; ++i) {    
      if (line.get(i) != null && line.get(i+1) != null) {
        line(line.get(i).x, line.get(i).y, line.get(i+1).x, line.get(i+1).y);
      }
    }

    popStyle();
  }


  void handleMouseReleased() {
    paths.add(line);   // add current line list to list of paths

    line = new ArrayList< PVector >();
  }


  void cancel() {
    //println("Returning 0");

    paths = new ArrayList< ArrayList<PVector> >();
    line = new ArrayList<PVector>();
  }


  void done() {
    //println("Returning hist");
    float cX = microscope.view.x;
    float cY = microscope.view.drawY + microscope.view.drawH2/2;

    this.speed = random(1, 6);  // initialised in done() method so it re generates each time
    this.force = random(0.1, 0.6);

    this.ownMind = random(0, 1);

    this.trail = int(random(0, 200));

    float minX = width;
    float maxX = 0;

    for (ArrayList<PVector> p : paths) {
      for (int i = 0; i < p.size() - 1; ++i) {
        float tempX = p.get(i).x;

        if (tempX > maxX) {
          maxX = tempX;
        }
        else if (tempX < minX) {
          minX = tempX;
        }
      }
    }

    trailWidth = maxX - minX;

    if (trailWidth < 0) {
      trailWidth = 15;
    }
    else if (trailWidth > 150) {
      trailWidth = 150;
    }

    c = color(int(random(0, 30)), int(random(100, 170)), int(random(0, 50)));  //  0, 150, 20

      String col = hex(c);

    convert = new Microbe(paths, cX, cY, trail, trailWidth, col, speed, force, ownMind);

    microscope.microbes.add(convert);

    paths = new ArrayList< ArrayList<PVector> >();
    line = new ArrayList<PVector>();
  }
}

