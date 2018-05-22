#if !defined(LOGICALDOOR_H)
#define LOGICALDOOR_H

#include <Arduino.h>
#include <Servo.h>



class LogicalDoor {
    private:
        byte pinSensorKey;  // pin used by sensor on the keylock
        byte pinSensorDoor; // pin used by the sensor on the door
        byte pinOpenLed;    // pin used by a led associated to open door movements
        byte pinCloseLed;   // pin used by a led associated to close door movements
        byte pinServo;      // pin to manage the servo
        Servo *myServo;     // the servo itself

        bool doorclosed;    // represents the current state of phisical door according to sensors
        bool lockclosed;    // represents the current state of phisical door according to sensors

    public:
        LogicalDoor(byte servoPin, byte openLedPin, byte closeLedPin, byte sensorDoorPin, byte sensorKeyPin);
        bool OpenDoor(void);
        bool CloseDoor(void);

        bool isDoorClosed(void); // true if the door sensor reports that the door is closed
        bool isLockClosed(void); // true if the lock sensor reports that is open

};





#endif
