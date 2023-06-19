#include "DHT.h"
#include <ArduinoMqttClient.h>
#include "WifiData.h"
#include "WiFiNINA.h"
#define DHTPIN 2

//wifi
char ssid[]= SECRET_SSID; 
char pass[]= SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "192.168.137.35";
int port = 1883;
const char topic[] = "Humidity";

//messages interval
const long interval = 8000;
unsigned long previousMillis = 0;

int count = 0;


// initialize sensor
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

void setup()
{
  Serial.begin(9600);
  while(!Serial) {;}
  Serial.println("Trying to connect");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass ) != WL_CONNECTED)
  {
    Serial.println("Failed.... Please Retry to connect");
    delay(3000);
  }
  Serial.println("Connected");
  Serial.println();

  Serial.println("Trying to connect to Mqtt broker");
  Serial.println(broker);

  if(!mqttClient.connect(broker, port))
  {
    Serial.println("MQTT connection failed! error= ");
    Serial.println(mqttClient.connectError());
    while(1);
  }

  Serial.println("Connected to the broker");
  
  Serial.println("Humidity measurment for the smart beehive");
  dht.begin();
}

void loop()
{
    //Measure Humidity
  float h = dht.readHumidity();
  if(isnan(h))
  {
    Serial.println("There is an error while reading the sensor");
    return;
  }
  
  mqttClient.poll();

  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis >= interval)
  {
    previousMillis = currentMillis;  

    int Rvalue = analogRead(A0);

    Serial.println(" Sending message Topic");
    Serial.println(topic);
    Serial.println(h);

    //send message
    mqttClient.beginMessage(topic);
    mqttClient.print(h);
    mqttClient.print(" h");
    mqttClient.endMessage();

    Serial.println();
    
  }
  
  // wait 1s before displaying next measurment
  delay(1000);

  /*Serial.println("********Measurments********");
  Serial.print("Humidity:");
  Serial.print(h);
  Serial.println("h ");
  Serial.println("***************************");*/
}
