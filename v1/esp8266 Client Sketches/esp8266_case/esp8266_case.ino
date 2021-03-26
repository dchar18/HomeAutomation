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
#define ROWS 8

CRGB leds[ROWS][4*COLS];

// the following are used for testing purposes:
uint8_t red;
uint8_t green;
uint8_t blue;
uint8_t test_row = 0;
uint8_t test_col = 0;
CRGB test_color;
int incoming;
int phase = 0;

uint8_t BRIGHTNESS = 60;
#define VOLTS 5
#define MAX_MA 3000
const int ROW7_PIN = D8; // bottom row
const int ROW6_PIN = D1;
const int ROW5_PIN = D2;
const int ROW4_PIN = D3;
const int ROW3_PIN = D4;
const int ROW2_PIN = D5;
const int ROW1_PIN = D6;
const int ROW0_PIN = D7; // top row

// LED mode variables ----------
int prev_fade = 0; // stores the last time the color fade changed
int curr_fade = 0;
int _delay = 10;
int UPDATES_PER_SECOND = 400;

CRGBPalette16 currentPalette;
TBlendType    currentBlending;
String led_mode = "off";
String prev_mode = "off";

// used for the "twinkle" modes ---------------------
// Overall twinkle speed.
// 0 (VERY slow) to 8 (VERY fast).  
// 4, 5, and 6 are recommended, default is 4.
#define TWINKLE_SPEED 4

// Overall twinkle density.
// 0 (NONE lit) to 8 (ALL lit at once).  
// Default is 5.
#define TWINKLE_DENSITY 6

// Background color for 'unlit' pixels
CRGB gBackgroundColor = CRGB::Black; 

// If AUTO_SELECT_BACKGROUND_COLOR is set to 1,
// then for any palette where the first two entries 
// are the same, a dimmed version of that color will
// automatically be used as the background color.
#define AUTO_SELECT_BACKGROUND_COLOR 0

// If COOL_LIKE_INCANDESCENT is set to 1, colors will 
// fade out slighted 'reddened', similar to how
// incandescent bulbs change color as they get dim down.
#define COOL_LIKE_INCANDESCENT 1

CRGBPalette16 targetPalette;

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
const char* mode_individual = "esp8266_case/cell/+/+/#"; // esp8266_case/cell/row/column/mode
                                                         // or esp8266_case/cell/row/column/rgb/red/green/blue
const char* mode_rgb = "esp8266_case/rgb";
const char* mode_party = "esp8266_case/party";
const char* mode_twinkle_blue = "esp8266_case/twinkle_blue";
const char* mode_brightness = "esp8266_case/brightness";
const char* mode_color_fade = "esp8266_case/color_fade";

// Initializes the espClient
WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
  Serial.println("Beginning...");
  
  FastLED.setMaxPowerInVoltsAndMilliamps(VOLTS, MAX_MA);
  FastLED.addLeds<WS2812, ROW7_PIN, GRB>(leds[7], 4*COLS);
  FastLED.addLeds<WS2812, ROW6_PIN, GRB>(leds[6], 4*COLS);
  FastLED.addLeds<WS2812, ROW5_PIN, GRB>(leds[5], 4*COLS);
  FastLED.addLeds<WS2812, ROW4_PIN, GRB>(leds[4], 4*COLS);
  FastLED.addLeds<WS2812, ROW3_PIN, GRB>(leds[3], 4*COLS);
  FastLED.addLeds<WS2812, ROW2_PIN, GRB>(leds[2], 4*COLS);
  FastLED.addLeds<WS2812, ROW1_PIN, GRB>(leds[1], 4*COLS);
  FastLED.addLeds<WS2812, ROW0_PIN, GRB>(leds[0], 4*COLS);
  FastLED.setBrightness(BRIGHTNESS);
  
  // create a Cell object for each cell
  for(int i = 0; i < ROWS; i++){
    for(int j = 0; j < COLS; j++){
      cells[i][j] = {255, 0, 0, "rgb"};
    }
  }
  initCells();
  
}

// connect ESP8266 to router
void setup_wifi() {
  delay(10);

  Serial.print("Board's local IP address: ");
  Serial.println(WiFi.localIP());
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("WiFi connected - ESP IP address: ");
  Serial.println(WiFi.localIP());
}

// TODO
// This functions is executed when some device publishes a message to a topic that your ESP8266 is subscribed to
// Change the function below to add logic to your program, so when a device publishes a message to a topic that 
// your ESP8266 is subscribed you can actually do something
void callback(String topic, byte* message, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");
  String messageTemp;

  /*  Possible combinations:
   *    - esp8266_case/cell/row/column/mode
   *      - topic: 
   *      - message: 
   *    - esp8266_case/cell/row/column/rgb/red/green/blue
   *      - topic: 
   *      - message: 
   *    - esp8266_case/mode
   *      - topic: esp8266_case/<mode>
   *      - message: "esp8266_case"
   *    - sync/mode
   *      - topic: <mode>
   *      - message: "all"
   *    - esp8266_case/brightness/<brightness>
   *      - topic: "all/brightness" or "esp8266_case/brightness"
   *      - message: <brightness>
   *    - sync/rgb/<red>/<green>/<blue>
   *      - topic: "all/rgb"
   *      - message: "<red>/<green>/<blue>"
   *    - esp8266_case/rgb/<red>/<green>/<blue>
   *      - topic: "esp8266_case/rgb"
   *      - message: "<red>/<green>/<blue>"
   */
  
  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
    messageTemp += (char)message[i];
  }
  Serial.println();

  // if all devices are supposed to respond to the change
//  if(messageTemp == "all"){
//    if(topic == "off"){
//      Serial.println("All changing to \'off\'");
//      led_mode = "off";
//    }
//    else if(topic == "color_fade"){
//      Serial.println("All changing to \'color_fade\'");
//      led_mode = "color_fade";
//      red = 0;
//      green = 0;
//      blue = 255;
////      STATE = 0;
//    }
//    else if(topic == "twinkle_christmas"){
//      Serial.println("All changing to \'twinkle_christmas\'");
//      led_mode = "twinkle_christmas";
//    }
//    else if(topic == "twinkle_blue"){
//      Serial.println("All changing to \'twinkle_blue\'");
//      led_mode = "twinkle_blue";
//    }
//    else if(topic == "twinkle_green"){
//      Serial.println("All changing to \'twinkle_green\'");
//      led_mode = "twinkle_green";
//    }
//    else if(topic == "snow"){
//      Serial.println("All changing to \'snow\'");
//      led_mode = "snow";
//    }
//  }
//  // only the device with matching ID should respond
//  else if(messageTemp.equals(ID)){
//    if(topic == mode_off){
//      Serial.println(ID + " changing to \'off\'");
//      led_mode = "off";
//    }
//    else if(topic == mode_color_fade){
//      Serial.println(ID + " changing to \'color_fade\'");
//      led_mode = "color_fade";
//      red = 0;
//      green = 0;
//      blue = 255;
////      STATE = 0;
//    }
//    else if(topic == mode_twinkle_christmas){
//      Serial.println(ID + " changing to \'twinkle_christmas\'");
//      led_mode = "twinkle_christmas";
//    }
//    else if(topic == mode_twinkle_blue){
//      Serial.println(ID + " changing to \'twinkle_blue\'");
//      led_mode = "twinkle_blue";
//    }
//    else if(topic == mode_twinkle_green){
//      Serial.println(ID + " changing to \'twinkle_green\'");
//      led_mode = "twinkle_green";
//    }
//    else if(topic == mode_snow){
//      Serial.println(ID + " changing to \'snow\'");
//      led_mode = "snow";
//    }
//  }
//  // responding to topic: all/brightness, message: <brightness>
//  else if(topic == "all/brightness" || topic == mode_brightness){
//    BRIGHTNESS = messageTemp.toInt();
//    FastLED.setBrightness(BRIGHTNESS);
//    Serial.print("Brightness: ");
//    Serial.println(BRIGHTNESS);
//  }
//  // responding to topic: all/rgb, message: <red>/<green>/<blue>
//  else{
//    String temp = messageTemp;
//    // parse out the red, green, blue values from the message
//    red = temp.substring(0,temp.indexOf("/")).toInt();
//    temp = temp.substring(temp.indexOf("/")+1);
//
//    green = temp.substring(0,temp.indexOf("/")).toInt();
//    temp = temp.substring(temp.indexOf("/")+1);
//
//    blue = temp.toInt();
//    
//    led_mode = "rgb";
//  }
}

void loop() {
  red = random(0,256);
  green = random(0,256);
  blue = random(0,256);
  setCell(test_row, test_col, red, green, blue);
  test_col++;
  if(test_col > COLS){
    test_col = 0;
    test_row++;
  }
  if(test_row > ROWS){
    test_row = 0;
  }
  delay(50);
}

// set each cell to show the color stored in colors[][]
void initCells(){
  Serial.println("In initCells()");
  int r, c;
  byte cell_column;
  
  for(r = 0; r < ROWS; r++){
    // turn on cells in each row
    cell_column = 0;
    for(c = 0; c < 4*COLS; c++) {
        if(c > 0){
          if(c % 4 == 0){
            cell_column++;
          }
        }
//        Serial.print("Setting: row: ");
//        Serial.print(r);
//        Serial.print(", column: ");
//        Serial.print(c);
//        Serial.print(" using chunk ");
//        Serial.println(cell_column);
        leds[r][c] = CRGB(cells[r][cell_column].red, cells[r][cell_column].green, cells[r][cell_column].blue);
    }
    FastLED.show();
  }
}

void setCell(uint8_t row, uint8_t col, byte red, byte green, byte blue){
  /*            Columns (as referenced by user)     (output pins controling the row)
   *         1     2      3      4      5      6      7      8      9      10    |
   *     ----------------------------------------------------------------------  V
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

  CRGB color = (red, green, blue);
  int grid_column = 4*(COLS-col);
  // set the 4 leds in the cell to the specified color
  for(int i = 0; i < 4; i++){
    leds[row-1][grid_column] = color;
    grid_column++;
  }

  cells[row][grid_column].red = red;
  cells[row][grid_column].green = green;
  cells[row][grid_column].blue = blue;
//  Serial.print(row);
//  Serial.print(" ");
//  Serial.print(col);
//  Serial.print(" ");
//  Serial.print(red);
//  Serial.print(" ");
//  Serial.print(green);
//  Serial.print(" ");
//  Serial.println(blue);
  FastLED.show();
}
