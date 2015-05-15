package cs211.imageprocessing;

import processing.core.*;

public class ImageProcessing extends PApplet {

    private static final long serialVersionUID = 1L;

    PImage img;
    
    Sobel sobel;
    Hough hough;
    
    public void setup() {
        size(800, 600);
        img = loadImage("board1.jpg");
        sobel = new Sobel(this, myHue(img));
        hough = new Hough(this, sobel.img());
                
        noLoop();
    }
    
    public void draw() {
        background(img);
        image(hough.img(), 0, 0);
    }
    
    public PImage myHue(PImage img) {
        PImage result = createImage(img.width, img.height, ALPHA);
        
        for(int i = 0; i < img.width * img.height; i++) {
            int p = img.pixels[i];
            float h = hue(p);
            float b = brightness(p);
            float s = saturation(p);
            
            if(h <= 135 && h >= 110 && b > 20 && b < 220 && s > 30) {
                result.pixels[i] = color(255);
            }
            else {
                result.pixels[i] = 0;
            }
        }
        
        return result;
    }
    
    public static void main(String[] args) {
        PApplet.main(new String[] { "--present", "ImageProcessing" });
    }

}
