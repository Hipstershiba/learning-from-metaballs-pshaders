// struct Ball {
//     vec3 pos;
//     vec3 rgb;
//     float r;
// };

struct Blob {
    vec3 pos;
    float rad;
};

// const int MAX_BALLS = 50;
// const float threshold = 3.4;

// uniform Ball balls[MAX_BALLS];
// uniform int n_balls;

const int MAX_BLOBS = 300;
const float threshold = 2.0;

uniform Blob blobs[MAX_BLOBS];
uniform int totalBlobs;

varying vec4 vertColor;

void main() {
    float total = 0;
    int index = 0;
    float highest = 0;
    for (int i = 0; i < totalBlobs; i++) {
        Blob blob = blobs[i];
        float distance = distance(blob.pos.xy, gl_FragCoord.xy);
        total += blob.rad / distance;
        // if(val > highest) {
        //     index = i;
        //     highest = val;
        // }
    }
    if(total < threshold) {
    	gl_FragColor = vec4(vec3(1.0), 1.0);
    } else if(total < threshold + 0.5) {
    	gl_FragColor = vec4(vec3(0.0), 1.0);
    }
}
