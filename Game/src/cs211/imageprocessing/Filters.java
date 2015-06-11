package cs211.imageprocessing;

import processing.core.*;

public final class Filters {

    private PImage img;
    private PImage filteredImg;
    private PImage blurImg;
    private PImage intensityImg;

    private PApplet parent;

    public Filters(PApplet p, PImage img) {
        this.parent = p;
        this.img = img;

        filteredImg = parent.createImage(img.width, img.height, PConstants.ALPHA);
        hueSat(75f, 135f, 60f);
        
        blurImg = parent.createImage(img.width, img.height, PConstants.ALPHA);
        blur();
        
        intensityImg = parent.createImage(img.width, img.height, PConstants.ALPHA);
        intensity(15f);
    }

    private void hueSat(float minH, float maxH, float thresholdS) {
        for (int i = 0; i < img.width * img.height; i++) {
            int p = img.pixels[i];
            float h = parent.hue(p);
            float s = parent.saturation(p);

            if ((minH <= h && h <= maxH) && (s > thresholdS)) {
                filteredImg.pixels[i] = parent.color(255);
            } else {
                filteredImg.pixels[i] = 0;
            }
        }
        
        filteredImg.updatePixels();
    }

    public PImage getFilteredImg() {
        return filteredImg;
    }

    public void blur() {
        float[][] kernel = { { 9, 12, 9 }, { 12, 15, 12 }, { 9, 12, 9 } };
        
        float weight = 99f;
        
        filteredImg.loadPixels();

        for(int i = 1 ; i < img.width - 1; i++){
            for(int j = 1; j < img.height - 1; j++){
                int sum = 0;
                
                for(int x = -1 ; x <= 1; x++) {
                    for (int y = -1; y <= 1; y++){
                        int idx = (j + y) * img.width + (i + x);
                        sum += parent.brightness(filteredImg.pixels[idx]) * kernel[y+1][x+1];
                    }
                    
                    int value = (int) (sum/weight);
                    blurImg.pixels[j * img.width + i ] = value;
                }
            }
        }
        
        blurImg.updatePixels();
    }

    public PImage getBlurImg() {
        return blurImg;
    }
    
    private void intensity(float threshold) {
        parent.colorMode(PConstants.HSB, 255);
        
        for (int i = 0; i < img.width * img.height; i++) {
            int p = blurImg.pixels[i];
            float b = parent.brightness(p);

            if (b > threshold) {
                intensityImg.pixels[i] = p;
            } else {
                intensityImg.pixels[i] = 0;
            }
        }
        
        intensityImg.updatePixels();
        parent.colorMode(PConstants.RGB, 255);
    }
    
    public PImage getIntensityImg() {
        return intensityImg;
    }
    
    public PImage getImg() {
        return img;
    }
}
