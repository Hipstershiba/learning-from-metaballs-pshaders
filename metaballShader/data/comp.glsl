#version 430

uniform int 

struct Particle {
    vec2 pos;
    vec2 vel;
    vec2 acc;
    float mass;
}

layout(std430, binding = 0) buffer particleBuffer {
    Particle particles[];
}

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

void main() {
    uint i = gl_GlobalInvocationID.x;

    vec2 force = 
}