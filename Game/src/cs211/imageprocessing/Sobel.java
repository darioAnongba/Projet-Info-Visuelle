package cs211.imageprocessing;
import processing.core.*;

public final class Sobel {

    private PImage img;
    private PApplet parent;
    
    public Sobel(PApplet parent, PImage img) {
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
                int idx = 0;
                float sum_h = 0;
                float sum_v = 0;
                
                for (int i = -1; i < 2; ++i) {
                    for (int j = -1; j < 2; ++j) {
                        idx = (y + j) * img.width + (x + i);
                        sum_h += img.get(x+i, y+j) * hKernel[i+1][j+1];
                        sum_v += img.get(x+i, y+j) * vKernel[i+1][j+1];
                    }
                }
                int sum = (int)Math.sqrt(Math.pow(sum_h, 2) + Math.pow(sum_v, 2));
                max = sum > max ? sum : max;
                
                buffer[idx] = sum;
            }
        }
                
        for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
            for (int x = 2; x < img.width - 2; x++) { // Skip left and right
                if (buffer[y * img.width + x] > (int)(max * 0.25f)) { // 30% of the max
                    result.pixels[y * img.width + x] = parent.color(255);
                } else {
                    result.pixels[y * img.width + x] = parent.color(0);
                }
            }
        }
        return result;
    }
}
