#include <Arduino.h>
#include "Keypad.h"
#include "Locker.h"
#include "PushButton.h"
#include "LogicalDoor.h"

#define COLS 3              // cols of keypad outside the door
#define ROWS 3              // rows of keypad outside the door

// definition of PIN used by sensors/motorns/etc...
#define PINREDLED       13  // redled
#define PINGREENLED     12  // green led
#define PINYELLOWLED     3  // yellow led
#define PINOPENBUTTON    4  // open button
#define PINCLOSEBUTTON   5  // close button
#define PINSENSORKEY    14  // sensor of lock key, end of run sensor
#define PINSENSORDOOR   15  // sensor at door, senses open/close
#define PINSERVO         2  // pin used to control the servo

byte output[ROWS] = { 9, 10, 11 };    // ROWS    - OUTPUT
byte input[COLS]  = { 6,  7,  8 };    // COLUMNS - INPUT_PULLUP

char keyMap[ROWS][COLS] = { { '1', '2', '3' } ,
                            { '4', '5', '6' } ,
                            { '7', '8', '9' } };


//objects used in this scketch
Keypad      *kp      = NULL;
Locker      *lk      = NULL;
PushButton  *btOpen  = NULL;
PushButton  *btClose = NULL;
LogicalDoor *theDoor = NULL;

void setup() {
  Serial.begin(9600);
  Serial.println("Begin setup...");

  // initialization
  kp      = new Keypad((char *)keyMap,output,input,ROWS,COLS,PINGREENLED,Keypad::NOPIN);
  lk      = new Locker(kp,PINREDLED,PINGREENLED);
  btClose = new PushButton(PINCLOSEBUTTON,PINGREENLED);
  btOpen  = new PushButton(PINOPENBUTTON,PINGREENLED);
  theDoor = new LogicalDoor(PINSERVO,PINGREENLED,PINREDLED,PINSENSORDOOR,PINSENSORKEY);
  // end initialization

  Serial.println("End setup, starting...");
}


void loop() {

    switch(lk->Loop()) {
        // all possible returns are listed just for matter of documentation
        case Locker::NOTHING:
            break;

        case Locker::CODECHANGED:
            Serial.println("Code changed");
            break;

        case Locker::WRONGCODE:
            Serial.println("Wrong code inserted");
            break;

        case Locker::SUCCESS:
            Serial.println("Correct code inserted");
            theDoor->OpenDoor();
            break;
    }


  if(btClose->Loop()) {
    Serial.println("Close button pressed");
    theDoor->CloseDoor();
  }


  if(btOpen->Loop()) {
    Serial.println("Open button pressed");
    theDoor->OpenDoor();
  }

    delay(15);
}

