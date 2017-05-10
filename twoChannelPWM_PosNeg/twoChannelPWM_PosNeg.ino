/*
   See how they run
   Three blind mice
   simple pwm output from a host shield 
   also position values etc over serial if that's your bag

   This file defaults to a mega config with output pins:
   4 and 13, but if you use an uno change to 5 and 6.

   If you are using serial:
   I also added a reset pin at 7, which will reset
   time and current position to 0. This is an easy way to mark
   trials etc. You can have your PFI0 from a nidaq board, or some 
   output from pClamp reset when you start a run. 
   Again, this only matters for serial streaming of those variables.
   
   Nerdy Timer Info (for PWM):
   for one axis you should stick to pins:
   5 and 6 for an uno
   13 and 4 for mega 2560
   These are the faster timer 0 for each board
   By default timer 0 gives:
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
const int resetPin = 7;

int resetState;

signed long tt;
signed long tB;

long curPos=0;
long deltaX = 0;
long tempDe = 0;
long archPos=0;
int output_posXValue;
int output_negXValue;



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
  // Serial.println("Start");
  delay(500);
  HidMouse.SetReportParser(0, (HIDReportParser*)&Prs);
  tB=millis();
}

void loop() {
  Usb.Task();
  resetState=digitalRead(resetPin);
  
  if(resetState){
    tB=micros();
    curPos=0;
  };
  
  tt=(micros()-tB)*0.0001;
  if(deltaX>0){
    output_posXValue = map(deltaX, 1, 127, 0, 255);
    output_negXValue = 0;
    analogWrite(posX_aOut,output_posXValue);
    analogWrite(negX_aOut,output_negXValue);
    //curPos=curPos;
  }
  else if(deltaX<0){
    output_negXValue = map(deltaX, -1, -127, 0, 255);
    output_posXValue = 0;
    analogWrite(posX_aOut,output_posXValue);
    analogWrite(negX_aOut,output_negXValue);
    //curPos=curPos;
  }
  else if(deltaX==0){
    output_negXValue = 0;
    output_posXValue = 0;
    analogWrite(posX_aOut,output_posXValue);
    analogWrite(negX_aOut,output_negXValue);
    //curPos=curPos;
  };

  curPos=curPos+deltaX;
  Serial.print("posData");
  Serial.print(',');
  Serial.print(tt);
  Serial.print(',');
  Serial.print(deltaX);
  Serial.print(',');
  Serial.print(curPos);
  Serial.print(',');
  Serial.print(output_posXValue);
  Serial.print(',');
  Serial.println(output_negXValue);
  
  delayMicroseconds(50);
  deltaX = 0;


}







