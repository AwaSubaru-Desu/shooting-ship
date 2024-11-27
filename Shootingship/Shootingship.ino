#include "SerialRecord.h"

SerialRecord writer(1);

void setup() {

  Serial.begin(9600);

}

void loop() {

  int value = Analog(A0)

  writer[0] = value;

  writer.send();

  // This delay slows down the loop, so that it runs less frequently. This can

  // make it easier to debug the sketch, because new values are printed at a

  // slower rate.

  delay(10);

}