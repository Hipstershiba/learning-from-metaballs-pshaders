/*
 * Note: Contrast this sketch with the other metaball sketch that
 * doesn't use shader. The speed difference is tremendous.
 * There it's like 20 FPS, here it's like 60 FPS. Good job, me.
 */

PShader mShader;
Ball[] balls = new Ball[15];
Blob[] blobs = new Blob[15];
boolean isSave = false;



void setup() {
  size(1000, 600, P2D);
  colorMode(HSB);
  mShader = loadShader("shader.glsl");
  for(int i=0; i<balls.length; i++) {
    PVector pos = new PVector(random(width), random(height), 1.0); // GLSL only accept vec3
    PVector vel = new PVector(random(-3, 3), random(-1, 1), 0.0);
    color c = color(random(255), 255, 255);
    PVector rgb = new PVector(red(c)/255, green(c)/255, blue(c)/255);
    float r = random(50, 80);
    balls[i] = new Ball(pos, vel, rgb, r);
    balls[i].sync("balls", i);
  }
  mShader.set("n_balls", balls.length);
  colorMode(RGB);

  // blobs
  for (int i = 0; i < blobs.length; i++) {
    float rad = sort_radius();
    float x = ((width/2) * map(rad, min(width, height) / 30, min(width, height) / 4, 1, 0)) * randomGaussian() + width/2;
    float y = random(-rad, height + rad);
    PVector coord = new PVector(x, y);
    blobs[i] = new Blob(coord, rad);
    // blobs[i].sync("blobs", i);
  }

}

void draw() {
  background(0);
  // shader(mShader);
  // rect(0, 0, width, height);

  // balls[0].pos.x = mouseX;
  // balls[0].pos.y = height - mouseY;
  // balls[0].sync("balls", 0);
  // for(int i=1; i<balls.length; i++) {
  //   balls[i].update();
  //   balls[i].sync("balls", i);
  // }

  // if(isSave) {
  //   saveFrame("screen-####.png");
  // }
  for (int i = 0; i < blobs.length; i++) {
    blobs[i].update();
    blobs[i].display();
  }
}

class Ball {
  PVector pos, rgb, vel;
  float r;

  Ball(PVector pos, PVector vel, PVector rgb, float r) {
    this.pos = pos;
    this.vel = vel;
    this.rgb = rgb;
    this.r = r;
  }

  void sync(String arrName, int idx) {
    String varname = arrName + "[" + idx + "].";
    mShader.set(varname + "pos", pos);
    mShader.set(varname + "rgb", rgb);
    mShader.set(varname + "r", r);
  }

  void update() {
    pos.add(vel);
    if(pos.x < 0 || pos.x >= width) {
      vel.x *= -1;
    }
    if(pos.y < 0 || pos.y >= height) {
      vel.y *= -1;
    }
  }
}

float sort_radius() {
  float min_radius = min(width, height) / 30;
  float max_radius = min(width, height) / 4;
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
