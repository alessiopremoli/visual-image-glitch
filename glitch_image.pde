PImage img;
float value = 100;
boolean log = false;

void setup() {
  size(1280, 720);
  background(255);
  colorMode(HSB, 100);
  img = loadImage("forest.jpg");
  image(img, 0, 0);
}

void draw() {
  desaturate(-2);
}

void mouseClicked() {
  print('\n');
}

void desaturate(float param) {
  // TODO: with param < 2 some regions remains saturated
  loadPixels();
  for(int i = 0; i<pixels.length - 1; i++) {
    float b = brightness(pixels[i]);
    float s = saturation(pixels[i]);
    float h = hue(pixels[i]);
    pixels[i] = color(h, max(s + param, 0), b);
  }
  updatePixels();
}
