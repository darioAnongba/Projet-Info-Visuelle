package cs211.imageprocessing;

import processing.core.*;

public final class Filters {

    private PImage img;
    private PImage filteredImg;
    private PImage blurImg;

    private PApplet parent;

    Filters(PApplet p, PImage img) {
        this.parent = p;
        this.img = img;

        hueBrightSat(110, 135, 30, 20);
        blur();
    }

    private void hueBrightSat(float minH, float maxH, float thresholdS,
            float thresholdB) {
        filteredImg = parent.createImage(img.width, img.height,
                PConstants.ALPHA);

        for (int i = 0; i < img.width * img.height; i++) {
            int p = img.pixels[i];
            float h = parent.hue(p);
            float b = parent.brightness(p);
            float s = parent.saturation(p);

            if ((minH <= h && h <= maxH) && (b > thresholdB)
                    && (s > thresholdS)) {
                filteredImg.pixels[i] = parent.color(255);
            } else {
                filteredImg.pixels[i] = 0;
            }
        }
    }

    public PImage getFilteredImg() {
        return filteredImg;
    }

    public void blur() {
        float[][] kernel = { { 9, 12, 9 }, { 12, 15, 12 }, { 9, 12, 9 } };
        int[][] tab = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 0}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
        
        float weight = 99f;
        
        PImage blurImg = parent.createImage(img.width, img.height, PConstants.ALPHA);
        
        for (int x = 0; x < img.width; x++) {
        	for (int y = 0; y < img.height; y++) {
        		// if borders, just copy/paste from img
        		if (x == 0 || x == img.width - 1 || y == 0 || y == img.height - 1) {
        			blurImg.pixels[y * img.width + x] = img.pixels[y * img.width + x];
        		}
        		else {
        			int sum = 0;
            		for (int[] tuple : tab) {
            			sum += kernel[1+tuple[0]][1+tuple[1]] * getPix(x + tuple[0], y + tuple[1]);
            		}
            		blurImg.pixels[y * img.width + x] = Math.round(sum / weight);
        		}
        	}
        }
    }
    
    private int getPix(int i, int j) {
    	return img.pixels[i + j*img.width];
    }

    public PImage getBlurImg() {
        return blurImg;
    }

}
