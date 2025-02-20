class Blob {
    private PVector coord;
    private float radius;
    public int index;

    private PVector speed;
    private PVector acceleration;
    private float maxSpeed;
    private float maxForce;

    Blob(PVector coord, float radius, int index) {
        this.coord = coord;
        this.radius = radius;
        this.index = index;

        this.speed = new PVector(0, 0, 0);
        this.acceleration = new PVector(0, 0, 0);
        this.maxSpeed = 1;
        this.maxForce = 0.2;
    }

    void sync(String arrName, int index) {
        String uniformName = arrName + "[" + index + "].";
        mShader.set(uniformName + "pos", coord);
        mShader.set(uniformName + "rad", radius);	
    }

    void display() {
        ellipse(coord.x, coord.y, radius*2, radius*2);
    }

    void update() {
        this.accelerate();
        this.updateSpeed();
        this.move();
        this.bounceBorders();
    }

    void move() {
        coord.add(speed);
    }

    void updateSpeed() {
        speed.add(acceleration);
        speed.limit(maxSpeed);
    }

    void accelerate() {
        float noiseStep = 0.015;
        //float accx = map(noise(this.radius + noiseStep), 0, 1, -maxForce/50, maxForce/50);
        float heat = map(this.coord.y, 0, height, 0.001, -0.001);
        float accx = 0.0;
        float accy = map(noise((this.radius * 100) + noiseStep), 0, 1, -maxForce, maxForce);
        this.acceleration.set(accx, accy, 0);
        this.acceleration.add(0, heat, 0);
        // this.acceleration.limit(maxForce);
    }

    void bounceBorders() {
        float radiusTolerance = 0.2;
        float bounceFactor = 0.8;
        
        if(coord.x < radius + radiusTolerance || 
        coord.x > width - radius - radiusTolerance) {
            coord.x = constrain(coord.x, radius + radiusTolerance, width - radius - radiusTolerance);
            speed.x *= -bounceFactor;
        }

        if(coord.y < radius + radiusTolerance ||
        coord.y > height - radius - radiusTolerance) {
            coord.y = constrain(coord.y, radius + radiusTolerance, height - radius - radiusTolerance);
            speed.y *= -bounceFactor;
        }

    }
}
