class Blob {
    private PVector coord;
    private float radius;
    public int index;

    private PVector speed;
    private PVector acceleration;
    private float maxSpeed;
    private float maxForce;

    public float heat;
    public float accx;
    public float accy;
    public float accNoise;

    Blob(PVector coord, float radius, int index, float minRad, float maxRad) {
        this.coord = coord;
        this.radius = radius;
        this.index = index;

        this.speed = new PVector(0, 0, 0);
        this.acceleration = new PVector(0, 0, 0);
        this.maxSpeed = map(this.radius, minRad, maxRad, 1, 0.1);
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
        // speed.x = constrain(speed.x, -0.3, 0.3);
        speed.limit(maxSpeed);
    }

    void accelerate() {
        noiseSeed(this.index);
        float noiseStep = millis() * 0.00001;
        this.accx = map(noise(this.radius * (this.index * 1000) + (noiseStep * 100)), 0, 1, -maxForce/50, maxForce/50);
        this.heat = map(this.coord.y, -this.radius, height + this.radius, 0.05, -0.05);
        // this.accx = 0.0;
        this.accNoise = map(noise((this.radius * (this.index * 1000)) + noiseStep), 0, 1, -maxForce, maxForce);
        this.accy = this.accNoise;
        this.acceleration.set(this.accx, this.accy, 0);
        // this.acceleration.add(0, this.heat, 0);
        // this.acceleration.limit(maxForce);
    }

    public float getCoordY() {
        return this.coord.y;
    }

    public float getAccelerationY() {
        return this.acceleration.y;
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
