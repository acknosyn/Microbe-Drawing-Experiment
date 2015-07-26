class Console {

  // I created a console because of my scientific theme and I find it usefull to see what I did last
  // I also thought the user might do something by accedent and not realise what it was, so they can just check the console

  final color NORM = color(0, 15, 30);
  final color TEXTNORM = color(#ecf0f1);
  final color TEXTBAD = color(#F22613);
  final int STRONORM = 2;

  ArrayList<String> textList;
  ArrayList<Integer> id;   // Normal or bad message. 1 == normal message 2 == bad message

  int textSize = 5;

  float x, y;
  float w, h;

  String name;
  int tSize;
  color tColor;
  String text = "";

  Console(float x, float y, float w, float h, String n, int t) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.name = n;
    this.tSize = t;

    textList = new ArrayList<String>();
    id = new ArrayList<Integer>();
  }


  void update() {
    int textLength = textList.size() - 1;

    if (textLength >= textSize) {
      textList.remove(0);
      id.remove(0);
    }
  }


  void draw() {
    pushStyle();
    stroke(TEXTNORM);
    strokeWeight(STRONORM);
    fill(NORM);

    textSize(tSize);
    textAlign(CENTER, CENTER);

    pushMatrix();

    translate(x, y);

    rect(0, 0, w, h);

    textDisplay(h);

    popStyle();
    popMatrix();
  }


  void textDisplay(float yTop) {
    float yLevel = yTop - (yTop*0.2);

    for (int i=textList.size()-1; i >= 0; i--) {

      if (id.get(i) == 1) {
        tColor = TEXTNORM;
      }
      else {
        tColor = TEXTBAD;
      }

      fill(tColor);

      text(textList.get(i), w * 0.5, yLevel);

      yLevel -= 18;
    }
  }


  void addText(String t) {
    textList.add(t);
  }


  void setId(int eyeDee) {
    id.add(eyeDee);
  }


  void clear() {
    textList.clear();
    id.clear();
  }
}
