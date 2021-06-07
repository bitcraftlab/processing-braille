
// character height on screen
int size = 100;

// characters of our virtual braille line
int braillechars = 32;

// unicode codepoint of braille chars
int codepoint = 0x2800;

// start out with empty text
String txt = "";

// map braille codes to ascii
String brailleascii = " A1B'K2L@CIF/MSP\"E3H9O6R^DJG>NTQ,*5<-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=";

// use microsofts new code font
PFont createBrailleFont(int size) {
  return createFont("Cascadia Code", size, true);
}

// get unicode character
char brailleByte(int code) {
  return (char) (codepoint + code);
}

// ascii charcter to braille code
char brailleChar(char c) {
  char cup = Character.toUpperCase(c);
  int pos = brailleascii.indexOf(cup);
  if (pos >= 0) {
    return brailleByte(pos);
  } else {
    return 0;
  }
}


void setup() {

  // create a braille font
  PFont braille = createBrailleFont(size);

  // use the font for rendering text
  textFont(braille);

  // create the canvas
  size(1876, 100);

  // white foreground
  fill(255);
}

void draw() {
  // clear background
  background(0);
  
  // only show the last couple of chars
  int chars = txt.length();
  int showchars = min(chars, braillechars);
  String showtxt = txt.substring(chars - showchars);
  
  // render braille to the canvas
  text(showtxt, 0, size * 0.8);
}

void keyPressed() {
  
  // backspace removes chars
  if(keyCode == BACKSPACE) {
    int len = txt.length();
    if(len > 0) {
      txt = txt.substring(0, len - 1);
    }
  }
  
  // other keys add braille chars
  char c = brailleChar(key);
  if (c > 0) {
    txt += c;
  }
  
}
