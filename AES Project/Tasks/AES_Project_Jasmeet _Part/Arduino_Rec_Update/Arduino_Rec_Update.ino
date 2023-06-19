#include <WiFi.h>
#include <PubSubClient.h>

#define motorA1 7
#define motorA2 6
#define motorPowerA 10

int Led_Red = 13;
int Led_Green = 12;
int Led_Blue = 8;

const char* ssid = "JASMEET 5503";
const char* password = "1U08+3c2";
const char* mqttServer ="raspberrypi.local";
const int mqttPort = 1883;


const char topic[]  = "test";
const char topic0[] = "/Sensor/Temperature";
const char topic1[] = "/Sensor/Humidity";

char* temperature;

WiFiClient espClient;
PubSubClient client(espClient);

void setup(){
  pinMode(motorA1,OUTPUT);
  pinMode(motorA2,OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode (Led_Red, OUTPUT);
  pinMode (Led_Green, OUTPUT);
  pinMode (Led_Blue, OUTPUT);
  analogWrite(motorPowerA, 160);

  Serial.begin(9600);
  delay(1000);
  pinMode(LED_BUILTIN, OUTPUT);

  WiFi.begin(ssid, password);
  while(WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(500);\
    Serial.println("\nConnecting");
  }

  Serial.println("\nConnected to the WiFi network");
  client.setServer(mqttServer, mqttPort);
  while (!client.connected()) {
    Serial.println("Connecting to MQTT...");
 
    if (client.connect("ESP32Client", "jas1", "jasmeet" )) {
      Serial.println("connected");
    } else {
      Serial.print("failed with state ");
      Serial.print(client.state());
      delay(2000);
    }
  }
  client.subscribe(topic);
  client.subscribe(topic0);
  client.subscribe(topic1);
  client.setCallback(callback);
 
}

void Motor(int Temperature){
  if (Temperature > 26){
    digitalWrite(motorA1,HIGH);
    digitalWrite(motorA2,LOW);
    digitalWrite(LED_BUILTIN, HIGH);
  }
  else{
    digitalWrite(motorA1,LOW);
    digitalWrite(motorA2,LOW);
    digitalWrite(LED_BUILTIN, LOW);
  }
}

void LED(int Humidity){
 int H_value = Humidity;
 if(H_value > 60)
    {
      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, HIGH);
      digitalWrite(Led_Blue, LOW);
    }
     else if (H_value < 50)
    {
      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, HIGH);
    }
    else if(H_value >= 50  || H_value <= 60)
    {
      digitalWrite(Led_Green, HIGH);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, LOW);
    }
    else {
      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, LOW);
    }
}


void callback(char* topic, byte* payload, unsigned int length){
  Serial.println("");
  Serial.println(length);
  Serial.print("Message - [ ");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  if (strcmp(topic, topic0) == 0)
  {
    payload[length]= '\0'; 
    Serial.println("");
    int Temp = atoi((char*)payload);
    Serial.print("Char array After: ");
    Serial.print(Temp);
    Motor(Temp);

  }

  if (strcmp(topic, topic1) == 0)
  {
    payload[length]= '\0'; 
    Serial.println("");
    int Temp = atoi((char*)payload);
    Serial.print("Char array After: ");
    Serial.print(Temp);
    LED(Temp);

  }
}
void loop(){
  if(WiFi.status() != WL_CONNECTED){
      while(WiFi.status() != WL_CONNECTED){
      Serial.print(".");
      delay(100);
    }
  }
  while (!client.connected()) {
    Serial.println("Connecting to MQTT...");
 
    if (client.connect("ESP32Client", "jas1", "jasmeet" )) {
      Serial.println("connected");
    } else {
      Serial.print("failed with state ");
      Serial.print(client.state());
      delay(2000);
    }
  }
  client.loop();
}

