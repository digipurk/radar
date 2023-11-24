/**
 * Arduino Workshop - Digipurk, ylari[at]digipurk.ee
 * Lab - Radar
 */
import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;

final static String PORT = "/dev/cu.usbmodem1442201";
final static boolean DM = true;

Serial port;

int angle, distance;

void setup() {
  size(1200, 700);
  smooth();
  port = new Serial(this, PORT, 9600); // starts the serial communication and change this according to arduino port
  port.bufferUntil('.'); // reads the data from the serial port up to the character '.' so actually it reads this: angle,distance
}

void draw() {
  fill(98, 245, 31);
  noStroke(); // simulating motion blur and slow fade of the moving line
  fill(0, 4); 
  rect(0, 0, width, height - height * 0.065); 
  fill(98, 245, 31); // green color
  drawRadar(); // calls the functions for drawing the radar
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial port) { // starts reading data from the serial port
  String data = port.readStringUntil('.'); // reads the data from the serial port up to the character '.'
  data = data.substring(0, data.length() - 1);
  int index = data.indexOf(","); // find the character ',' and puts it into the variable "index"
  angle = int(data.substring(0, index)); // read the data from position "0" to position of the variable "index" or thats the value of the angle the Arduino Board sent into the Serial Port
  distance = int(data.substring(index + 1, data.length())); // read the data from position "index" to the end of the data or thats the value of the distance
  if (DM)
    distance /= 10;
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI); // draws the arc lines
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  line(-width / 2, 0, width / 2, 0); // draws the angle lines
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30)));
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60)));
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90)));
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120)));
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150)));
  line((-width / 2) * cos(radians(30)), 0, width / 2, 0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255, 10, 10); // red color
  float pixsDistance = distance * ((height - height * 0.1666) * 0.025); // covers the distance from the sensor from cm/dm to pixels
  if (distance < 40) // limiting the range to 40 cm/dm
    line(pixsDistance * cos(radians(angle)), -pixsDistance * sin(radians(angle)), (width - width * 0.505) * cos(radians(angle)), -(width - width * 0.505) * sin(radians(angle))); // draws the object according to the angle and the distance
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074); // moves the starting coordinats to new location
  line(0, 0, (height - height * 0.12) * cos(radians(angle)), -(height - height * 0.12) * sin(radians(angle))); // draws the line according to the angle
  popMatrix();
}

void drawText() { // draws the texts on the screen
  pushMatrix();
  String noObject;
  print(distance, "\n");
  if (distance > 40)
    noObject = "Out of Range";
  else
    noObject = "In Range";
  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);
  text(DM ? "1m" : "10cm", width - width * 0.3854, height - height * 0.0833);
  text(DM ? "2m" : "20cm", width - width * 0.281, height - height * 0.0833);
  text(DM ? "3m" : "30cm", width - width * 0.177, height - height * 0.0833);
  text(DM ? "4m" : "40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);
  text("DIGIPURK", width - width * 0.875, height - height * 0.0277);
  text("Angle: " + angle + " °", width - width * 0.48, height - height * 0.0277);
  text("Dist: ", width - width * 0.26, height - height * 0.0277);
  if (distance < 40)
    text("        " + (DM ? distance * 10 : distance) + " cm", width - width * 0.225, height - height * 0.0277);
  textSize(25);
  fill(98, 245, 60);
  translate((width - width * 0.4994) + width / 2 * cos(radians(30)), (height - height * 0.0907) - width / 2 * sin(radians(30)));
  rotate(-radians(-60));
  text("30°", 0, 0);
  resetMatrix();
  translate((width - width * 0.503) + width / 2 * cos(radians(60)), (height - height * 0.0888) - width / 2 * sin(radians(60)));
  rotate(-radians(-30));
  text("60°", 0, 0);
  resetMatrix();
  translate((width - width * 0.507) + width / 2 * cos(radians(90)), (height - height * 0.0833) - width / 2 * sin(radians(90)));
  rotate(radians(0));
  text("90°", 0, 0);
  resetMatrix();
  translate(width - width * 0.513 + width / 2 * cos(radians(120)), (height - height * 0.07129) - width / 2 * sin(radians(120)));
  rotate(radians(-30));
  text("120°", 0, 0);
  resetMatrix();
  translate((width - width * 0.5104) + width / 2 * cos(radians(150)), (height - height * 0.0574) - width / 2 * sin(radians(150)));
  rotate(radians(-60));
  text("150°", 0, 0);
  popMatrix();
}
