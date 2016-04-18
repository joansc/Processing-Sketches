/****************************************************
  MMT: DSP & Audio Programming
 *****************************************************

   Assignment 2 by Joan Sandoval

 **********************************************************

   --> [Implementation of an averaging filter to smooth
   input values over time.]

   --> [Use of calibration for defining the maximum and
   minimum of expected values for the readings.
   Press as much as you can each FSR sensor in the first 5 seconds in order to
   establish a minumum and a maximum value]

*/

const int noOfReadings = 15; // The number of readings to keep track of.

// Arrays to hold the readings from the analog inputs
int readings1[noOfReadings], readings2[noOfReadings], readings3[noOfReadings], readings4[noOfReadings];

// The running total in the arrays
int total1, total2, total3, total4 = 0;

int index = 0; // The index of the current reading

// The average of all readings in the array
int average1, average2, average3, average4 = 0;

//sensor values
int sensorValue1, sensorValue2, sensorValue3, sensorValue4 = 0;


//minimums and maximums sensor values
//int sensorMin1, sensorMin2, sensorMin3, sensorMin4 = 0;
//int sensorMax1, sensorMax2, sensorMax3, sensorMax4 = 950;

//final values
int finalValue1, finalValue2, finalValue3, finalValue4 = 0;



void setup() {
  Serial.begin(9600);  // Initialize serial communication with computer
  for (int i = 0; i < noOfReadings; i++) {
    // Initialize all the readings to 0
    readings1[i] = 0;
    readings2[i] = 0;
    readings3[i] = 0;
    readings4[i] = 0;
  }

  //Calibration
  // calibrate during the first ten seconds
  /*while (millis() < 5000) {
    sensorValue1 = analogRead(A4);
    sensorValue2 = analogRead(A1);
    sensorValue3 = analogRead(A2);
    sensorValue4 = analogRead(A5);
    // record the maximum sensor value
    if (sensorValue1 > sensorMax1) {
      sensorMax1 = sensorValue1;
    }
    if (sensorValue2 > sensorMax2) {
      sensorMax2 = sensorValue2;
    }
    if (sensorValue3 > sensorMax3) {
      sensorMax3 = sensorValue3;
    }
    if (sensorValue4 > sensorMax4) {
      sensorMax4 = sensorValue4;
    }
    // record the minimum sensor value
    if (sensorValue1 < sensorMin1) {
      sensorMin1 = sensorValue1;
    }
    if (sensorValue2 < sensorMin2) {
      sensorMin2 = sensorValue2;
    }
    if (sensorValue3 < sensorMin3) {
      sensorMin3 = sensorValue3;
    }
    if (sensorValue4 < sensorMin4) {
      sensorMin4 = sensorValue4;
    }
    }*/
}

// the loop routine runs over and over again forever:
void loop() {

  // Subtract the oldest reading from each total
  total1 -= readings1[index];
  total2 -= readings2[index];
  total3 -= readings3[index];
  total4 -= readings4[index];

  // Read from the sensor and place this new reading in the array
  readings1[index] = analogRead(A4);
  readings2[index] = analogRead(A1);
  readings3[index] = analogRead(A2);
  readings4[index] = analogRead(A5);

  // Add the newest reading to the totals
  total1 += readings1[index];
  total2 += readings2[index];
  total3 += readings3[index];
  total4 += readings4[index];

  // Calculate the average of all the readings
  average1 = total1 / noOfReadings;
  average2 = total2 / noOfReadings;
  average3 = total3 / noOfReadings;
  average4 = total4 / noOfReadings;


  int sensorMin1 = 0;
  int sensorMin2 = 0;
  int sensorMin3 = 0;
  int sensorMin4 = 0;
  int sensorMax1 = 950;
  int sensorMax2 = 950;
  int sensorMax3 = 950;
  int sensorMax4 = 950;
  
  // apply the calibration
  finalValue1 = map(average1, sensorMin1, sensorMax1, 0, 255);
  finalValue2 = map(average2, sensorMin2, sensorMax2, 0, 255);
  finalValue3 = map(average3, sensorMin3, sensorMax3, 0, 255);
  finalValue4 = map(average4, sensorMin4, sensorMax4, 0, 255);

  /*Serial.print(average1);
  Serial.print(",");
  Serial.print(sensorMin1);
  Serial.print(",");
  Serial.print(sensorMax1);
  Serial.print(",");
  Serial.print(total1);
  Serial.print(",");
  Serial.print(finalValue1);
  Serial.println(",");*/


  // in case the final value is outside the range
  finalValue1 = constrain(finalValue1, 0, 255);
  finalValue2 = constrain(finalValue2, 0, 255);
  finalValue3 = constrain(finalValue3, 0, 255);
  finalValue4 = constrain(finalValue4, 0, 255);

  //Printing data to the serial port
  Serial.print(finalValue1);
    Serial.print(",");
    Serial.print(finalValue2);
    Serial.print(",");
    Serial.print(finalValue3);
    Serial.print(",");
    Serial.println(finalValue4);
  //Serial.println(readings4[index]);


  index += 1;                           // Advance to the next index
  if (index >= noOfReadings) {          // If the end of the array is reached...
    index = 0;                            // ...wrap around to the beginning
  }

  delay(5);        // Stability
}
