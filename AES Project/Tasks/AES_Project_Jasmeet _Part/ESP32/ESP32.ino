#include <WiFi.h>
#include <PubSubClient.h>

#define motorA1 A1
#define motorA2 A2
#define motorPower 10

const char* ssid = "JASMEET 5503";
const char* password = "1U08+3c2";
const char* mqttServer ="raspberrypi.local";
const int mqttPort = 1883;

char* temperature;

WiFiClient espClient;
PubSubClient client(espClient);

void setup(){
  pinMode(motorA1,OUTPUT);
  pinMode(motorA2,OUTPUT);
  //analogWrite(motorPowerA, 160);

  Serial.begin(115200);
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
  client.subscribe("test");
  client.setCallback(callback);
 
}

void Motor(int Temperature){
  if (Temperature > 26){
    digitalWrite(motorA1,HIGH);
    digitalWrite(motorA2,LOW);
  }
  else{
    digitalWrite(motorA1,LOW);
    digitalWrite(motorA2,LOW)
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
  if (strcmp(topic, "test") == 0)
  {
    payload[length]= '\0'; 
    Serial.println("");
    int Temp = atoi((char*)payload);
    Serial.print("Char array After: ");
    Serial.print(Temp);
    Motor(Temp);

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

