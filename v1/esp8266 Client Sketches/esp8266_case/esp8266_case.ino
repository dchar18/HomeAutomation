/*  Things to check:
 *    - can I set an individual row from leds[][] to a specific output pin?
 *    - can I respond to an individual cell getting a specific color?
 *    - can I switch between individual and sync modes?
 *    - what is the delay in response?
 *    - how long does it take to fill the cells on init?
 */


// SETUP VARIABLES --------------------------------------------------------------------------------
// Loading the ESP8266WiFi library and the PubSubClient library
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// case variables ----------------------------------------------------------
const String ID = "esp8266_case";
const char* device_ID = "esp8266_case";

// led strip variables ----------
#define FASTLED_ESP8266_RAW_PIN_ORDER
#include <FastLED.h>
#define COLS 10
#define ROWS 7

CRGB leds[ROWS][4*COLS];

uint8_t BRIGHTNESS = 64;
#define VOLTS 5
#define MAX_MA 3000
const int ROW1_PIN = D0;
const int ROW2_PIN = D1;
const int ROW3_PIN = D2;
const int ROW4_PIN = D3;
const int ROW5_PIN = D4;
const int ROW6_PIN = D5;
const int ROW7_PIN = D6;

int _delay = 10;
int UPDATES_PER_SECOND = 400;

// cell variables ---------------
struct Cell {
  uint8_t red;
  uint8_t green;
  uint8_t blue;
  String cell_mode;
};

Cell cells[ROWS][COLS];

// connection variables ---------
// Change the credentials below, so your ESP8266 connects to your router
const char* ssid = "egon24";
const char* password = "4432egon";

// Change the variable to your Raspberry Pi IP address, so it connects to your MQTT broker
const char* mqtt_server = "192.168.50.115";


// done explicitly to avoid char/char*/String conversions and concatenations
const char* mode_off = "esp8266_case/off";
const char* mode_individual = "esp8266_case/+/+/#"; // esp8266_case/row/column/mode
const char* mode_rgb = "esp8266_case/rgb";
const char* mode_party = "esp8266_case/party";
const char* mode_twinkle_blue = "esp8266_case/twinkle_blue";
const char* mode_brightness = "esp8266_case/brightness";
const char* mode_color_fade = "esp8266_case/color_fade";

void setup() {
  // put your setup code here, to run once:

  for(int i = 0; i < ROWS; i++){
    for(int j = 0; j < COLS; j++){
      cells[i][j] = {0, 0, 255, "rgb"};
    }
  }
  initCells();

}

void loop() {
  // put your main code here, to run repeatedly:

}

// set each cell to show the color stored in colors[][]
void initCells(){
  int i;
  byte counter = 0;

  while(counter < ROWS){
    // turn on cells in each row
    for(i = 0; i < COLS; i++) {
        leds[counter][i] = CRGB(cells[counter][i].red, cells[counter][i].green, cells[counter][i].blue);
    }
    FastLED.show();
    counter++;
  }
}

void setCell(uint8_t row, uint8_t col, CRGB color){
  /*         1     2      3      4      5      6      7      8      9      10
   *     ----------------------------------------------------------------------
   *  1  |      |      |      |      |      |      |      |      |      |     | D0
   *     ----------------------------------------------------------------------
   *  2  |      |      |      |      |      |      |      |      |      |     | D1
   *     ----------------------------------------------------------------------
   *  3  |      |      |      |      |      |      |      |      |      |     | D2
   *     ----------------------------------------------------------------------
   *  4  |      |      |      |      |      |      |      |      |      |     | D3
   *     ----------------------------------------------------------------------
   *  5  |      |      |      |      |      |      |      |      |      |     | D4
   *     ----------------------------------------------------------------------
   *  6  |      |      |      |      |      |      |      |      |      |     | D5
   *     ----------------------------------------------------------------------
   *  7  |      |      |      |      |      |      |      |      |      |     | D6
   *     ----------------------------------------------------------------------
   *      36-39 |32-35 |28-31 |24-27 |20-23 |16-19 |12-15 | 8-11 |  4-7 | 0-3
   */
  
  // set the 4 leds in the cell to the specified color
  for(int i = 0; i < 4; i++){
    int column = 4*(COLS-col) + i;
    leds[row-1][column] = color;
  }
  
  FastLED.show();
}
