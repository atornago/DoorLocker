#include <Arduino.h>
#include "PushButton.h"


PushButton::PushButton(byte pinButton, byte pinFeedback) {
    pinButt = pinButton;
    pinFbck = pinFeedback;
    keydown = false;

    pinMode(pinButt,INPUT_PULLUP);
    if(pinFbck!=PushButton::NOPIN) pinMode(pinFbck,OUTPUT);
}


bool PushButton::Loop() {
    if(keydown) {
        if(digitalRead(pinButt)==HIGH) {
            // the key was pressed and now has been released
            // generate the keypress event
            keydown = false;
            if(pinFbck!=PushButton::NOPIN) digitalWrite(pinFbck,LOW);
            return true;
        }

        // if the execution flows reach this point it means that the
        // key is still down, return nothing
        return false;
    }

    // if execution flow reach this point, no keydown in progress, we need
    // to check if the button is pressed or not

    if(digitalRead(pinButt)==LOW) { // button is pressed, start keydown management
        keydown = true;
        if(pinFbck!=PushButton::NOPIN) digitalWrite(pinFbck,HIGH);
        return false;
    }

    return false;
}
