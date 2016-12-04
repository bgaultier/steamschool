/*
  Gunjan <project name> v0.6
  
  Basic webcam recognition software showing geometry principles
  
  by Gunjan & Baptiste
  released under GPLv3 licence
*/


// Import libraries
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.util.Collections;

ArrayList<PVector> points;

Capture video;
OpenCV opencv;

PImage logo;

// These instructions will be executed once at start time
void setup() {
  // Set the size of the window (remember that the webcam res. is 640x480)
  size(640, 480);
  
  // Get video stream from the webcam
  video = new Capture(this, 640, 480);
  
  //Start opencv (recognition lib) with the same res as the webcam
  opencv = new OpenCV(this, 640, 480);
  
  // let's find the markers
  opencv.loadCascade(OpenCV.CASCADE_CLOCK);  
  
  // Start recording using the webcam
  video.start();
  
  // load logo image
  logo = loadImage("logo.png");
}

void draw() {
  // Open needs to process the webcam stream
  opencv.loadImage(video);
  
  // display the logo on bottom right
  image(logo, width-logo.width/2.4, height -logo.height/2.4, logo.width/2.5, logo.height/2.5);

  // we also want to display the video stream in our window
  image(video, 0, 0);
  
  // get ready to draw green rectangles 
  noFill();
  strokeWeight(4);
  
  // detect markers from opencv recognition process
  Rectangle[] markers = opencv.detect();
  
  points = new ArrayList();
  
  PVector point;
  for(int i = 0; i < markers.length; i++) {
     int x = markers[i].x + (markers[i].width/2);
     int y = markers[i].y + (markers[i].height/2);
     point = new PVector(x, y);
     points.add(point);
  }
  
  Collections.sort(points, new LexicalComparison());
  
  // print trhe number of markers we have detected
  // println(markers.length);
  
  // go into the markers array
  /*for (int i = 0; i < markers.length; i++) {
     stroke(0, 255, 0);
    // draw rectangles around markers
    rect(markers[i].x, markers[i].y, markers[i].width, markers[i].height);
    
    // get ready to print black lines
    stroke(0, 0, 0);
    if(i>0 && markers.length > 0) {
      // draw the line between the centers of markers
      line(markers[i-1].x + (markers[i-1].width/2) , markers[i-1].y + (markers[i-1].height/2), markers[i].x + (markers[i].width/2), markers[i].y + (markers[i].width/2));
      
      // display's some clues about the polygon
      switch(markers.length) {
        case 3: text("Is it a triangle ?", 15, 15);
                break;
        case 4: text("Is it a square ?", 15, 15);
                break;
      }
      
      if(i == markers.length -1)
        line(markers[0].x + (markers[0].width/2) , markers[0].y + (markers[0].height/2), markers[i].x + (markers[i].width/2), markers[i].y + (markers[i].width/2));
    }
  }*/
  
  for (int i = 0; i < points.size(); i++) {
    // get ready to print black lines
    stroke(0, 0, 0);
    if(i>0 && points.size() > 0) {
      // draw the line between the centers of points
      line(points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
      
      // display's some clues about the polygon
      switch(points.size()) {
        case 3: text("Is it a triangle ?", 15, 15);
                break;
        case 4: text("Is it a square ?", 15, 15);
                break;
      }
      
      if(i == points.size() -1)
        line(points.get(0).x, points.get(0).y, points.get(i).x, points.get(i).y);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}