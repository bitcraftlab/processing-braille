import java.util.Arrays;

// unicode codepoint of braille chars
int codepoint = 0x2800;
final char BRAILLE_SPACE = brailleChar(0);

// perkins keys on German keyboard
String perkinsKeys = "fdsjklaö";

// key states for reading perkins keys
final int KEY_UP = 0;
final int KEY_DOWN = 1;
final int KEY_RELEASED = 2;

// character height on screen
int size = 100;

// characters of our virtual braille line
int braillechars = 32;

// start out with empty text
String txt = "";

// amount of text to be shown
String showtxt = "";

int keyArray[] = new int[8];

// use microsofts new code font
PFont createBrailleFont(int size) {
  return createFont("Cascadia Code", size, true);
}

// get unicode character for braille code
char brailleChar(int code) {
  return (char) (codepoint + code);
}

// get braille code from unicode character
int charBraille(char ch) {
  return ((int) ch - codepoint);
}

void printByte(String label, byte b) {
    int unsignedByte = b & 0xFF;
    println(label, unsignedByte);
}

void setup() {

  // create a braille font
  PFont braille = createBrailleFont(size);

  // use the font for rendering text
  textFont(braille);

  // create the canvas
  size(1876, 100);

  setupSerial();
  
  noLoop();
  
}

void draw() {
  
  // clear background
  background(0);
  
  // white foreground
  fill(255);
  
  // render braille to the canvas
  text(showtxt, 0, size * 0.8);
  
}

void keyPressed() {
  
  // backspace removes chars  
  if(keyCode == BACKSPACE) {
    int len = txt.length();
    if(len > 0) {
      txt = txt.substring(0, len - 1);
      renderBraille();
    }
  }
  
  if(key == ' ') { 
    txt += BRAILLE_SPACE;
    renderBraille();
  }
  
  perkinsPressed(key);
 
      
}

void keyReleased() {
  perkinsReleased(key);
}

// ASDF__JKLÖ pressed
void perkinsPressed(char key) {
  int perkinsKey = perkinsKeys.indexOf(key);
  if(perkinsKey > - 1) {
    keyArray[perkinsKey] = KEY_DOWN;
  }
}

// ASDF__JKLÖ released
void perkinsReleased(char key) {
  
  int perkinsKey = perkinsKeys.indexOf(key);
  if(perkinsKey > - 1) {
    keyArray[perkinsKey] = KEY_RELEASED;
  }
  
  // have all the keys been released?
  boolean done = true;
  int code = 0;
  for(int i = 0; i < 8; i++) {
    switch(keyArray[i]) {
      case KEY_RELEASED:
        // add a bit to the code
        code |= 1<<i;
        break;
      case KEY_DOWN:
        // if a key is still pressed we are not done yet
        done = false;
    }
  }
  if(code == 0) done = false;
  
  // reset key array and append key to the text
  if(done) {

    // append character to text
    txt += brailleChar(code);
    resetKeyArray();
    renderBraille();    
    
  }

}


void renderBraille() {
  
  // only show the last couple of chars
  int chars = txt.length();
  
  int showchars = min(chars, braillechars);
  showtxt = txt.substring(chars - showchars);
  
   // render braille on screen
   redraw();
    
   // render braille to the console
   consoleBraille(showtxt); 
   
   // render braille to HIMS device
   outputBraille(showtxt);
}


void resetKeyArray() {
  for(int i = 0; i < 8; i++) {
    keyArray[i] = KEY_UP;
  }
}
