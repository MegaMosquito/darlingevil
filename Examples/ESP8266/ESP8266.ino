//
// A darlingevil.com example program for the ESP8266MOD 12-E
//
// Illustrates using the BMP180 I2C sensor, and Deep Sleep (6.5uA) mode.
//
// Written by the Mosquito, an Insignificant Annoyance, April 2018.
//
// Copyright (c)2018 DarlingEvil.com.
// This work is licensed under the
//     Creative Commons Attribution 4.0 International License.
// To view a copy of this license, visit
//     http://creativecommons.org/licenses/by/4.0/
// or send a letter to:
//     Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
// All other rights reserved.
//

#include <ESP8266WiFi.h>  // Support for the ESP8266 built-in Wifi stack
#include <PubSubClient.h> // MQTT client
#include <Wire.h>         // Support for I2C bus (for the BMP180 sensor)
#include <SFE_BMP180.h>   // SparkFun BMP180 library, for data stream decoding

// Configure these for your WiFi, Watson IoT org, and BMP wiring to the ESP8266
const char*    wifi_ssid  = "MY_WIFI_SSID_WAS_HERE";
const char*    wifi_pass  = "MY_WIFI_PASSWORD_WAS_HERE";
const char*    mqtt_host  = "nzjnxq.messaging.internetofthings.ibmcloud.com";
const uint16_t mqtt_port  = 1883;
const char*    mqtt_id    = "g:nzjnxq:BBG_Type:BackyardBarometrics001";
const char*    mqtt_topic = "iot-2/type/BBG_Type/id/BackyardBarometrics001/evt/status/fmt/json";
const char*    mqtt_token = "MY_TOKEN_WAS_HERE";
const uint16_t mqtt_tries = 3;     // Max tries to MQTT connect per sleep cycle
const uint16_t mqtt_pubs  = 3;     // Number of times to publish (to overcome QoS 0)
const uint16_t mqtt_pause = 5000;  // Pause between tries, in milliseconds
const uint8_t  bmp_sda    = 5;    // i.e., GPIO5, D1 on NodeMCU
const uint8_t  bmp_scl    = 13;    // i.e., GPIO13, D7 on NodeMCU
const uint8_t  bmp_addr   = 119;   // its addr on the I2C bus. not actually used

// How long to deep sleep between messages, in microseconds (uSec)
#define DEEP_SLEEP_USEC 60e6 // i.e., 60,000,000 uSec == 60 seconds

// Set to 0 to turn off all debug output (to the Arduino serial monitor)
#define DEBUG 1

// An easy-to-turn-off vararg function for output (set DEBUG to 0 to turn off)
char g_debug_buffer[1024];
void debug (const char *format, ...) {
  va_list ap;
  va_start(ap, format);
  vsnprintf(g_debug_buffer, sizeof(g_debug_buffer), format, ap);
  for (char *p = &g_debug_buffer[0]; *p; p++) {
#if DEBUG
    if (*p == '\n')
      Serial.println();
    else
      Serial.print(*p);
#endif
  }
  va_end(ap);
}

// Globals for the WiFi connection and the pub/sub client
WiFiClient espClient;
PubSubClient client(espClient);

// MQTT callback function (needed only if you subscribe, which I do below)
void mqtt_callback(char* topic, byte* payload, unsigned int length) {
  debug("MQTT message recevived!\n");
  debug("  topic:   \"%s\"\n", topic);
  debug("  message: \"");
  for (int i = 0; i < length; i++) {
    debug("%c", (char)payload[i]);
  }
  debug("\"\n");
}

// Global to hold the I2C instance for the BMP180 sensor
SFE_BMP180 g_bmp180;

// After Wire.begin(...) you can use this to find your device's address
void show_i2c () {
  byte e;
  for (int i = 0; i <128; i +=1) {
    Wire.beginTransmission(i);
    e = Wire.endTransmission();
    if (e ==0)
      debug("I2C addr %d is active.\n", i);
  }
}

void setup() {

#if DEBUG
  // Serial.begin(74880); // For bare module
  Serial.begin(115200); // For NodeMCU
  while(!Serial) {}
#endif

  debug("\n\n\nStarting up...\n");

  // Set up for I2C using these two pins
  Wire.begin(bmp_sda, bmp_scl);

  // Initialize the BMP180, or go back to sleep.
  if (g_bmp180.begin()) {
    debug("BMP180 is ready!\n");
  }
  else
  {
    debug("Cannot init BMP180. Going back into deep sleep...\n");
    ESP.deepSleep(DEEP_SLEEP_USEC);
  }

  // Construct the JSON record that will be sent with pressure and temperature
  char message[1024];
  double temperature = 0.0;
  double pressure = 0.0;
  int status = bmp_get_status(&temperature, &pressure);
  if (status == 0) {
    sprintf(message, "{\"temperature_c\":%f,\"pressure_mbar\":%f}", temperature, pressure);
    // sprintf(message, "{\"temperature\":%f}", temperature);
  }
  else
  {
    debug("Cannot set data from the BMP180. Going back into deep sleep...\n");
    ESP.deepSleep(DEEP_SLEEP_USEC);
  }

  // Connect to the WiFi access point
  debug("Associating with SSID: \"%s\"...\n", wifi_ssid);
  WiFi.begin(wifi_ssid, wifi_pass);
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    debug(".");
  }
  debug("\n");
  debug("WiFi is associated! Local address is: %s.\n", WiFi.localIP().toString().c_str());
  client.setServer(mqtt_host, mqtt_port);
  // Setting up a callback is not strictly required, so you could remove this:
  client.setCallback(mqtt_callback);

  // Connect to Watson IoT Platform MQTT
  debug("Attempting to connect to the MQTT broker...\n");
  debug("  host:  \"%s\"\n", mqtt_host);
  debug("  port:  %d\n", (int)mqtt_port);
  debug("  id:    \"%s\"\n", mqtt_id);
  // Try a limited number of times to connect, then give up and sleep cycle
  for (int i = 0; i < mqtt_tries && !client.connected(); i += 1) {
    debug("Attempting to connect MQTT client (try #%d)...\n", i);
    if (client.connect(mqtt_id, "use-token-auth", mqtt_token)) {
      debug("MQTT client has connected!\n");
      client.loop();
      debug("  client.loop() has returned.\n");
    } else {
      debug("MQTT client failed to connect.\n");
      delay(mqtt_pause);
    }
  }
  client.loop();
  
  // Connected now? If so then publish the current status event message...
  if (client.connected()) {
    debug("Publishing status event (QoS=0, best effort, will send %d times)...\n", mqtt_pubs);
    debug("  topic = \"%s\"\n", mqtt_topic);
    debug("  message = \"%s\"\n", message);
    for (int j = 0; j < mqtt_pubs && client.connected(); j += 1) {
      debug("  (pub #%d)...\n", j);
      client.publish(mqtt_topic, message);
      delay(100);
    }
  }
  else
  {
    debug("Cannot connect to MQTT broker after %d tries.\n", mqtt_tries);
    debug("  Error code: %s\n", String(client.state()).c_str());
    debug("Going back into deep sleep...\n");
    ESP.deepSleep(DEEP_SLEEP_USEC);
  }

  // deepSleep() stops the program, on reset it will restart setup()
  debug("Going back into deep sleep...\n");
  ESP.deepSleep(DEEP_SLEEP_USEC);

  // NOT REACHED!
}

// loop() never runs.  deepSleep() shuts down the ESP at end of setup, then
// when the ESP is awoken by reset, it starts over at the top of setup()
void loop() {
  // NOT REACHED!
}

// Modified from the example code provided with the SparkFun BMP library
int bmp_get_status(double* pT, double* pP) {
  char status;
  // You must get a temperature measurement first before any pressure reading.
  // Start a temperature measurement:
  // If request is successful, the number of ms to wait is returned.
  // If request is unsuccessful, 0 is returned.
  status = g_bmp180.startTemperature();
  if (status != 0)
  {
    // Wait for the measurement to complete:
    delay(status);
    // Retrieve the completed temperature measurement:
    // Function returns 1 if successful, 0 if failure.
    status = g_bmp180.getTemperature(*pT);
    if (status != 0)
    {
      // Start a pressure measurement:
      // The parameter is the oversampling setting, from 0 to 3
      //   (3 is highest res, but longest wait).
      // If request is successful, the number of ms to wait is returned.
      // If request is unsuccessful, 0 is returned.
      status = g_bmp180.startPressure(3);
      if (status != 0)
      {
        // Wait for the measurement to complete:
        delay(status);
        // Retrieve the completed pressure measurement:
        // Note that the function requires the previous temperature measurement (*pT).
        // Function returns 1 if successful, 0 if failure.
        status = g_bmp180.getPressure(*pP, *pT);
        if (status != 0)
        {
          return(0);
        }
      }
    }
  }
  return(1);
}

