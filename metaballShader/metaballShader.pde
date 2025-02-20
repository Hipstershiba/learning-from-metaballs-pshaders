PShader mShader;
Blob[] blobs = new Blob[60];

float debugcoordy = 0.0;
float debugheat = 0.0;
float debugaccy = 0.0;
float debugaccNoise = 0.0;
float debugacceleration = 0.0;

// svg import
PShape logo_icon_vector;

// canvas
PGraphics logo_canva;
PGraphics lava_canva;

void setup() {
  pixelDensity(1);
  // size(540, 960, P2D);
  // size(720, 1280, P2D);
  // surface.setLocation(width/2, 0);
  fullScreen(P2D, 1);
  // frameRate(60);

 // initialize canvas
  logo_canva = createGraphics(width, height, P2D);
  lava_canva = createGraphics(width, height, P2D);

  // Load shader  
  mShader = loadShader("shader.glsl");

  // Load Logo
  logo_icon_vector = loadShape("logo_icon.svg");

  // Initialize blobs
  float minRad = min(width, height) / 20;
  float maxRad = min(width, height) / 6;
  for (int i = 0; i < blobs.length; i++) {
    float rad = sort_radius();
    // float rad = 100;
    float x = ((width/2) * map(rad, min(width, height) / 30, min(width, height) / 4, 1, 0)) * randomGaussian() + width/2;
    // float x = width/2;
    float y = random(-rad, height + rad);
    PVector coord = new PVector(x, y);
    blobs[i] = new Blob(coord, rad, i, minRad, maxRad);
    blobs[i].sync("blobs", i);
  }
  mShader.set("totalBlobs", blobs.length);

  blendMode(EXCLUSION);

}

void draw() {
  background(255);
  // shader(mShader);
  // rect(0, 0, width, height);
  draw_lava();
  draw_logo();
  image(logo_canva, 0, 0);
  image(lava_canva, 0, 0);

  // for (int i = 0; i < blobs.length; i++) {
  //   blobs[i].update();
  //   // blobs[i].display();
  //   blobs[i].sync("blobs", i);
  // }

  // Begin debug
  resetShader();

  // Blob infos
  // println(millis()%10);
  // if ((millis()/10) % 10 <=1) {
  //   debugcoordy = blobs[0].getCoordY();
  //   debugheat = blobs[0].heat;
  //   debugaccy = blobs[0].accy;
  //   debugaccNoise = blobs[0].accNoise;
  //   debugacceleration = blobs[0].getAccelerationY();
  // }

  // fill(255);
  // textAlign(CENTER);
  // text("CoordY: "       + debugcoordy,       width/2, blobs[0].coord.y - 40);
  // text("Heat: "         + debugheat,         width/2, blobs[0].coord.y - 20);
  // text("AccY: "         + debugaccy,         width/2, blobs[0].coord.y);
  // text("AccNoise: "     + debugaccNoise,     width/2, blobs[0].coord.y + 20);
  // text("acceleration: " + debugacceleration, width/2, blobs[0].coord.y + 40);

  // FPS display
  noStroke();
  fill(255);
  rect(10, 10, 50, 24);
  fill(0);
  textAlign(LEFT);
  text("FPS: " + int(frameRate), 16, 25);
  // End debug
}

float sort_radius() {
  // float min_radius = min(width, height) / 30;
  float min_radius = min(width, height) / 30;
  float max_radius = min(width, height) / 6;
  float mean = (max_radius - min_radius) / 2.5;
  float standard_deviation = (max_radius - min_radius) / 4;
  float bias = 0.3;
  int sorted_radius = int(standard_deviation * (randomGaussian() - bias) + mean);
  if (sorted_radius < min_radius) {
    sorted_radius = int(min_radius);
  } else if (sorted_radius > max_radius) {
    sorted_radius = int(max_radius);
  }
  return sorted_radius;
}

void draw_lava() {
for (int i = 0; i < blobs.length; i++) {
    blobs[i].update();
    // blobs[i].display();
    blobs[i].sync("blobs", i);
  }

  lava_canva.beginDraw();
  lava_canva.shader(mShader);
  lava_canva.noStroke();
  lava_canva.rect(0, 0, width, height);
  // float canvaResolution = lava_canva.width * lava_canva.height;
  // for (int i = 0; i < canva_resolution; i++) {
  //   lava_canva.pixels[i]
  // })
  lava_canva.endDraw();
}

void draw_logo() {
  logo_canva.beginDraw();
  logo_canva.background(255);
  logo_canva.shapeMode(CENTER);
  float horizontal_ratio = width / logo_icon_vector.width;
  float vertical_ratio = height / logo_icon_vector.height;
  float ratio = min(horizontal_ratio, vertical_ratio) * 0.6;
  float new_width = logo_icon_vector.width * ratio;
  float new_height = logo_icon_vector.height * ratio;
  logo_canva.shape(logo_icon_vector, width/2, height/2, new_width, new_height);
  logo_canva.endDraw();
}