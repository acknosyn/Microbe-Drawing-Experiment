class Microbe {

  ArrayList< ArrayList<PVector> > path;
  ArrayList<PVector> trail;

  int trailSize = 100; // size of trail 
  int trailWidth;
  String colour;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float dir;
  float maxSpeed;
  float maxForce;
  float ownMind; // The tendancy for the microbe to go off on a tangent towards target
  int sign;
  float ran;

  float centerX, centerY;
  float scaleVar = 0.5;

  float diameter = microscope.view.w/2;
  PVector viewCenter = new PVector(microscope.view.x, microscope.view.y);

  boolean trailOn = false;
  boolean followOn = false;
  boolean dotOn = false;

  Microbe(ArrayList< ArrayList<PVector> > p, float x, float y, int t, float tw, String c, float s, float f, float m) {
    this.path = p;

    this.centerX = x;
    this.centerY = y;

    this.trailSize = t;
    this.trailWidth = int(tw);
    this.colour = c;

    this.acceleration = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    this.location = new PVector(centerX, centerY);

    this.maxSpeed = s;
    this.maxForce = f;
    this.ownMind = m;

    this.ran = random(-1, 1);

    if (ran > 0) {
      sign = 1;
    }
    else {
      sign = -1;
    }

    this.trail = new ArrayList<PVector>();
  }


  void followUpdate() {

    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);

    float tangentX = ((50 * ownMind) * sign);
    float tangentY = ((50 * ownMind) * sign);

    PVector mouse = new PVector(mouseX + tangentX, mouseY + tangentY);

    if (microscope.view.fullscreen) {
      diameter = microscope.view.w/2 * 1.3;

      viewCenter = new PVector(microscope.view.fullscreenX, microscope.view.fullscreenY);
    }
    else {
      diameter = microscope.view.w/2;

      viewCenter = new PVector(microscope.view.x, microscope.view.y);
    }

    mouse.sub(viewCenter);  // Constraining microbe so it stays in the petri dish
    mouse.limit(diameter);

    map(mouse.x, -250, 250, -360, 860);
    map(mouse.y, -250, 250, -110, 610);

    mouse.add(viewCenter);  // End constrain

    arrive(mouse);
  }

float xoff, yoff;
  void autoUpdate() {

    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
    
    if (microscope.view.fullscreen) {
      diameter = microscope.view.w/2 * 1.3;

      viewCenter = new PVector(microscope.view.fullscreenX, microscope.view.fullscreenY);
    }
    else {
      diameter = microscope.view.w/2;

      viewCenter = new PVector(microscope.view.x, microscope.view.y);
    }
    
    xoff += .0051234655;
    yoff += .0034567329;
    
    float areaX = viewCenter.x + diameter*2;
    float areaY = viewCenter.y + diameter*2;
    
    PVector rand = new PVector(areaX * noise(xoff), areaY * noise(yoff));

    rand.sub(viewCenter);
    rand.limit(diameter);

    map(rand.x, -250, 250, -360, 860);
    map(rand.y, -250, 250, -110, 610);

    rand.add(viewCenter);
    
    arrive(rand);
  }


  void draw() {

    float theta = velocity.heading() + PI/2;

    if (trailOn) {
      if (! dotOn) {
        trail();
      }
      else {
        dotTrail(); // dot trail works but the button is glitchy so I haven't included it
      }
    }
    else {
      trail.clear(); // clears trail array, otherwise trail will start from last pos when turned off, if turned off and on
    }

    pushStyle();

    strokeWeight(10);
    stroke(unhex(colour));  // 0, 150, 20

    fill(unhex(colour), 50);

    pushMatrix();

    translate(centerX, centerY); // scales from the middle of drawing area
    scale(scaleVar);
    translate(-centerX, -centerY);

    translate(location.x/scaleVar - centerX, location.y/scaleVar - centerY);

    rotate(theta);

    for (ArrayList<PVector> p : path) {
      pushStyle();      
      noStroke();
      beginShape(); // fill shape

        for (int i = 0; i < p.size() - 1; ++i) {            
        vertex(p.get(i).x - centerX, p.get(i).y - centerY);
      }

      endShape(CLOSE);      
      popStyle();

      pushStyle();
      noFill(); // outline   

      for (int i = 0; i < p.size() - 1; ++i) {            
        line(p.get(i).x - centerX, p.get(i).y - centerY, p.get(i+1).x - centerX, p.get(i+1).y - centerY);

        if (i == p.size()-2) { // last point connects to first to close gap
          line(p.get(i).x - centerX, p.get(i).y - centerY, p.get(0).x - centerX, p.get(0).y - centerY);
        }
      }

      popStyle();
    }

    popMatrix();

    popStyle();
  }

  // seek() and arrive() methods from "The Nature Of Code" by Daniel Shiffman 
  // http://natureofcode.com/book/chapter-6-autonomous-agents/

  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);

    desired.normalize();
    desired.mult(maxSpeed);

    PVector steer = PVector.sub(desired, velocity);

    steer.limit(maxForce);

    acceleration.add(steer);
  }


  void arrive(PVector target) {

    PVector desired = PVector.sub(target, location);

    float d = desired.mag();   // Distance is magnitude of vector pointing from location to target
    desired.normalize();

    if (d < 100) {   //If closer than 100 pixels

      float m = map(d, 0, 100, 0, maxSpeed);  // set magnitude according to how close it is

      desired.mult(m);
    } 
    else {   // Otherwise, proceed at maximum speed
      desired.mult(maxSpeed);
    }

    PVector steer = PVector.sub(desired, velocity);    //The usual steering = desired - velocity

      steer.limit(maxForce);

    acceleration.add(steer);
  }


  void trail() {
    pushStyle();
    strokeWeight(trailWidth/2);

    int trailLength;
    PVector circlePosition = new PVector(location.x, location.y);

    if (! microscope.culture.paused) {
      trail.add(circlePosition);
    }

    trailLength = trail.size() - 2;

    for (int i = 0; i < trailLength; i++) {
      PVector currentTrail = trail.get(i);
      PVector previousTrail = trail.get(i + 1);

      stroke(unhex(colour), (100*i)/trailLength);
      line(currentTrail.x, currentTrail.y, previousTrail.x, previousTrail.y);
    }

    if (trailLength >= trailSize) {
      trail.remove(0);
    }

    popStyle();
  }


  void dotTrail() {
    pushStyle();
    noStroke();

    int trailLength;
    PVector circlePosition = new PVector(location.x, location.y);

    if (! microscope.culture.paused) {
      trail.add(circlePosition);
    }

    trailLength = trail.size() - 2;

    for (int i = 0; i < trailLength; i+=trailLength/7) {
      PVector currentTrail = trail.get(i);
      PVector previousTrail = trail.get(i + 1);

      fill(unhex(colour), 200*i/trailLength);
      ellipse(currentTrail.x, currentTrail.y, trailWidth/2, trailWidth/2);
    }

    if (trailLength >= trailSize) {
      trail.remove(0);
    }

    popStyle();
  }


  /* boolean stationary() { // Couldn't get this to work
   // I wanted this to return true if the trail hadn't moved from a stationary point
   // So I tried comparing all of the PVectors and if they were all the same I want it to return true
   // I would have then cleared the trail array if it was stationary
   
   if (trail != null) {
   int trailLength = trail.size() - 2;
   
   boolean same = false;
   
   for (int i = 0; i < trailLength; i++) {
   PVector current = trail.get(i);
   PVector previous = trail.get(i + 1);
   
   if (current == previous) {
   same = true;
   }
   else {
   same = false;
   }
   }
   
   if (same) {
   return true;
   }
   }
   return false;
   }*/


  void setBool(String n, boolean t) {
    if (n == "trail") {
      trailOn = t;
    }
    else if (n == "follow") {
      followOn = t;
    }
    else if (n == "dot") {
      dotOn = t;
    }
  }
}
