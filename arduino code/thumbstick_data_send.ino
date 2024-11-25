int buttonPin = 2;
void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
}

int fire_button;
int fire_button_prev = LOW;

void loop() {
  fire_button = digitalRead(buttonPin);
  int joyStickA_X = analogRead(A0);
  int joyStickA_Y = analogRead(A1);
  int joyStickB_X = analogRead(A2);
  int joyStickB_Y = analogRead(A3);

  // Use a string to accumulate the data before sending it
  String serialData = "";

  if (fire_button_prev == LOW && fire_button == HIGH) {
    serialData += "1,";
  } else {
    serialData += "0,";
  }

  serialData += String(joyStickA_X) + ",";
  serialData += String(joyStickA_Y) + ",";
  serialData += String(joyStickB_X) + ",";
  serialData += String(joyStickB_Y) + "\n";

  Serial.print(serialData);

  fire_button_prev = fire_button;

  delay(10);  // Small delay to avoid overwhelming the serial buffer
}
