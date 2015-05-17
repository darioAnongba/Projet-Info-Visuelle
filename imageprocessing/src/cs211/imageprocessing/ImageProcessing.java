package cs211.imageprocessing;

import processing.core.*;

public class ImageProcessing extends PApplet {

    private static final long serialVersionUID = 1L;
    
    public static final int WIDTH    = 560;
    public static final int HEIGHT   = 420;
    
    PImage img;
    
    Filters filters;
    Sobel sobel;
    Hough hough;
    
    public void setup() {
        size(WIDTH * 3, HEIGHT);
        
        img = loadImage("board1.jpg");
        img.resize(WIDTH, HEIGHT);
        
        filters = new Filters(this, img);
        sobel = new Sobel(this, filters.getFilteredImg());
        hough = new Hough(this, sobel.img(), 200, 4);
               
        noLoop();
    }
    
    public void draw() {
        background(255);
        image(img, 0, 0);
        hough.getIntersections();
        image(hough.getAccImg(), WIDTH, 0, WIDTH, HEIGHT);
        image(sobel.img(), WIDTH * 2, 0);
    }
        
    public static void main(String[] args) {
        PApplet.main(new String[] { "--present", "ImageProcessing" });
    }

}
