#if !defined(PUSHBUTTON_H)
#define PUSHBUTTON_H


class PushButton {
private:
        byte pinButt;   // pin associated to the button, will be initialized as INPUT_PULLUP
        byte pinFbck;   // pin associated to visual feedback for the button, can be NOPIN
        bool keydown;   // this will be true when the button is hold pressed by user

    public:
        static byte const NOPIN = (byte)-1;

        PushButton(byte pinButton,byte pinFeedback=NOPIN);
        bool Loop(); // return TRUE if the key was pressed, FALSE otherwhise
};












#endif
