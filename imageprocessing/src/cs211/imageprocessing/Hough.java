package cs211.imageprocessing;
import processing.core.*;

public final class Hough {

    private PImage edgeImg;
    PApplet parent;
    
    Hough(PApplet p, PImage img) {
        parent = p;
        this.edgeImg = img;
    }
    
    public PImage img() {
        float discretizationStepsPhi = 0.06f;
        float discretizationStepsR = 2.5f;
        // dimensions of the accumulator
        int phiDim = (int) (Math.PI / discretizationStepsPhi);
        int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
        // our accumulator (with a 1 pix margin around)
        int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
        // Fill the accumulator: on edge points (ie, white pixels of the edge
        // image), store all possible (r, phi) pairs describing lines going
        // through the point.
        
        float[] sinTable = new float[phiDim];
        float[] cosTable = new float[phiDim];
        float angle = 0f;
        float rInversed = 1f / discretizationStepsR;
        for (int i = 0 ; i < phiDim; angle += discretizationStepsPhi, i++)
        {
          sinTable[i] = (float)Math.sin(angle) * rInversed;
          cosTable[i] = (float)Math.cos(angle) * rInversed;
        }
        
        for (int y = 0; y < edgeImg.height; y++) {
            for (int x = 0; x < edgeImg.width; x++) {
                if (parent.brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
                    // ...determine here all the lines (r, phi) passing through
                    // pixel (x,y), convert (r,phi) to coordinates in the
                    // accumulator, and increment accordingly the accumulator.
                    for (float phi = 0; phi < Math.PI; phi += discretizationStepsPhi) {
                        int accPhi = (int)(phi / discretizationStepsPhi);
                        float r = x * cosTable[accPhi] + y * sinTable[accPhi];
                        float accR = (r + (rDim - 1) * 0.5f);
                        int idx = (int)((1f + accR + (accPhi + 1f) * (rDim + 2f)));
                        
                        accumulator[idx] += 1;
                    }
                }
            }
        }
        
        PImage img = parent.createImage(rDim + 2, phiDim + 2, parent.ALPHA);
        
        for (int idx = 0; idx < accumulator.length; idx++) {
            if (accumulator[idx] > 200) {
                // first, compute back the (r, phi) polar coordinates:
                int accPhi = (int) (idx / (rDim + 2)) - 1;
                int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
                float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
                float phi = accPhi * discretizationStepsPhi;
                // Cartesian equation of a line: y = ax + b
                // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
                // => y = 0 : x = r / cos(phi)
                // => x = 0 : y = r / sin(phi)
                // compute the intersection of this line with the 4 borders of
                // the image
                int x0 = 0;
                int y0 = (int) (r / Math.sin(phi));
                int x1 = (int) (r / Math.cos(phi));
                int y1 = 0;
                int x2 = edgeImg.width;
                int y2 = (int) (-Math.cos(phi) / Math.sin(phi) * x2 + r / Math.sin(phi));
                int y3 = edgeImg.width;
                int x3 = (int) (-(y3 - r / Math.sin(phi)) * (Math.sin(phi) / Math.cos(phi)));
                // Finally, plot the lines
                parent.stroke(204, 102, 0);
                if (y0 > 0) {
                    if (x1 > 0)
                        parent.line(x0, y0, x1, y1);
                    else if (y2 > 0)
                        parent.line(x0, y0, x2, y2);
                    else
                        parent.line(x0, y0, x3, y3);
                } else {
                    if (x1 > 0) {
                        if (y2 > 0)
                            parent.line(x1, y1, x2, y2);
                        else
                            parent.line(x1, y1, x3, y3);
                    } else
                        parent.line(x2, y2, x3, y3);
                }
            }
        }
        
        return img;
    }
}
