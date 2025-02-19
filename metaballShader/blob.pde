class Blob {
    private PVector coord;
    private float radius;

    private PVector speed;
    private PVector acceleration;
    private float maxSpeed;
    private float maxForce;

    Blob(PVector coord, float radius) {
        this.coord = coord;
        this.radius = radius;
    }

    void sync(String arrName, int index) {
        String uniformName = arrName + "[" + index + "].";
        mShader.set(uniformName + "pos", coord);
        mShader.set(uniformName + "r", radius);	
    }

    void display() {
        ellipse(coord.x, coord.y, radius*2, radius*2);
    }

    void update() {
        accelerate();
        updateSpeed();
        move();
        bounceBorders();
    }

    void move() {
        coord.add(speed);
    }

    void updateSpeed() {
        speed.add(acceleration);
        speed.limit(maxSpeed);
    }

    void accelerate() {
        float noiseStep = 0.00005;
        float accx = map(noise(radius + noiseStep), 0, 1, -maxForce/40, maxForce/40);
        float accy = map(noise(radius + noiseStep), 0, 1, -maxForce, maxForce);
        acceleration.add(accx, accy);
        acceleration.limit(maxForce);
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