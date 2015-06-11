package cs211.imageprocessing;

import java.util.*;

import processing.core.*;
import processing.video.*;

public class ImageProcessing extends PApplet {

    private static final long serialVersionUID = 1L;
    
    public static final int WIDTH    = 600;
    public static final int HEIGHT   = 480;
    
    PImage img;
    Movie cam;
    
    Filters filters;
    Sobel sobel;
    Hough hough;
    
    public static PGraphics quadsDraw;
    
    TwoDThreeD twoDthreeD;
    
    public void setup() {
        size(WIDTH, HEIGHT);
        
        cam = new Movie(this, "testvideo.mp4"); //Put the video in the same directory
        cam.loop();
        
        /*img = loadImage("board3.jpg");
        img.resize(WIDTH, HEIGHT);
        
        filters = new Filters(this, img);
        sobel = new Sobel(this, filters.getIntensityImg());
        hough = new Hough(this, sobel.img(), 200);*/
        
        quadsDraw = createGraphics(WIDTH, HEIGHT);
        twoDthreeD = new TwoDThreeD(WIDTH,HEIGHT);
             
        //noLoop();
    }
    
    public void draw() {
        background(255);
        
        if (cam.available() == true) {
        	cam.read();
        }
        img = cam.get();
        
        filters = new Filters(this, img);
        sobel = new Sobel(this, filters.getIntensityImg());
        hough = new Hough(this, sobel.img(), 200);
        
        image(img, 0, 0);
        
        hough.getIntersections();
        
        List<PVector> corners;
        corners = hough.hough();	
        //corners = drawQuad(corners);
        
        PVector rot = twoDthreeD.get3DRotations(QuadGraph.sortCorners(corners));
        println("-> rx : "+degrees(rot.x)+", ry : "+degrees(rot.y)+", rz : "+degrees(rot.z));
    }
    
    public PVector intersection(PVector line1, PVector line2) {
    	float d = PApplet.cos(line2.y) * PApplet.sin(line1.y) - PApplet.cos(line1.y) * PApplet.sin(line2.y);
        float x = (line2.x * PApplet.sin(line1.y) - line1.x * PApplet.sin(line2.y)) / d;
        float y = (-line2.x * PApplet.cos(line1.y) + line1.x * PApplet.cos(line2.y)) / d;
        
        return new PVector(x, y);
    }
    
    public List<PVector> drawQuad(List<PVector> corners) {

    	List<PVector> toReturn = new ArrayList<PVector>();
        QuadGraph qg = new QuadGraph();
        qg.build(corners, WIDTH, HEIGHT);

        List<int[]> quads = qg.findCycles();

        quadsDraw.beginDraw();
        quadsDraw.clear();
        for (int[] quad : quads) {
            PVector l1 = corners.get(quad[0]);
            PVector l2 = corners.get(quad[1]);
            PVector l3 = corners.get(quad[2]);
            PVector l4 = corners.get(quad[3]);

            PVector c12 = intersection(l1, l2);
            PVector c23 = intersection(l2, l3);
            PVector c34 = intersection(l3, l4);
            PVector c41 = intersection(l4, l1);

            if(QuadGraph.isConvex(c12, c23, c34, c41)
            		&& QuadGraph.nonFlatQuad(c12, c23, c34, c41)
            		&& QuadGraph.validArea(c12, c23, c34, c41, 200000, 50000)
            		) {
                // Choose a random, semi-transparent colour
                Random random = new Random();
                quadsDraw.fill(color(min(255, random.nextInt(300)),
                        min(255, random.nextInt(300)),
                        min(255, random.nextInt(300)), 50));
                quadsDraw.quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
                
                toReturn.add(c12);
                toReturn.add(c23);
                toReturn.add(c34);
                toReturn.add(c41);
            }
        }
        quadsDraw.endDraw();
        image(quadsDraw,0,0, WIDTH, HEIGHT);
        
        return toReturn;
    }
}
