package cs211.imageprocessing;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import processing.core.*;

public final class Hough {

    private PImage edgeImg;
    private int minVotes;
    private PImage accImg;
    private PApplet parent;
    
    Hough(PApplet p, PImage img, int minVotes) {
        parent = p;
        edgeImg = img;
        this.minVotes = minVotes;
        
        //accImg is an "Empty" image before calling hough
        accImg = parent.createImage(0, 0, 0);
    }
    
    public ArrayList<PVector> hough() {
        float discretizationStepsPhi = 0.06f;
        float discretizationStepsR = 2.5f;
        
        // dimensions of the accumulator
        int phiDim = (int) (Math.PI / discretizationStepsPhi);
        int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
        
        // our accumulator (with a 1 pix margin around)
        int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
        
        // pre-compute the sin and cos values
        float[] tabSin = new float[phiDim];
        float[] tabCos = new float[phiDim];
        
        float ang = 0;
        float inverseR = 1.f / discretizationStepsR;
        
        for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
            // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
            tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
            tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
        }
        
        for (int y = 0; y < edgeImg.height; y++) {
            for (int x = 0; x < edgeImg.width; x++) {
                if (parent.brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {

                    for (int phiIdx = 0; phiIdx < phiDim; phiIdx++) {
                        float phi = phiIdx * discretizationStepsPhi;
                        int accPhi = Math.round(phi / discretizationStepsPhi);
                        
                        float r = x * tabCos[accPhi] +  y * tabSin[accPhi];
                        r += (rDim - 1.f) / 2.f;
                        
                        int idx = Math.round(r + (phiIdx + 1) * (rDim + 2) + 1);
                        
                        accumulator[idx] += 1;
                    } 
                }
            }
        }
        
        // Create the accumulator image and store it in accImg
        accImg = parent.createImage(rDim + 2, phiDim + 2, PConstants.ALPHA);
        
        for (int i = 0; i < accumulator.length; i++) {
            accImg.pixels[i] = parent.color(Math.min(255, accumulator[i]));
        }
        accImg.updatePixels();
        
        // Choose best lines
        ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
        
        // size of the region we search for a local maximum
        int neighbourhood = 10;
        
        for (int accR = 0; accR < rDim; accR++) {
            for (int accPhi = 0; accPhi < phiDim; accPhi++) {
                
                // compute current index in the accumulator
                int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
                
                if (accumulator[idx] > minVotes) {
                    
                    boolean bestCandidate = true;
                    
                    // iterate over the neighbourhood
                    for (int dPhi = -neighbourhood / 2; dPhi < neighbourhood / 2 + 1; dPhi++) {
                        
                        // check we are not outside the image
                        if (accPhi + dPhi < 0 || accPhi + dPhi >= phiDim) continue;
                        
                        for (int dR = -neighbourhood / 2; dR < neighbourhood / 2 + 1; dR++) {

                            // check we are not outside the image
                            if (accR + dR < 0 || accR + dR >= rDim) continue;
                            
                            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
                            
                            if (accumulator[idx] < accumulator[neighbourIdx]) {
                                // the current idx is not a local maximum!
                                bestCandidate = false;
                                break;
                            }
                        }
                        if (!bestCandidate) break;
                    }
                    if (bestCandidate) {
                        // the current idx *is* a local maximum
                        bestCandidates.add(idx);
                    }
                }
            }
        }

        Collections.sort(bestCandidates, new HoughComparator(accumulator));
        
        ArrayList<PVector> vectorsLines = new ArrayList<PVector>();
        
        for (int i = 0; i < 4 && i < bestCandidates.size() ; i++) {
            int idx = bestCandidates.get(i);

                // first, compute back the (r, phi) polar coordinates:
                int accPhi = (int) (idx / (rDim + 2)) - 1;
                int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
                float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
                float phi = accPhi * discretizationStepsPhi;

                vectorsLines.add(new PVector(r, phi));
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
                    if (x1 > 0) {
                        parent.line(x0, y0, x1, y1);
                    }
                    else if (y2 > 0) {
                        parent.line(x0, y0, x2, y2);
                    }
                    else {
                        parent.line(x0, y0, x3, y3);
                    }
                } else {
                    if (x1 > 0) {
                        if (y2 > 0) {
                            parent.line(x1, y1, x2, y2);
                        }
                        else {
                            parent.line(x1, y1, x3, y3);
                        }
                    } else {
                        parent.line(x2, y2, x3, y3);
                    }
                }
        }
        return vectorsLines;
    }
    
    public PImage getAccImg() {
        return accImg;
    }
    
    public ArrayList<PVector> getIntersections() {
        List<PVector> lines = hough();
        ArrayList<PVector> intersections = new ArrayList<PVector>();
        
        for (int i = 0; i < lines.size() - 1; i++) {
            PVector line1 = lines.get(i);
            
            for (int j = i + 1; j < lines.size(); j++) {
                PVector line2 = lines.get(j);
                
                float d = PApplet.cos(line2.y) * PApplet.sin(line1.y) - PApplet.cos(line1.y) * PApplet.sin(line2.y);
                float x = (line2.x * PApplet.sin(line1.y) - line1.x * PApplet.sin(line2.y)) / d;
                float y = (-line2.x * PApplet.cos(line1.y) + line1.x * PApplet.cos(line2.y)) / d;

                // draw the intersection
                parent.fill(255, 128, 0);
                parent.ellipse(x, y, 10, 10);
            }
        }
        return intersections;
    }
}
