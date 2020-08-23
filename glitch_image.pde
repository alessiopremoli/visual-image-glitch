PImage img;
boolean log = false;
float bv, dv = 0.0;

float maxValue = Float.MIN_VALUE;
float minValue = Float.MAX_VALUE;
Table table;

boolean finished = false;
FloatList dataPerYear = new FloatList();
StringList years = new StringList();
int startData, lastData = 0;
int delay;

void setup() {
  background(255);
  colorMode(HSB);
  
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
}

void draw() {
  if(startData < lastData) {
    delay(2000);
    float value = dataPerYear.get(startData);
    bv = map(value, minValue, maxValue, maxBv, minBv);
    dv = map(value, minValue, maxValue, 0, 255);
    
    ASDFPixelSort(bv);
    desaturate(-dv);
    addText(years.get(startData).toString()); 
    
    println("New bv: " + bv + " for value: ", value);
    println("Desaturating: -" + dv);
    startData++;
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
  fill(130);
  textSize(100);
  print(text);
  text(text, width - 256 - 32, height - 32);
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
