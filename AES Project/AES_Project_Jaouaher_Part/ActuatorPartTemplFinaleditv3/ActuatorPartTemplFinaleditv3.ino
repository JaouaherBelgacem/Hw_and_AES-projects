#include <ArduinoMqttClient.h>
#include "WifiData.h"
#include "WiFiNINA.h"


//wifi
char ssid[]= SECRET_SSID; 
char pass[]= SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);
//PubSubClient client;

const char broker[] = "192.168.137.226";
int port = 1883;
const char aesProjTopic[] = "Humidity";


// initialize actuator

int Led_Red = 13;
int Led_Green = 12;
int Led_Blue = 8;

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
  /*if(H_value > 60)
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
    }*/

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
      digitalWrite(Led_Green, HIGH);
      digitalWrite(Led_Red, HIGH);
      digitalWrite(Led_Blue, HIGH);
    }

    Serial.println();
  }
  
  void callback ( char* Humidity, byte* size, unsigned int lengthMsg)
  {
    Serial.println(Humidity);
    for(int i =0; i< lengthMsg; i++)
    {
      Serial.print((char)size[i]);
      size[lengthMsg] = '\0';
      float H_value = atoi((char *)size);
    //}
    
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
    }

      digitalWrite(Led_Green, LOW);
      digitalWrite(Led_Red, LOW);
      digitalWrite(Led_Blue, LOW);
    
  }
  
