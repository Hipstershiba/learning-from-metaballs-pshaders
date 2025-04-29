class BlobSystem {
    ArrayList<Blob> blobs = new ArrayList<Blob>();
    FloatList blobAttributesList = new FloatList();
    float[] blobsBuffer;
    FloatBuffer fbBlobs;
    int numOfBlobs;
    ShaderProgram shaderProgram;
    ComputeProgram computeProgram;

    BlobSystem(int count) {

        numOfBlobs = count;
        for (int i = 0; i < count; i++) {
            Blob blob = new Blob();

            // Set random position and mass
            blob.pos.x = random(-1, 1);
            blob.pos.y = random(-1, 1);
            blob.mass = random();

            //  Initialize attributes list
            blobAttributesList.append(blob.pos.x);
            blobAttributesList.append(blob.pos.y);
            blobAttributesList.append(blob.vel.x);
            blobAttributesList.append(blob.vel.y);
            blobAttributesList.append(blob.acc.x);
            blobAttributesList.append(blob.acc.y);
            blobAttributesList.append(blob.mass);
        }

        blobsBuffer = new float[blobAttributesList.size()];
        for (int i = 0; i < blobsBuffer.length; i++) {
            blobsBuffer[i] = blobAttributesList.get(i);
        }

        fbBlobs = Buffers.newDirectFloatBuffer(blobsBuffer);
        shaderProgram = new ShaderProgram(gl, "vert.glsl", "frag.glsl");
        computeProgram = new ComputeProgram(gl, "comp.glsl", fbBlobs);
    }

    void loadShader(String v, String f, String c) {
        shaderProgram = new ShaderProgram(gl, v, f);
        computeProgram = new ComputeProgram(gl, c, fbBlobs);
    }

    void update() {
        computeProgram.beginDispatch(1024, 1, 1);
        shaderProgram.begin();
    }

    void render() {
        shaderProgram.draw(numOfBlobs);
    }

    void release() {
        shaderProgram.release();
        computeProgram.release();
    }
}