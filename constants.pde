import processing.sound.*;

final float DIVIDER = 10000000;
final int maxBv = -10000000;
final int minBv = -17000000;
final boolean big = true;
final int MAX_FREQ = 4000;
final int NPHOTOS = 4;

public void settings() {
  if(big) {
    size(1920, 1080);
  } else {
    size(1280, 720);
  }
}
