#include <SPI.h>
#include <WiFiNINA.h>
#include <utility/wifi_drv.h>
#include <ArduinoMqttClient.h>
#include "SECRET.h"
#include "DHT.h"

#define DHTPIN 2 
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);


char ssid[] = "JASMEET 5503";        // your network SSID (name)
char pass[] = "1U08+3c2";    // your network password (use for WPA, or use as key for WEP)
int keyIndex = 0;                // your network key Index number (needed only for WEP)

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "raspberrypi.local";
int        port     = 1883;
const char topic[]  = "test";
const char topic0[] = "/Sensor/Temperature";
const char topic1[] = "/Sensor/Humidity";


const long interval = 10000;
unsigned long previousMillis = 0;
int count = 0;

WiFiServer server(80);


void setup() {
  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // attempt to connect to Wifi network:
  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    // failed, retry
    Serial.print(".");
    delay(5000);
  }

  Serial.println("You're connected to the network");
  Serial.println();

  Serial.print("Attempting to connect to the MQTT broker: ");
  Serial.println(broker);
  mqttClient.setUsernamePassword("jas1", "jasmeet");
  if (!mqttClient.connect(broker, port)) {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());

    while (1);
  }

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();
  dht.begin(); 
}

void loop() {
  // call poll() regularly to allow the library to send MQTT keep alive which
  // avoids being disconnected by the broker
  mqttClient.poll();

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    // save the last time a message was sent
    previousMillis = currentMillis;

    //record random value from A0, A1 and A2
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    if (isnan(h) || isnan(t)) {
      Serial.println("Error reading the sensor");
      return;
    }
    const char Rvalue[] = "Test";


    Serial.print("Sending message to topic: ");
    Serial.println(topic0);
    Serial.println(t);

    Serial.print("Sending message to topic: ");
    Serial.println(topic1);
    Serial.println(t);


    Serial.print("Sending message to topic: ");
    Serial.println(topic);
    Serial.println(h);
    // send message, the Print interface can be used to set the message contents
    mqttClient.beginMessage(topic);
    mqttClient.print(t);
    mqttClient.endMessage();

    mqttClient.beginMessage(topic0);
    mqttClient.print(t);
    mqttClient.endMessage();

    mqttClient.beginMessage(topic1);
    mqttClient.print(h);
    mqttClient.endMessage();
  
    Serial.println();

    if(WiFi.status() != WL_CONNECTED){
      Serial.print("WiFi Dissconected");
      while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
        // failed, retry
        Serial.print(".");
        delay(5000);
      }
    }
  }
}