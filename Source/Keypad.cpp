#include <Arduino.h>
#include "Keypad.h"

#define USE_PULLUP 1

#if defined(USE_PULLUP)
#define LOWSIGNAL   HIGH
#define HIGHSIGNAL   LOW
#else
#define LOWSIGNAL    LOW
#define HIGHSIGNAL  HIGH
#endif

Keypad::Keypad(char *kmap,byte *pinrows,byte *pincols,byte rows,byte cols,byte ledpin,byte tonepin) {
    keyMap   = kmap;
    pinCols  = pincols;
    pinRows  = pinrows;
    nCols    = cols;
    nRows    = rows;
    pinLed   = ledpin;
    pinTone  = tonepin;
    stat     = KEYIDLE;

    // initialize Arduino Pins
#if defined(USE_PULLUP)
    for(int c=0;c<nCols;c++) pinMode(pincols[c],INPUT_PULLUP);
#else
    for(int c=0;c<nCols;c++) pinMode(pincols[c],INPUT);
#endif
    for(int r=0;r<nRows;r++) pinMode(pinrows[r],OUTPUT);

    if(pinLed!=NOPIN) pinMode(pinLed,OUTPUT);
}


char Keypad::WaitForKey(void) {
    char c;
    while((c=Keypress())==NOCHAR) delay(15);
    return c;
}


char Keypad::Keypress(bool waitForKeyUp) {
    int r,c;

    // the following code make sense in conjunction with the waitforKeyUp flag is false
    // when this routine is called in a loop until some key is pressed, useful
    // to allow the execution of additional task, instead of stay stuck waiting
    if(stat == KEYHOLD) {
        c = colHold;
        r = rowHold;
        goto hold__branch;
    }

    // for security purpose, send lowsignal to all pins in the matrix row
    for(r=0;r<nRows;r++) digitalWrite(*(pinRows+r),LOWSIGNAL);

    // now each row at a time, send a high signal, if exist some column with a high signal
    // it means that the pushbutton at the row,col coordinates is being pressed
    for(r=0;r<nRows;r++) {
        digitalWrite(*(pinRows+r),HIGHSIGNAL);
        for(c=0;c<nCols;c++) {
            if(digitalRead(*(pinCols+c)) == HIGHSIGNAL) {
                // pushbutton pressed at row,col coordinates
                // set the internal variable with the coordinated
                // this code make sense only if waitForKeyUp flag is false
                stat = KEYHOLD;
                rowHold = r;
                colHold = c;

                // generate light and sound for feedback, if requested
                if(pinLed!=NOPIN) digitalWrite(pinLed,HIGH);
                if(pinTone!=NOPIN) tone(pinTone,2000);

    hold__branch:

                // waits until the pushbutton is released
                // if waitForKeyUp is not set, returns immediately
                // it will handle the pushbutton release in the next round
                while(digitalRead(*(pinCols+c)) == HIGHSIGNAL) {
                    if(!waitForKeyUp) return NOCHAR;
                    delay(15);
                }

                // now the pushbutton has been released, it's time to
                // provide back the correspondent code in the matrix
                // firstly set signal down for that row
                stat = KEYIDLE;
                digitalWrite(*(pinRows+r),LOWSIGNAL);

                // turns off the light and sound feedback, if requested
                if(pinLed!=NOPIN) digitalWrite(pinLed,LOW);
                if(pinTone!=NOPIN) noTone(pinTone);

                // and finally returns the key pressed
                return *(keyMap+r*nCols+c);
            }
        }

        // if this line of code is executed, it means that no pushbutton is
        //pressed at the given row coordinates, so lower the signal again
        digitalWrite(*(pinRows+r),LOWSIGNAL);

    }

    // no pushbutton pressed, return a special value, which means no button pressed
    return NOCHAR;
}

