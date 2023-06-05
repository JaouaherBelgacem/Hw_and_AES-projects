#include <ArduinoMqttClient.h>
#include "WifiData.h"
#include "WiFiNINA.h"
#include <SoftwareSerial.h>

//wifi
char ssid[]= SECRET_SSID; 
char pass[]= SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);
//PubSubClient client;

const char broker[] = "192.168.137.206";
int port = 1883;
const char aesProjTopic[] = "Humidity";


// initialize actuator

int Led_Red = 13;
int Led_Green = 12;
int Led_Blue = 8;

int value;
void setup()
{
  Serial.begin(9600);
  
  //RGB LED SETUP
  pinMode (Led_Red, OUTPUT);
  pinMode (Led_Green, OUTPUT);
  pinMode (Led_Blue, OUTPUT);
  
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
     //the RGB Led is on ad long as the system is receiving humidity
      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, LOW);
  }

  Serial.println("Connected to the broker");
  
  //set the mssqge receive callback
  mqttClient.onMessage(onMqttMessage);

  Serial.print("I am subscribing to the following topic: ");
  Serial.println(aesProjTopic);
  Serial.println();

  //subcribe to the topic
  mqttClient.subscribe(aesProjTopic);
  Serial.print("Listening to the broker: ");
  Serial.println(aesProjTopic);
  Serial.println();
}


void loop()
{ 
  mqttClient.poll();
}

  void onMqttMessage(int messageSize)
  {
    //receive message
    Serial.println(" Receiving message Topic: ");
    Serial.println(mqttClient.messageTopic());
    Serial.print("The size  of the message is , ");
    Serial.println(messageSize);

    while(mqttClient.available())
    { 
      //char* humidity = (char)mqttClient.read();
      Serial.print((char)mqttClient.read()); 
      //for  (int i =0; i< messageSize; i++)
      //{
        //Serial.print((char)humidity[i]);
      //}
      //Serial.print(humidity);
       //the RGB Led is on ad long as the system is receiving humidity
      digitalWrite(Led_Green, HIGH);
      digitalWrite(Led_Red, HIGH);
      digitalWrite(Led_Blue, HIGH);
    }

    Serial.println();
  }
  
  void callback (char* Humidity, byte* size, unsigned int lengthMsg)
  { 
    String humidityMeasure = "";
    //Serial.println(Humidity);
    for(int i =0; i< lengthMsg; i++)
    {
      //Serial.print((char)size[i]);
      //size[lengthMsg] = '\0';
      humidityMeasure += ((char)size[i]);

    }

    float humidityM = humidityMeasure.toFloat();
    Serial.print (humidityM);
    Serial.println(" h.");
    
    if(humidityM > 60.0) // High humidity
    {
      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, HIGH);
      digitalWrite(Led_Blue, LOW);
    }
     else if (humidityM < 50.0) // Low humidity
    {
      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, LOW);
    }
    else if(humidityM >= 50.0  && humidityM <= 60.0) // normal Humidity
    {
      digitalWrite(Led_Green, HIGH);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, LOW);
    }


  }
  
