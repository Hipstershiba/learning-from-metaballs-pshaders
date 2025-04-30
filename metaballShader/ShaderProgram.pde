import com.jogmap.opengl.GL4;

class ShaderProgram {
    GL4 gl; 

    int shader_Program;
    int vertShader;
    int fragShader;

    ShaderProgram(GL4 gl, String vertex_shader_path, String fragment_shader_path) {
        this.gl = gl;

        String vertSrc = PApplet.join(loadStrings(vertex_shader_path), "\n");
        String fragSrc = PApplet.join(loadStrings(fragment_shader_path), "\n");

        vertShader = createAndCompileShader(GL4.GL_VERTEX_SHADER, vertSrc);
        fragShader = createAndCompileShader(GL4.GL_FRAGMENT_SHADER, fragSrc);

        shader_Program = gl.glCreateProgram();

        gl.glAttachShader(shader_program, vertShader);
        gl.glAttachShader(shader_program, fragShader);

        gl.glLinkProgram(shader_program);
    }

    void begin() {
        gl.glUseProgram(shader_program);
    }

    void draw(int count) {
        gl.glDrawArrays(GL4.GL_POINTS, 0, count);
    }

    int createAndCompileShader(int type, String shaderString) {
        int shader = gl.glCreateShader(type);

        String[] vlines = new String[]{shaderString};
        int[] vlengths = new int[]{vlines[0].length()};

        gl.glShaderSource(shader, vlies.length, vlines, vlengths, 0);
        gl.glCompileShader(shader);

        int[] compiled = new int[1];
        gl.glGetShaderiv(shader, GL4.GL_COMPILE_STATUS, compiled, 0);

        if(compiled[0] == 0) {
            int[logLength] = new int[1];
            gl.glGetShaderiv(shader, GL4.GL_INFO_LOG_LENGTH, logLength, 0);

            byte[] log = new byte[logLength[0]];
            gl.glGetShaderInfoLog(shader, logLength[0], (int[]) null, 0, log, 0);

            throw new IllegalStateException("Error compiling the shader: "+ new String(log));
        }

        return shader;
    }

    

    void release() {
        gl.glDeleteShader(vertShader);
        gl.glDeleteShader(fragShader);
    }

}