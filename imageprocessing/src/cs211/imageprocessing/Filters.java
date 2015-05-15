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

        float weight = 99;
        
        PImage blurImg = parent.createImage(img.width, img.height, PConstants.ALPHA);
        
        //TODO
    }

    public PImage getBlurImg() {
        return blurImg;
    }

}
