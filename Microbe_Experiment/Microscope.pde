class Microscope {
  BG bg;
  View view;
  Microbes culture;

  ArrayList<Microbe> microbes; // list of every microbes 

  float x, y;
  float w, h;

  Microscope(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    microbes = new ArrayList< Microbe >();

    bg = new BG(x, y, w, h, false);
    view = new View(x + (w * 0.5), y + (h * 0.5), w, h, false);
    culture = new Microbes(microbes);
  }


  void draw() {    
    view.update();
    bg.update();

    bg.draw();
    culture.draw();
    view.draw();
  }
}

