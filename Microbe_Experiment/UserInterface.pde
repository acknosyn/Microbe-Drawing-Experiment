class UserInterface {
  Btn create_btn, trail_btn, dot_btn, follow_btn;

  Btn pause_btn; // Can be activated by pressing the key 'P' as well
  // I did this so if a user was using the follow attribute, they could pause the sketch without having to move their mouse

  Btn screen_btn, hide_btn;

  Btn clear_btn, load_btn, save_btn;

  Btn reset_btn; // After hours of using my app, I really wanted a Btn that reset the toggals and microbes. I found it VERY usefull

  Btn clearConsole_btn;

  Console console;

  final color BG = color(45, 45, 50);

  ArrayList<Btn> buttons;

  float x, y;
  float w, h;

  float div;      // Div is used often
  float x1, x2;   // These var's are var's that are used often when creating a Btn 
  float y1, y2;   // They are numbered in order of how many times they're used
  float w1, w2;
  float h1, h2;

  boolean popup = false;
  boolean hide = false;

  UserInterface(float x, float y, float w, float h) { // UserInterface holds all of the UI elements on screen
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.div = (w/13); // Division splits UI into 13 segments horizontally

    this.x1 = w * 0.5;
    this.x2 = div * 5;
    this.y1 = (h/16) * 13;
    this.y2 = h * 0.125;
    this.w1 = div * 2;
    this.w2 = div * 7;
    this.h1 = h/12;

    buttons = new ArrayList<Btn>();

    create_btn = new Btn(x1  *  1, y2 * 1, w2  * 1, h1, "Create" + "", 18, false, true); // UI is split up into 8th's vertically
    trail_btn =  new Btn(x1  *  1, y2 * 2, div * 4, w1, "Trail" +  "", 18, true, true); // would be x2 with dot btn next to it
    dot_btn =    new Btn(div *  9, y2 * 2, w1  * 1, w1, "Dot" +   "", 12, true, true);
    follow_btn = new Btn(x1  *  1, y2 * 3, w2  * 1, h1, "Follow" + "", 18, true, true);

    pause_btn =  new Btn(x1  *  1, y2 * 4, x2  * 1, w1, "Pause" +  "", 12, true, true);

    screen_btn = new Btn(x2  *  1, y2 * 5, div * 8, h1, "Full Screen", 18, false, true); // split into 8th's horizontally
    hide_btn =   new Btn(div * 11, y2 * 5, w1  * 1, w1, "Hide" +   "", 12, true, true);

    reset_btn =  new Btn(div *  2, y1 * 1, w1  * 1, w1, "Reset" +  "", 12, false, true);
    clear_btn =  new Btn(div *  5, y1 * 1, w1  * 1, w1, "Clear" +  "", 12, false, true); // split into 13th's horizontally
    load_btn =   new Btn(div *  8, y1 * 1, w1  * 1, w1, "Load" +   "", 12, false, true);
    save_btn =   new Btn(div * 11, y1 * 1, w1  * 1, w1, "Save" +   "", 12, false, true);


    clearConsole_btn = new Btn(x1, (h/16) * 18, div * 11, w1, "Clear Console", 12, false, true);

    buttons.add(create_btn);
    buttons.add(trail_btn);
    //buttons.add(dot_btn);
    buttons.add(follow_btn);
    buttons.add(pause_btn);
    buttons.add(screen_btn);
    buttons.add(hide_btn);
    buttons.add(reset_btn);
    buttons.add(clear_btn);
    buttons.add(load_btn);
    buttons.add(save_btn);
    buttons.add(clearConsole_btn);

    console = new Console(div, (h/16) * 14, div * 11, div * 6, "Console", 12);
  }


  void update() {
    // UI Btn boolean setters
    if (create_btn.active()) {
      microscope.view.setMode(true);

      popup = true;
    }
    if (microscope.view.create.convert != null) {  // Check to make sure a microbe has been created

      if (trail_btn.toggled) {
        microscope.culture.setTrail(true);
      }
      else {
        microscope.culture.setTrail(false);
      }
      if (dot_btn.toggled) {
        microscope.culture.setTrailType(true);
      }
      else {
        microscope.culture.setTrailType(false);
      }
      if (follow_btn.toggled) {
        microscope.culture.setFollow(true);
      }
      else {
        microscope.culture.setFollow(false);
      }
      if (pause_btn.toggled) {
        microscope.culture.pause(true);
      }
      else {
        microscope.culture.pause(false);
      }
    }
    if (screen_btn.active()) {
      microscope.view.setScreen(true);
    }
    if (microscope.view.back_btn.active()) {
      microscope.view.setScreen(false);
    }
    if (hide_btn.toggled) {
      hide = true;
    }
    else {
      hide = false;
    }
    if (reset_btn.active()) {
      if (microscope.view.create.convert != null) {
        microscope.view.create.convert.setBool("trail", false);
        microscope.view.create.convert.setBool("follow", false);
      }
      microscope.culture.pause(false);
      hide = false;
      img = null;

      for (Btn b : buttons) {
        b.toggleOff();
      }
    }
    if (save_btn.active()) {
      saveRequested = true;
    }
    else {
      saveRequested = false;
    }
    if (load_btn.active()) {
      requested = true;
    }
    else {
      requested = false;
    }

    // Popup UI boolean setters
    if (microscope.view.cancel_btn.active()) {
      microscope.view.setMode(false);

      microscope.view.create.cancel();

      popup = false;
    }
    else if (microscope.view.done_btn.active()) {
      microscope.view.setMode(false);

      microscope.view.create.done();

      popup = false;
    }
    if (microscope.view.fullscreen) {
      popup = true;
    }
    else if (microscope.view.back_btn.active()) {
      popup = false;
    }

    // UI Btn Console info ascending down in order of UI Btn's
    if (create_btn.active()) { 
      console.addText("Create Microbe Mode");
      console.setId(1);
    }
    else if (trail_btn.active() && trail_btn.toggled) { // toggle Btns have different text for each state
      console.addText("Trail Mode Activated");
      console.setId(1);
    }
    else if (trail_btn.active()) {
      console.addText("Trail Mode Deactivated");
      console.setId(1);
    }
    else if (dot_btn.active() && dot_btn.toggled) {
      console.addText("Trail Type Set To Dot");
      console.setId(1);
    }
    else if (dot_btn.active()) {
      console.addText("Trail Type Set To Line");
      console.setId(1);
    }
    else if (follow_btn.active() && follow_btn.toggled) {
      console.addText("Follow Attribute Enabled");
      console.setId(1);
    }
    else if (follow_btn.active()) {
      console.addText("Auto Attribute Enabled");
      console.setId(1);
    }
    else if (pause_btn.active() && pause_btn.toggled) {
      console.addText("Microbes Paused");
      console.setId(1);
    }
    else if (pause_btn.active()) {
      console.addText("Microbes Resumed");
      console.setId(1);
    }
    else if (screen_btn.active()) {
      console.addText("Fullscreen Mode Activated");
      console.setId(1);
    }
    else if (screen_btn.active()) { 
      console.addText("Full Screen Activated");
      console.setId(1);
    }
    else if (hide_btn.active() && hide_btn.toggled) {
      console.addText("UI Hiden");
      console.setId(1);
    }
    else if (hide_btn.active()) {
      console.addText("UI Revealed");
      console.setId(1);
    }
    else if (reset_btn.active()) { 
      microscope.culture.clear();

      console.clear();
    }
    else if (clear_btn.active()) { 
      microscope.culture.clear();

      console.addText("Cleared - Created New Sample");
      console.setId(2);
    }
    else if (load_btn.active()) { 
      console.addText("Loaded Existing Culture");
      console.setId(1);
    }
    else if (save_btn.active()) { 
      // console.addText("Saved Current Culture At:");
      // console.setId(1);
      // console.addText(timestamp);
      //console.setId(1);
    }
    if (clearConsole_btn.active()) {
      console.clear();
    }
  }


  void draw() { 
    pushStyle();
    noStroke();
    fill(BG);

    pushMatrix();
    translate(x, y);

    rect(0, 0, w, height);

    popMatrix();
    popStyle();

    for (Btn b : buttons) {
      b.update();  
      b.draw();
    }

    console.update();
    console.draw();

    if (hide) {
      pushStyle();
      fill(0, 200);
      noStroke();

      pushMatrix();
      translate(x, y);

      rect(0, 0, w, height);

      popMatrix();
      popStyle();
    }
  }


  void handleMouseClicked() {
    // for every element that is interested in receiving these events do it here

    for (Btn b : buttons ) {
      if (b.isClickable()) {
        b.mouseClicked();
      }
    }
  }


  void handleKeyPressed() {
    for (Btn b : buttons ) {
      if (b.isClickable()) {
        b.keyPressed();
      }
    }
  }
  // End of UserInterface class
}

