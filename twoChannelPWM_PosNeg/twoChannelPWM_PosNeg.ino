/*
   See how they run
   Three blind mice
   simple pwm output from a host shield over serial
   for one axis you should stick to pins 5 and 6 for an uno
    13 and 4 are timer 0 for mega 2560
   they are controlled by timer 0 and by default give:
   fPWM=976.563 Hz; with cycle length of 256; 70.7% duty (3.53V)

   questions --> cdeister@brown.edu
*/



#include <hidboot.h>
#include <usbhub.h>

// Satisfy the IDE, which needs to see the include statment in the ino too.
#ifdef dobogusinclude
#include <spi4teensy3.h>
#include <SPI.h>
#endif


const int posX_aOut = 4;
const int negX_aOut = 13;


int deltaX = 0;
//long posX=0;


// ********** mouse class
class MouseRptParser : public MouseReportParser
{
  protected:
    void OnMouseMove  (MOUSEINFO *mi);
};

void MouseRptParser::OnMouseMove(MOUSEINFO *mi) {
  deltaX = (mi->dX);
  //posX=posX+deltaX;
  //you can accumulate position and map to a ring and reset etc.
};

USB Usb;
USBHub Hub(&Usb);
HIDBoot<USB_HID_PROTOCOL_MOUSE>    HidMouse(&Usb);
MouseRptParser  Prs;


void setup() {
  pinMode(posX_aOut, OUTPUT);
  pinMode(negX_aOut, OUTPUT);

  Serial.begin(19200); // initialize Serial communication
  while (!Serial);    // wait for the serial port to open
  if (Usb.Init() == -1)
    Serial.println("OSC did not start.");
  Serial.println("Start");
  delay(500);
  HidMouse.SetReportParser(0, (HIDReportParser*)&Prs);
}

void loop() {
  Usb.Task();
    if(deltaX>=0){
      int output_posXValue = map(deltaX, 0, 127, 0, 255);
      int output_negXValue = 0;
      analogWrite(posX_aOut,output_posXValue);
      analogWrite(negX_aOut,output_negXValue);
    }
    else if(deltaX<0){
      int output_negXValue = map(deltaX, -1, -128, 0, 255);
      int output_posXValue = 0;
      analogWrite(posX_aOut,output_posXValue);
      analogWrite(negX_aOut,output_negXValue);
    };
  
  Serial.println(deltaX + 128);

  delayMicroseconds(500);
  deltaX = 0;


}







