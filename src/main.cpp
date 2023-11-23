/*
 * Arduino Workshop - Digipurk, ylari[at]digipurk.ee
 * Lab - Radar
 */
#include <Arduino.h>
#include <Servo.h>

#define TRIGGER 10
#define ECHO 11

#define SERVO 12

#define LED_RED 5
#define LED_YELLOW 4
#define LED_GREEN 3

#define BUZZER 7

#define ALERT 50
#define WARNING 150

Servo servo;

void setup() {
  pinMode(TRIGGER, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(LED_RED, OUTPUT);
  pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  Serial.begin(9600);
  servo.attach(SERVO);
}

void red() {
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, HIGH);
  digitalWrite(LED_GREEN, LOW);
  tone(BUZZER, 1000);
}

void yellow() {
  digitalWrite(LED_YELLOW, HIGH);
  digitalWrite(LED_RED, LOW);
  digitalWrite(LED_GREEN, LOW);
  noTone(BUZZER);
}

void green() {
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW);
  digitalWrite(LED_GREEN, HIGH);
  noTone(BUZZER);
}

int distance() { // calculates distance measured by the ultrasonic sensor
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER, HIGH); // sets trigger high state for 10 microseconds
  delayMicroseconds(10);
  digitalWrite(TRIGGER, LOW);
  long duration = pulseIn(ECHO, HIGH, 250000); // returns the sound wave travel time in microseconds
  int distance = duration * 0.0343 / 2;        // t * speed of sound / 2
  if (distance < WARNING && distance >= ALERT)
    yellow();
  else if (distance < ALERT && distance > 0)
    red();
  else
    green();
  return distance;
}

void send(int degree) {
  servo.write(degree);
  delay(30);
  Serial.print(degree);
  Serial.print(",");
  Serial.print(distance());
  Serial.print(".");
}

void loop() {
  for (int i = 0; i < 180; i++) // rotates the servo motor from 0 to 180 degrees
    send(i);
  for (int i = 180; i >= 0; i--) // repeates in the opposite direction
    send(i);
}