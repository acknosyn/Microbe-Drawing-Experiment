UserInterface UI;  // User Interface at the left
Microscope microscope;  // Main draw area

int time = 0;
boolean mouseMoved = false;
boolean saveRequested = false;

int num = 1;
PImage img;
boolean requested = false;

void setup() {
  size(970, 720); // size a little small becuase of my monitor's size limitations (It's only 19 inches)
  smooth();

  UI = new UserInterface(0, 0, width - height, height * (5/6.0));
  microscope = new Microscope(width - height, 0, height, height);
}

void draw() {
  background(0);

  UI.update();
  UI.draw();
  microscope.draw();

  if (saveRequested) {
    saveImage();
  }

  if (requested) {
    selectInput("Select Culture To Load :", "selected");
  }
  else if (img != null) {     
    image(img, width - height, 0);
  }

  mouseMove();
}

void mouseReleased() {
  //not mouseClicked() because Btn's would not be clicked if mouse was dragged (mouse has to be stationary for mouseClicked() to work)
  UI.handleMouseClicked();
  microscope.view.handleMouseClicked();
  microscope.view.create.handleMouseReleased();
}

void keyPressed() {
  UI.handleKeyPressed();
}

void mouseMove() {
  int x = mouseX - pmouseX;
  int y = mouseY - pmouseY;

  if (x != 0 || y != 0) {
    mouseMoved = true;
  }
  else {
    mouseMoved = false;
  }

  time++;
}

void mouseMoved() {
  time = 0;
}

void selected(File selection) {
  if (selection != null) {  
    img = loadImage(selection.getAbsolutePath());
  }
  if (img == null) {       
    requested = false;
  }
}

void saveImage() {
  PImage newImage = createImage(width, height, RGB);
  PImage export = get(width - height, 0, height, height);

  String fileName;

  fileName = "Microbe Sample #" + num + ".jpg";

  export.save(fileName);

  num++;
}

