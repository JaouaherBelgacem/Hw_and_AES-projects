#define MotorA1 A1
#define MotorA2 A2


void setup() {
  // put your setup code here, to run once:
  pinMode(MotorA1,OUTPUT);
  pinMode(MotorA2,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(MotorA1,HIGH);
  digitalWrite(MotorA2,LOW);
  delay(10000);
  digitalWrite(MotorA1,LOW);
  digitalWrite(MotorA2,LOW);
  delay(10000);

}
