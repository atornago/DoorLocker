// ====================================================================================
// KEYPAD
//
// A class to read from a NxM pushbutton matrix and return the character code
// correspondent to the pushbutton pressed according to a transcodification matrix
// It also provides visible and audible feedback when a pushbutton is pressed
// Can be work in two possible ways: sync = wait for a key pressed forever
// and async - returns immediately even if no key is pressed
//
// ====================================================================================

#if !defined(KEYPAD_H)
#define KEYPAD_H

class Keypad {
  private:
    char *keyMap;   // matrix used to convert pressed keys into symbols
    byte *pinCols;  // list of pin used to map columns in the button matrix
    byte *pinRows;  // list of pin used to map rows in the button matrix
    byte  pinLed;   // pin used to hold on a led while a key is pressed
    byte  pinTone;  // pin used by tone() function to provide audible feedback
    byte  nCols;    // number of columns in the pushbutton matrix
    byte  nRows;    // number of rows in the pushbutton matrix

    byte  stat;     // instance current status, can be KEYIDLE or KEYHOLD
    byte  rowHold;  // row in which lays the pushbutton pressed, if stat == KEYHOLD
    byte  colHold;  // column in which lays the pushbutton pressed, if stat == KEYHOLD

    static const char KEYHOLD =  1;
    static const char KEYIDLE =  0;

  public:
    static const char NOCHAR =  (byte)-1;
    static const byte NOPIN   = (byte)-1;

    Keypad(char *kmap,byte *pinrows,byte *pincols,byte rows,byte cols,byte ledpin=NOPIN,byte tonepin=NOPIN);

    char Keypress(bool waitForKeyUp = true); // returns immediately, waitForKeyup allow wait for key up after press
    char WaitForKey(void);                   // returns only when a key is pressed, can wait forever!!!
};

#endif
