#include <Arduino.h>
#include <Servo.h>
#include "LogicalDoor.h"

#define SERVOOPENMOV    180
#define SERVOCLOSEMOV     0
#define SERVOSTOPMOV     90

#define FLASHINTERVAL   500 // during open/close the visual feedback flash leds, this is the interval
#define MAXSERVOTIME  10000 // the servo can't run more than this, if this time is reached an error occurs

LogicalDoor::LogicalDoor(byte servoPin, byte openLedPin, byte closeLedPin, byte sensorDoorPin, byte sensorKeyPin) {
    // copy input values in internal parameters
    pinServo      = servoPin;
    pinOpenLed    = openLedPin;
    pinCloseLed   = closeLedPin;
    pinSensorDoor = sensorDoorPin;
    pinSensorKey  = sensorKeyPin;

    // initialize internal variables
    myServo = new Servo();

    // initialize pins, if not already initialized
    pinMode(pinOpenLed,OUTPUT);
    pinMode(pinCloseLed,OUTPUT);
    pinMode(pinSensorDoor,INPUT_PULLUP);
    pinMode(pinSensorKey,INPUT_PULLUP);
}

bool LogicalDoor::OpenDoor(void){
    // first check consistency between the command requested and the
    // in order to open the door
    // *** the door must be closed
    // *** the lock must be close

    if(isDoorClosed() && isLockClosed()) {
        // attach the servo and send open command until the isLockClosed fires false
        // in the meanwhile enable visual feedback
        unsigned long tmp   = millis();
        unsigned long guard = millis();
        bool onoff          = true;

        myServo->attach(pinServo);

        while(isLockClosed()) {
            digitalWrite(pinOpenLed,onoff ? HIGH : LOW);
            myServo->write(SERVOOPENMOV);
            if(tmp+FLASHINTERVAL<millis()) {
                onoff = !onoff;
                tmp = millis();
            }

            // security check
            if(guard+MAXSERVOTIME<millis()) {
                // the servo ran too much time, better to stop it
                digitalWrite(pinOpenLed,LOW);
                myServo->write(SERVOSTOPMOV);
                myServo->detach();
                return false;
            }
        }

        // ok now the lock is open, can free resources and return
        digitalWrite(pinOpenLed,LOW);
        myServo->write(SERVOSTOPMOV);
        myServo->detach();
        return true;
    }

    // if the execution flow enters in this segment
    // it means that the command is not executed
    return false;
}


bool LogicalDoor::CloseDoor(void){
}


bool LogicalDoor::isDoorClosed(void) {
    // check door sensor and return the result
    // if  sensor fires it means that the door is closed
    // remember that PULULP pins return values are the opposite of normal INOUT pins
    return (digitalRead(pinSensorDoor) == LOW) ? true : false;
}


bool LogicalDoor::isLockClosed(void) {
    // check lock key sensor and return the result
    // if sensor fires it means that the lock key is open
    // remember that PULULP pins return values are the opposite of normal INOUT pins
    return (digitalRead(pinSensorKey) == LOW) ? false : true;
}
