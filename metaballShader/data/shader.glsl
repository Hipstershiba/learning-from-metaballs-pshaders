struct Blob {
    vec3 pos;
    float rad;
};

const int MAX_BLOBS = 300;
const float threshold = 1.0;

uniform Blob blobs[MAX_BLOBS];
uniform int totalBlobs;

varying vec4 vertColor;

void main() {
    float total = 0;
    int index = 0;
    float highest = 0;
    for (int i = 0; i < totalBlobs; i++) {
        float value = 0;
        Blob blob = blobs[i];
        float sqDeltaX = pow(blob.pos.x - gl_FragCoord.x, 2.0);
        float sqDeltaY = pow(blob.pos.y - gl_FragCoord.y, 2.0);
        float sqRadius = pow(blob.rad, 2.0);
        value = sqRadius / (sqDeltaX + sqDeltaY);
        total += value;
    }
    vec3 pixelColor = vec3(1.0 - floor(total * threshold));
    gl_FragColor = vec4(pixelColor, 1.0);
}
