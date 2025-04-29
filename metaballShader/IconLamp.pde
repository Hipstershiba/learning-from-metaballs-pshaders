import com.jogamp.opengl.*;
import com.jogamp.common.nio.Buffers;
import java.nio.FloatBuffer;

BlobSystem blobSystem;
GL4 gl;

void setup() {
    size(800, 800, P3D);

    PGL pgl = ((PGraphicsOpenGL) g).pgl;
    gl = ((PJOGL)pgl).gl.getGL4();

    blobSystem = new BlobSystem(1000);
}

void draw() {
    background(0);
    blobSystem.update();
    blobSystem.render();
}

void dispose() {
    blobSystem.release();
}