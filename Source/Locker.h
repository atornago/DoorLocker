// ====================================================================================
// LOCKER
//
// A class to implement a locker mechanism. The lock/unlock is executed via a secret
// code that must be inserted using a pushbutton matrix handled via Keypad class
//
// The Keypad class must be a 3x3 matrix that detects numbers from 1 to 9 used to
// create the secret code. The secret code is stored in EPROM.
// ====================================================================================


#if !defined(LOCKER_H)
#define LOCKER_H
#include "Keypad.h"

#define SCODELEN 4              // lenght of secret code in characters, increase to make a strong code


class Locker {
    private:
        Keypad *pad;                    // pointer to a Keypad object well initialized
        char    secretCode[SCODELEN];   // secret code retrieved and stored on EEPROM
        char    secretTest[SCODELEN];   // will be filled by the character inserted by the user
        byte    secretIndex;            // index in the secretTest array, incremented at each char received

        byte    stat;                   // status of the Locker
        unsigned long waitTime;         // timer used to avoid waiting forever for a secret code
        boolean hasSecretCode;          // flag to know if the secret code is initialized in EEPROM

        byte    pinError;               // already initialized pin for providing visual feedback, optional
        byte    pinSuccess;             // already initialized pin for providing visual feedback, optional

        static const byte KEYIDLE = -1; // waiting for keys
        static const byte KEYINPUT = 1; // at least one key received, waiting for next keys

        void vFeedback(byte pin);       // function that privides visual feedback on success and failure

   public:
        enum LockerReturns {
            NOTHING       = -1,         // nothing happened at locker
            WRONGCODE     =  0,         // the user made attempt with a wrong code, or timeout expired
            SUCCESS       =  1,         // the user inserted the right code
            CODECHANGED   =  2          // successfully we changed the secret code and store in EEPROM
        };

        static const byte NOPIN   = (byte)-1;

        // constructor, it needs a Keypad object to run and optional two pins with led attached
        // in order to provide viausl feedback, the pins will be initialized as OUTPUT
        Locker(Keypad *kpad,byte errorPin=NOPIN, byte successPin=NOPIN);
        Locker::LockerReturns Loop();   // main loop, it returns the status of the locker if changed
        void ResetSecretCode();         // delete the secrect code, the Locker will wait for a new code
};

#endif
