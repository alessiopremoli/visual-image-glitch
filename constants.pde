final float DIVIDER = 10000000;
final int maxBv = -10000000;
final int minBv = -16900000;
final boolean big = false;

public void settings() {
  if(big) {
    size(1920, 1080);
    img = loadImage("forest_big.jpg");
    delay = 0;
  } else {
    size(1280, 720);
    img = loadImage("forest.jpg");
    delay = 150;
  }
}
