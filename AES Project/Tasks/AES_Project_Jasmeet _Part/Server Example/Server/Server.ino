#include <SPI.h>
#include <WiFiNINA.h>
#include <utility/wifi_drv.h>
#include <ArduinoMqttClient.h>
#include "SECRET.h"


char ssid[] = "SECRET_SSID";        // your network SSID (name)
char pass[] = "SECRET_PASS";    // your network password (use for WPA, or use as key for WEP)
int keyIndex = 0;                // your network key Index number (needed only for WEP)

int status = WL_IDLE_STATUS;
WiFiServer server(80);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println(status);
  Serial.println("Access Point Web Server");
  WiFiDrv::pinMode(25, OUTPUT);
  WiFiDrv::pinMode(26, OUTPUT);
  WiFiDrv::pinMode(27, OUTPUT);

  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    // don't continue
    while (true);
  }
  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) {
    Serial.println("Please upgrade the firmware");
  }
  WiFi.config(IPAddress(10, 0, 0, 1));
  Serial.print("Creating access point named: ");
  Serial.println(ssid);
  status = WiFi.beginAP(ssid, pass);
  Serial.println(status);
  if (status != WL_AP_LISTENING) {
    Serial.println("Creating access point failed");
    Serial.println(status);
    while (true);
  }
  // start the web server on port 80
  Serial.println("Before Server begin");
  server.begin();
  Serial.println("After Server begin");
  // you're connected now, so print out the status
  printWiFiStatus();
}

void loop() {
  // put your main code here, to run repeatedly:
  if (status != WiFi.status()) {
    // it has changed update the variable
    status = WiFi.status();
    if (status == WL_AP_CONNECTED) {
      // a device has connected to the AP
      Serial.println("Device connected to AP");
    } else {
      // a device has disconnected from the AP, and we are back in listening mode
      Serial.println("Device disconnected from AP");
    }
  }
  WiFiClient client = server.available();   // listen for incoming clients
  if (client) {                             // if you get a client,
    Serial.println("new client");           // print a message out the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    while (client.connected()) {            // loop while the client's connected
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();             // read a byte, then
        Serial.write(c);                    // print it out the serial monitor
        if (c == '\n') {                    // if the byte is a newline character
          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();
            // the content of the HTTP response follows the header:
            client.print("Click <a href=\"/RH\">here</a> turn the Red LED on<br>");
            client.print("Click <a href=\"/RL\">here</a> turn the Red LED off<br>");
            client.print("Click <a href=\"/GH\">here</a> turn the Green LED on<br>");
            client.print("Click <a href=\"/GL\">here</a> turn the Green LED off<br>");
            client.print("Click <a href=\"/BH\">here</a> turn the Blue LED on<br>");
            client.print("Click <a href=\"/BL\">here</a> turn the Blue LED off<br>");
            // The HTTP response ends with another blank line:
            client.println();
            // break out of the while loop:
            break;
          }
          else {      // if you got a newline, then clear currentLine:
            currentLine = "";
          }
        }
        else if (c != '\r') {    // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
        // Check to see if the client request was "GET /H" or "GET /L":
        if (currentLine.endsWith("GET /RH")) {
          WiFiDrv::analogWrite(26, 255);               // GET /H turns the LED on
        }
        if (currentLine.endsWith("GET /RL")) {
          WiFiDrv::analogWrite(26, 0);                // GET /L turns the LED off
        }
        if (currentLine.endsWith("GET /GH")) {
          WiFiDrv::analogWrite(25, 255);               // GET /H turns the LED on
        }
        if (currentLine.endsWith("GET /GL")) {
          WiFiDrv::analogWrite(25, 0);                // GET /L turns the LED off
        }
        if (currentLine.endsWith("GET /BH")) {
          WiFiDrv::analogWrite(27, 255);               // GET /H turns the LED on
        }
        if (currentLine.endsWith("GET /BL")) {
          WiFiDrv::analogWrite(27, 0);                // GET /L turns the LED off
        }
      }
    }
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
  }
}

void printWiFiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());
  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
  // print where to go in a browser:
  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}
