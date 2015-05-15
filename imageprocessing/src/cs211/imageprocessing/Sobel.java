package cs211.imageprocessing;
import processing.core.*;

public final class Sobel {

    private PImage img;
    private PApplet parent;
    
    Sobel(PApplet parent, PImage img) {
        this.img = img;
        this.parent = parent;
    }
    
    public PImage img() {
        float[][] hKernel = { { 0, 1, 0 }, { 0, 0, 0 }, { 0, -1, 0 } };
        float[][] vKernel = { { 0, 0, 0 }, { 1, 0, -1 }, { 0, 0, 0 } };
        PImage result = parent.createImage(img.width, img.height, PConstants.ALPHA);
        // clear the image
        for (int i = 0; i < img.width * img.height; i++) {
            result.pixels[i] = parent.color(0);
        }
        float max = 0;
        float[] buffer = new float[img.width * img.height];
        
        for(int x = 1; x < img.width-1; x++) { 
            for (int y = 1; y < img.height-1; y++) {
                float top = img.pixels[(y * img.width + x) - img.width] * hKernel[0][1];
                float bottom = img.pixels[(y * img.width + x) + img.width] * hKernel[2][1];
                float left = img.pixels[(y * img.width + x) - 1] * hKernel[1][0];
                float right = img.pixels[(y * img.width + x) + 1] * hKernel[1][2];
                float tL = img.pixels[(y * img.width + x) - img.width - 1] * hKernel[0][0];
                float tR = img.pixels[(y * img.width + x) - img.width + 1] * hKernel[0][2];
                float bL = img.pixels[(y * img.width + x) + img.width - 1] * hKernel[2][0];
                float bR = img.pixels[(y * img.width + x) + img.width + 1] * hKernel[2][2];
                float curr = img.pixels[(y * img.width + x)] * hKernel[1][1];
                
                int sum_h = (int)(top + bottom + left + right + tL + tR + bL + bR + curr);
                
                top = img.pixels[(y * img.width + x) - img.width] * vKernel[0][1];
                bottom = img.pixels[(y * img.width + x) + img.width] * vKernel[2][1];
                left = img.pixels[(y * img.width + x) - 1] * vKernel[1][0];
                right = img.pixels[(y * img.width + x) + 1] * vKernel[1][2];
                tL = img.pixels[(y * img.width + x) - img.width - 1] * vKernel[0][0];
                tR = img.pixels[(y * img.width + x) - img.width + 1] * vKernel[0][2];
                bL = img.pixels[(y * img.width + x) + img.width - 1] * vKernel[2][0];
                bR = img.pixels[(y * img.width + x) + img.width + 1] * vKernel[2][2];
                curr = img.pixels[(y * img.width + x)] * vKernel[1][1];

                int sum_v = (int)(top + bottom + left + right + tL + tR + bL + bR + curr);
                
                int sum = (int)Math.sqrt(Math.pow(sum_h, 2) + Math.pow(sum_v, 2));
                
                buffer[(y * img.width + x)] = sum;
                
                if(sum > max) max = sum;
            }
        }
                
        for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
            for (int x = 2; x < img.width - 2; x++) { // Skip left and right
                if (buffer[y * img.width + x] > (int) (max * 0.3f)) { // 30% of
                                                                      // the max
                    result.pixels[y * img.width + x] = parent.color(255);
                } else {
                    result.pixels[y * img.width + x] = parent.color(0);
                }
            }
        }
        return result;
    }
}
