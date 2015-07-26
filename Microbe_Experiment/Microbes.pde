class Microbes {

  boolean paused = false;

  ArrayList< Microbe > microbes;

  Microbes(ArrayList< Microbe > m) {
    this.microbes = m;
  }


  void draw() {
    for (Microbe m : microbes) {
      if (! paused) {
        if (m.followOn) {
          m.followUpdate();
        }
        else {
          m.autoUpdate();
        }
      }

      m.draw();
    }
  }

  // Setters

  void setTrail(boolean t) {
    for (Microbe m : microbes) {
      if (t) {
        m.setBool("trail", true);
      }
      else {
        m.setBool("trail", false);
      }
    }
  }


  void setTrailType(boolean l) {
    for (Microbe m : microbes) {
      if (l) {
        m.setBool("dot", true);
      }
      else {
        m.setBool("dot", false);
      }
    }
  }


  void setFollow(boolean f) {
    for (Microbe m : microbes) {
      if (f) {
        m.setBool("follow", true);
      }
      else {
        m.setBool("follow", false);
      }
    }
  }


  void clear() {
    microbes.clear();
  }


  void pause(boolean p) {
    paused = p;
  }
}
