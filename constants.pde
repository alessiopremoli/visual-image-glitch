import processing.sound.*;

final float DIVIDER = 10000000;
final int maxBv = -10000000;
final int minBv = -17000000;
final boolean big = false;
final int MAX_FREQ = 4000;

public void settings() {
  if(big) {
    size(1920, 1080);
    img = loadImage("forest_big.jpg");
  } else {
    size(1280, 720);
    img = loadImage("forest.jpg");
  }
}
