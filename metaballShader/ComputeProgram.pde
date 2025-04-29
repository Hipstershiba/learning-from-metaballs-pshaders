class ComputeProgram {
    int compute_program;
    int compute_shader;
    int ssbo;
    int[] vbo = new int[1];

    GL4 gl;

    ComputeProgram(GL4 gl, String compute_shader_path, FloatBuffer blobsFB) {
        this.gl = gl;

        String[] vlines = new String[]{PApplet.join(loadStrings(compute_shader_path), "\n")};
        int[] vlengths = new int[]{vlines[0].length()};
        compute_shader = gl.glCreateShader(GL4.GL_COMPUTE_SHADER);
        gl.glShaderSoucer(compute_shader, vline.length, vlines, vlengths, 0);
        gl.glCompileShader(compute_shader);

        compute_program = gl.glCreateProgram();
        gl.glAttachShader(compute_program, compute_shader);
        gl.glLinkProgram(compute_program);

        gl.glGenBuffers(1, vbo, 0);
        gl.glBindBuffer(GL4.GL_ARRAY_BUFFER, vbo[0]);
        gl.glBufferData(GL4.GL_ARRAY_BUFFER, verticesFB.limit()*4, verticesFB, GL4.GL_DYNAMIC_DRAW);
        gl.glEnableVertexAttribArray(0);
        gl.glEnableVertexAttribArray(1);
        // Since the Blob struct has 3 vec2 and a Float as variables, then the stride is 28
        // position attribute (no offset)
        gl.glVertexAttribPointer(0, 2, GL4.GL_FLOAT, false, 28, 0);
        // velocity attribute (with (2 * (1 * 4)) = 8 offset)
        gl.glVertexAttribPointer(1, 2, GL4.GL_FLOAT, false, 28, 8);

        ssbo = vbo[0];
        gl.glBindBufferBase(GL4.GL_SHADER_STORAGE_BUFFER, 0, ssbo);
    }

    void release() {
        gl.glDeleteProgram(compute_program);
    }

}