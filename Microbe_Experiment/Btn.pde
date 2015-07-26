class Btn {

  final color NORM = color(#2c3e50);        // Normal colour
  final color HOVR = color(#27ae60);        // Hover colour
  final color ACTV = color(#2ecc71);        // Active colour
  final color TOGL = color(#19693c);        // Toggle colour
  final color DSBL = color(#444447);        // Disabled colour
  final color WARNHOVR = color(#CF000F);    // A warning Btn's hover colour
  final color WARNACTV = color(#ea3636);    // A warning Btn's active colour
  final color TEXTNORM = color(#ecf0f1);    // The normal colour of text
  final color TEXTDSBL = color(#7f8c8d);    // The disabled colour of text
  final int STRONORM = 2;                   // Size of normal stroke
  final int STROHOVR = 5;                   // Size of hover stroke

  float x, y;
  float w, h;
  String name;      // Text for the Btn and an identifier
  int tSize;        // Text size for a Btn

  color fill = NORM;
  color text = TEXTNORM;
  int stroke = STRONORM;

  boolean stateActv = false;      // A Btn's active state
  boolean popup = false;          // A popup's active state
  boolean notPopupBtn = true;     // Btn that is not apart of a popup
  boolean toggable = false;       // Defines if a Btn is able to be toggled
  boolean toggled = false;        // A Btn's toggled state

    Btn(float x, float y, float w, float h, String n, int t, boolean tog, boolean p) {
    this.x = x - (w * 0.5);
    this.y = y - (h * 0.5);
    this.w = w;
    this.h = h;
    this.name = n;
    this.tSize = t;
    this.toggable = tog;
    this.notPopupBtn = p;
  }


  void update() {

    if (this.isClickable() == false) {
      fill = DSBL;
      text = TEXTDSBL;
      stroke = STRONORM;
    }

    else if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {

      if (mousePressed) {
        fill = ACTV;
        text = TEXTNORM;
        stroke = STRONORM;

        if (name == "Clear" || name == "Cancel" || name == "Reset" || name == "Clear Console") {
          fill = WARNACTV;
        }
        //
      } // end - if mousepressed
      else {
        fill = HOVR;
        text = TEXTNORM;
        stroke = STROHOVR;

        if (name == "Clear" || name == "Cancel" || name == "Reset" || name == "Clear Console") {
          fill = WARNHOVR;
        }
      } // end - else
    } // end - else if mouseX > x
    else {
      fill = NORM;
      text = TEXTNORM;
      stroke = STRONORM;

      if (toggled) {
        fill = TOGL;
      }
    } // End - else
    // End method divider, too many }'s, not enough space
  }


  void draw() {
    pushStyle();
    stroke(text);
    strokeWeight(stroke);
    fill(fill);

    textSize(tSize);
    textAlign(CENTER, CENTER);

    pushMatrix();

    translate(x, y);

    rect(0, 0, w, h);

    fill(text);

    text(name, w * 0.5, (h * 0.5) - 2);

    popStyle();
    popMatrix();

    stateActv = false;
  }


  void mouseClicked() {

    if (toggable) {
      if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
        stateActv = !stateActv;
        toggled = !toggled;

        println("on:: " + name + " toggled:: " + toggled);  // debug
        println("stateActv:: " + stateActv);  // debug
      }
    }
    else if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      stateActv = true;

      println("on:: " + name);  // debug
    }
  }


  void keyPressed() {
    if (name == "Pause") {
      stateActv = !stateActv;
      toggled = !toggled;

      println("keyPressed:: " + stateActv);  // debug
    }
  }

  // Getters

  boolean isClickable() { // returns false if a button can not be clicked due to popup's
    if (UI.popup == true && notPopupBtn == true) {
      return false;
    } 
    return true;
  }


  boolean active() { // returns true if the button is active
    if (this.stateActv) {
      return true;
    }
    return false;
  }

  // Setters

  void setPopup(boolean p) {
    this.popup = p;
  }


  void toggleOff() {
    toggled = false;
  }
}
