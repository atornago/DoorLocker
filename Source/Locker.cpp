#include <Arduino.h>
#include <EEPROM.h>
#include "Keypad.h"
#include "Locker.h"

#define EEPROMSIGNLEN   6        // lenght of EEPROM signature text
#define WAITFORKEYSTIMEOUT  6000 // seconds to wait until timeout, reset at each key pressed
#define VISUALFEEDBACKDELAY 3000 // delay for visual feedback on error/success


// this is the signature that must be found in EEPROM in order
// to get rid of random values coming from uninitialized memory
static byte EEPROMSignature[EEPROMSIGNLEN] = {'L','O','C','K','E','R' };



Locker::Locker(Keypad *kpad,byte errorPin, byte successPin) {
    // move input values into class variables, and make
    // needed initializations
    pad = kpad;             // this is the pointer to keypad matrix object
    secretIndex = 0;        // this points to the next chat to read in order to form the secret code
    pinError = errorPin;    // pin number used to provide visual feedback for errors
    pinSuccess = successPin;// pin number used to provide visual feedback for success

    // initialize the pins, only if they are valid pin numbers
    if(errorPin!=Locker::NOPIN) pinMode(errorPin,OUTPUT);
    if(successPin!=Locker::NOPIN) pinMode(successPin,OUTPUT);

    int i; //this variable is used by two subsequent for-loops

    // check EEPROM signature and retrieve secret code
    for(i=0;i<6;i++) if(EEPROMSignature[i] != EEPROM.read(i)) {
      Serial.println("No signature in EEPROM.");
      hasSecretCode = false;
      return;
    }

    // if the execution flow until this point, it means that there is
    // a valid signature (with secret code) in EEPROM, then we retrieve it
    Serial.println("Signature found.");
    Serial.print("Secret code is: ");

    // found signature, read the secret code following the signature
    for(/*initial i value comes previous for loop*/ ;i-EEPROMSIGNLEN<SCODELEN;i++) {
            secretCode[i-EEPROMSIGNLEN] = EEPROM.read(i);
            Serial.print(secretCode[i-EEPROMSIGNLEN]);
    }
    Serial.println(".");
}


Locker::LockerReturns Locker::Loop() {
    char c;

    if((c = pad->Keypress()) != Keypad::NOCHAR) {

      Serial.print("char ");
      Serial.print(c);
      Serial.println(" pressed");

        if(stat == Locker::KEYIDLE){
            // we are at the beginning of a new input, let's prepare things
            // set the current state of the locker...
            stat = Locker::KEYINPUT;
            secretIndex = 0;
        }

        // every new key pressed, the locker allows the user to wait additional 5 seconds
        // until it considers the sequence terminated and the process aborted
        waitTime = millis()+WAITFORKEYSTIMEOUT;

        // store the key pressed in a temporary array for next use
        secretTest[secretIndex] = c;
        secretIndex++;

        if(secretIndex>=SCODELEN) {
            // we have collected enough chars that allows to check if the secret code is correct
            // if the secrect code is initialized will do the check, otherwise will use the code
            // as the new secrect code and we store it into EEPROM
            if(!hasSecretCode) {
                // noexisting secrect code, we use this one as the new secret code
                int i; // i variable used in next two for-loop
                for(i=0;i<EEPROMSIGNLEN;i++) EEPROM.write(i,EEPROMSignature[i]);
                for(/*initial i value from previous for-loop*/ ;i-EEPROMSIGNLEN<SCODELEN;i++) {
                    secretCode[i-EEPROMSIGNLEN] = secretTest[i-EEPROMSIGNLEN];
                    EEPROM.write(i,secretTest[i-EEPROMSIGNLEN]);
                }
                // now we have a secret code
                vFeedback(pinSuccess);
                hasSecretCode = true;
                secretIndex = 0;
                stat = Locker::KEYIDLE;
                return Locker::CODECHANGED;
            }

            // because we have a secret code then we
            // check if the secrect code inserted is correct or not
            for(int i=0;i<SCODELEN;i++)
                if(secretCode[i]!=secretTest[i]) {
                    // wrong code, reset all for next try
                    vFeedback(pinError);
                    secretIndex = 0;
                    stat = Locker::KEYIDLE;
                    return Locker::WRONGCODE;
                }

            // if the execution flows here, it means that we have a match
            // reset everithing for next run and return success
            vFeedback(pinSuccess);
            secretIndex = 0;
            stat = Locker::KEYIDLE;
            return Locker::SUCCESS;
        }

        // a key was pressed but the locker not collected already enought characters
        // to check the secret key, so it returns NOTHING
        return Locker::NOTHING;
    }

    // no key pressed, we need to check if the timeout has expired during a sequence
    // of input, if no sequence in progress, there is no need to signal wrong code event
    if(stat==Locker::KEYINPUT && waitTime<millis()) {
        // timeout expired, we treat this as a wrong secret key, we return
        // a wrongcode signal and we reset all to get ready for next sequence
        vFeedback(pinError);
        secretIndex = 0;
        stat = Locker::KEYIDLE;
        return Locker::WRONGCODE;
    }

    return Locker::NOTHING;
}


void Locker::ResetSecretCode() {
    // by putting the following variable to false we say that the secret code
    // stored in EEPROM is no more valid, during the next Loop function, the Locker
    // will ask for a new code that it will substitute the erased one
    hasSecretCode  = false;
}


void Locker::vFeedback(byte pin) {
    if(pin!= Locker::NOPIN) {
        digitalWrite(pin,HIGH);
        delay(VISUALFEEDBACKDELAY);
        digitalWrite(pin,LOW);
    }
}
