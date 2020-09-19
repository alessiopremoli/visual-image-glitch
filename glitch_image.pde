PImage img;
boolean log = false;
float bv, dv = 0.0;
int m = 0;
int loadedImage = 0;

WhiteNoise noise;
LowPass lowPass;
float fv = 100;
float nextfv = 100;

float maxValue = Float.MIN_VALUE;
float minValue = Float.MAX_VALUE;
Table table;

boolean finished = false;
FloatList dataPerYear = new FloatList();
StringList years = new StringList();
int startData, lastData = 0;
int delay = 275;
int startMillis = 0;
PFont slimJoe;

void setup() {
  background(255);
  colorMode(HSB);
  
  // FONT
  slimJoe = createFont("Slim Joe", 32);
  textFont(slimJoe);
  
  img = loadImage("forest0.png");
  image(img, 0, 0);
  
  loadData();
  getMaxMinFromData();
  
  for (TableRow row : table.rows()) {
    // int year = row.getInt(0);
    float value = row.getFloat(1) / DIVIDER;
    String year = row.getString(0);
    dataPerYear.append(value);
    years.append(year);
    lastData++;
  }
  
  int firstDate = int(years.get(startData));
  addText(str(firstDate));
  
  noise = new WhiteNoise(this);
  lowPass = new LowPass(this);
    
  noise.play(0.5);
  lowPass.process(noise);
  lowPass.freq(fv);
}

void draw() {
  if(startData == 0) {
    delay(4000);
    saveFrame("output/image-"+str(loadedImage)+"-"+str(4000) + "-######.png");
  }
  
  if (startData == lastData) {
      saveFrame("output/image-"+str(loadedImage)+"-"+str(4000 - delay) + "-######.png");
      delay(4000);
      loadNextImage();
      startData = 0;
      bv = 0;
      dv = 0;
      fv = 100.0;
      nextfv = 100.0;
      ASDFreset();
      
  } else {
    glitch();
    //soundManipolation(); 
  }
  
}

void loadNextImage() {
   loadedImage++;
  if(loadedImage <= NPHOTOS - 1) {
    img = loadImage("forest"+loadedImage+".png");
    image(img, 0, 0);
    int firstDate = int(years.get(0));
    addText(str(firstDate));
  } else {
    exit();
  }
  
}

void glitch() {
  
  if(startData < lastData) {

    float value = dataPerYear.get(startData);
    bv = map(value, minValue, maxValue, maxBv, minBv);
    dv = map(value, minValue, maxValue, 0, 255);
    fv = map(value, minValue, maxValue, 100, MAX_FREQ);
    
    int nextIdx = min(startData + 1, lastData - 1);
    nextfv = map(dataPerYear.get(nextIdx), minValue, maxValue, 100, MAX_FREQ);
    
    
    ASDFPixelSort(bv);
    desaturate(-dv);
    addText(years.get(startData).toString());
    saveFrame("output/image-"+str(loadedImage)+"-"+str(delay) + "-######.png");
    delay(delay);
    
    /*println(years.get(startData).toString() + ": New bv: " + bv + " for value: ", value);
    println("Desaturating: -" + dv);
    println("Freq: ", fv, nextfv);*/
    startData++;
    //println(startData);
  }
}

void soundManipolation() {
  if(abs(fv - nextfv) > 0) {
    print(fv + ", ");
    fv += (nextfv - fv) / 40;
    lowPass.freq(fv);
  } else {
    lowPass.freq(nextfv);
  }
}

void loadData() {
  table = loadTable("filtered_data.csv");
  println("Table loaded: " + table.getRowCount() + " total rows in table");
}

void getMaxMinFromData() {
  for (TableRow row : table.rows()) {
    maxValue = max(row.getFloat(1), maxValue);
    minValue = min(row.getFloat(1), minValue);
  }
  maxValue = maxValue / DIVIDER;
  minValue = minValue / DIVIDER;
  
  println("maxValue", maxValue, "minValue", minValue);
}

void addText(String text) {
  fill(255);
  textSize(100);
  textAlign(LEFT, TOP);
  text(text, 32, 32);
}

void desaturate(float param) {
  // TODO: with param < 2 some regions remains saturated
  PImage newImg = createImage(img.width, img.height, RGB);
  img.loadPixels();
  newImg.loadPixels();
  
  for(int i = 0; i < img.pixels.length; i++) {
    float b = brightness(img.pixels[i]);
    float s = saturation(img.pixels[i]);
    float h = hue(img.pixels[i]);
    newImg.pixels[i] = color(h, max(s + param, 0), b);
  }
  image(newImg, 0, 0);
}
